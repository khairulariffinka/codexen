// CodeXen Context Monitor — one file for OpenCode v1 (>= 1.18.29) and v2.
//
// v1 calls `server(input)` and uses the returned hooks.
// v2 reads `id` + `setup(ctx)` and ignores `server`.
//
// Only `import type` at the top level: v2 never needs `@opencode-ai/plugin`, and
// v1 loads it lazily inside `server()` (installed from ~/.config/opencode/package.json).
// NOTE: keep a single (default) export — helpers must stay module-private.
import type { Hooks, PluginInput } from "@opencode-ai/plugin"

interface TokenSnapshot {
  input: number
  output: number
  reasoning: number
  cache: { read: number; write: number }
}

interface SessionState {
  // Tokens of the latest assistant message/step = current context window size
  last: TokenSnapshot
  // Cost keyed by message ID, so repeated updates never double-count
  costByMessage: Map<string, number>
  providerID?: string
  modelID?: string
  triggered: Set<number>
}

type Action = "warn" | "checkpoint" | "compress" | "critical"
type Level = "info" | "warn" | "error"

interface Host {
  version: "v1" | "v2"
  limit(providerID: string, modelID: string): Promise<number | undefined>
  // Assistant messages normalised to { id, sessionID, providerID, modelID, tokens, cost }
  messages(sessionID: string): Promise<any[]>
  log(level: Level, message: string, extra: Record<string, unknown>): Promise<void>
  toast(variant: "warning" | "error", message: string): Promise<void>
}

const THRESHOLDS: { percent: number; action: Action; hint: string }[] = [
  { percent: 70, action: "warn", hint: "Context getting full — plan to wrap up or checkpoint soon." },
  { percent: 80, action: "checkpoint", hint: "Run @checkpoint-writer to save session state." },
  { percent: 90, action: "compress", hint: "Compact the session (/compact) after checkpointing." },
  { percent: 95, action: "critical", hint: "Context almost full — checkpoint and compact NOW." },
]

const DEFAULT_CONTEXT_LIMIT = 200_000
const TOOL_DESCRIPTION = "Check current context usage — shows tokens, percentage, and cost estimate"
const OVERFLOW = /context|overflow|too long|maximum.*tokens/i

function emptySnapshot(): TokenSnapshot {
  return { input: 0, output: 0, reasoning: 0, cache: { read: 0, write: 0 } }
}

function toSnapshot(tokens: any): TokenSnapshot {
  return {
    input: Number(tokens?.input) || 0,
    output: Number(tokens?.output) || 0,
    reasoning: Number(tokens?.reasoning) || 0,
    cache: {
      read: Number(tokens?.cache?.read) || 0,
      write: Number(tokens?.cache?.write) || 0,
    },
  }
}

function contextTotal(t: TokenSnapshot): number {
  return t.input + t.output + t.reasoning + t.cache.read + t.cache.write
}

function percentOf(total: number, limit: number): number {
  return limit > 0 ? Math.round((total / limit) * 100) : 0
}

function formatTokens(n: number): string {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000) return `${(n / 1_000).toFixed(1)}K`
  return String(n)
}

function unwrap<T = any>(res: any): T | undefined {
  // SDK returns { data, error } (fields style); tolerate raw values too
  if (res && typeof res === "object" && "data" in res) return res.data as T
  return res as T
}

// ── Shared core ─────────────────────────────────────────────────────────────

function createMonitor(host: Host) {
  const sessions = new Map<string, SessionState>()
  const limitCache = new Map<string, number>()

  function state(sessionID: string): SessionState {
    let s = sessions.get(sessionID)
    if (!s) {
      s = { last: emptySnapshot(), costByMessage: new Map(), triggered: new Set() }
      sessions.set(sessionID, s)
    }
    return s
  }

  async function contextLimit(providerID?: string, modelID?: string): Promise<number> {
    if (!providerID || !modelID) return DEFAULT_CONTEXT_LIMIT
    const key = `${providerID}/${modelID}`
    const cached = limitCache.get(key)
    if (cached) return cached
    try {
      const limit = Number(await host.limit(providerID, modelID)) || 0
      if (limit > 0) {
        limitCache.set(key, limit)
        return limit
      }
    } catch {
      // fall through to default
    }
    return DEFAULT_CONTEXT_LIMIT
  }

  // msg: { id?, sessionID, providerID?, modelID?, tokens?, cost? }
  function ingest(msg: any): string | undefined {
    if (!msg?.sessionID) return
    const s = state(msg.sessionID)
    if (msg.providerID) s.providerID = msg.providerID
    if (msg.modelID) s.modelID = msg.modelID
    if (!msg.tokens) return msg.sessionID
    const snap = toSnapshot(msg.tokens)
    // Ignore empty in-progress updates so they don't reset the reading to 0
    if (contextTotal(snap) > 0) s.last = snap
    if (msg.id) s.costByMessage.set(msg.id, Number(msg.cost) || 0)
    return msg.sessionID
  }

  function setModel(sessionID: string, providerID?: string, modelID?: string) {
    if (!sessionID) return
    const s = state(sessionID)
    if (providerID) s.providerID = providerID
    if (modelID) s.modelID = modelID
  }

  function compacted(sessionID: string) {
    if (sessionID) state(sessionID).last = emptySnapshot()
  }

  function forget(sessionID: string) {
    if (sessionID) sessions.delete(sessionID)
  }

  async function safeLog(level: Level, message: string, extra: Record<string, unknown>) {
    try {
      await host.log(level, message, extra)
    } catch {}
  }

  async function refresh(sessionID: string) {
    try {
      const list = await host.messages(sessionID)
      if (Array.isArray(list)) for (const m of list) ingest(m)
    } catch {
      // keep event-based state
    }
  }

  async function checkThresholds(sessionID: string) {
    const s = state(sessionID)
    // Plugin loaded mid-session (v2 step events carry no model): look it up once
    if (!s.modelID) await refresh(sessionID)
    const limit = await contextLimit(s.providerID, s.modelID)
    const total = contextTotal(s.last)
    const percent = percentOf(total, limit)

    // Context shrank (e.g. after compaction) — re-arm thresholds above it
    for (const p of [...s.triggered]) if (percent < p) s.triggered.delete(p)

    // Only fire the highest newly-crossed threshold to avoid alert spam
    const crossed = THRESHOLDS.filter((t) => percent >= t.percent && !s.triggered.has(t.percent))
    if (crossed.length === 0) return
    crossed.forEach((t) => s.triggered.add(t.percent))
    const top = crossed[crossed.length - 1]
    const msg = `Context ${percent}% (${formatTokens(total)}/${formatTokens(limit)}) — ${top.hint}`
    await safeLog(top.action === "critical" ? "error" : "warn", msg, { sessionID, percent, action: top.action })
    try {
      await host.toast(top.action === "critical" || top.action === "compress" ? "error" : "warning", msg)
    } catch {}
  }

  async function overflow(sessionID: string | undefined, text: string) {
    if (OVERFLOW.test(text)) await safeLog("error", "Context overflow detected", { sessionID, error: text.trim() })
  }

  async function report(sessionID: string, detailed?: boolean): Promise<string> {
    await refresh(sessionID)
    const s = state(sessionID)
    const limit = await contextLimit(s.providerID, s.modelID)
    const total = contextTotal(s.last)
    const percent = percentOf(total, limit)
    const cost = [...s.costByMessage.values()].reduce((a, b) => a + b, 0)

    let out = `**Context Usage**\n`
    out += `• Model: ${s.providerID && s.modelID ? `${s.providerID}/${s.modelID}` : "unknown"}\n`
    out += `• Context: ${formatTokens(total)} / ${formatTokens(limit)} (${percent}%)\n`
    out += `• Session cost: $${cost.toFixed(4)}\n`

    if (detailed) {
      out += `\n**Last turn breakdown**\n`
      out += `• Input: ${formatTokens(s.last.input)}\n`
      out += `• Cache read: ${formatTokens(s.last.cache.read)}\n`
      out += `• Cache write: ${formatTokens(s.last.cache.write)}\n`
      out += `• Output: ${formatTokens(s.last.output)}\n`
      out += `• Reasoning: ${formatTokens(s.last.reasoning)}\n`
      out += `\n**Thresholds**\n`
      for (const t of THRESHOLDS) {
        out += `• ${t.percent}% (${t.action}): ${percent >= t.percent ? "✓ reached" : "○"}\n`
      }
      if (host.version === "v2") out += `\n_OpenCode v2: threshold alerts go to the server log (no toast API for server plugins)._\n`
    }
    return out
  }

  return { ingest, setModel, compacted, forget, checkThresholds, overflow, report }
}

// ── v1 adapter ──────────────────────────────────────────────────────────────

function v1Message(info: any) {
  if (!info || info.role !== "assistant") return undefined
  return {
    id: info.id,
    sessionID: info.sessionID,
    providerID: info.providerID,
    modelID: info.modelID,
    tokens: info.tokens,
    cost: info.cost,
  }
}

async function serverV1(ctx: PluginInput): Promise<Hooks> {
  const client: any = ctx.client
  const monitor = createMonitor({
    version: "v1",
    async limit(providerID, modelID) {
      const data = unwrap<any>(await client.config.providers())
      const provider = data?.providers?.find((p: any) => p.id === providerID)
      return Number(provider?.models?.[modelID]?.limit?.context) || undefined
    },
    async messages(sessionID) {
      const data = unwrap<any[]>(await client.session.messages({ path: { id: sessionID } }))
      return Array.isArray(data) ? data.map((m) => v1Message(m?.info)).filter(Boolean) : []
    },
    async log(level, message, extra) {
      await client.app.log({ body: { service: "context-monitor", level, message, extra } })
    },
    async toast(variant, message) {
      await client.tui?.showToast?.({ body: { title: "Context Monitor", message, variant, duration: 8000 } })
    },
  })

  const { tool } = await import("@opencode-ai/plugin")

  return {
    event: async ({ event }) => {
      const e = event as any
      if (e.type === "message.updated") {
        // Plugin hooks: properties.info; tolerate legacy properties.message
        const sessionID = monitor.ingest(v1Message(e.properties?.info ?? e.properties?.message))
        if (sessionID) await monitor.checkThresholds(sessionID)
        return
      }
      if (e.type === "session.compacted") return monitor.compacted(e.properties?.sessionID)
      if (e.type === "session.deleted") return monitor.forget(e.properties?.info?.id)
      if (e.type === "session.error") {
        const err = e.properties?.error
        await monitor.overflow(e.properties?.sessionID, `${err?.name ?? ""} ${err?.data?.message ?? err?.message ?? ""}`)
      }
    },

    tool: {
      check_context: tool({
        description: TOOL_DESCRIPTION,
        args: {
          detailed: tool.schema.boolean().optional().describe("Show breakdown by category"),
          sessionID: tool.schema.string().optional().describe("Session ID to check (defaults to current)"),
        },
        async execute(args, context) {
          return monitor.report(args.sessionID || context.sessionID, args.detailed)
        },
      }),
    },
  }
}

// ── v2 adapter ──────────────────────────────────────────────────────────────

function v2Message(m: any) {
  if (!m || m.type !== "assistant") return undefined
  return {
    id: m.id,
    sessionID: m.sessionID,
    providerID: m.model?.providerID,
    modelID: m.model?.id,
    tokens: m.tokens,
    cost: m.cost,
  }
}

async function setupV2(ctx: any) {
  const monitor = createMonitor({
    version: "v2",
    async limit(providerID, modelID) {
      const res = await ctx.model.list()
      const list = unwrap<any[]>(res) ?? []
      const model = list.find((m: any) => m.providerID === providerID && m.id === modelID)
      return Number(model?.limit?.context) || undefined
    },
    async messages(sessionID) {
      const list = unwrap<any[]>(await ctx.session.context({ sessionID })) ?? []
      return list.map((m: any) => v2Message({ sessionID, ...m })).filter(Boolean)
    },
    async log(level, message, extra) {
      const line = `[codexen/context-monitor] ${message} ${JSON.stringify(extra)}`
      if (level === "error") console.error(line)
      else if (level === "warn") console.warn(line)
      else console.log(line)
    },
    async toast() {
      // No toast API for v2 server plugins (needs a separate CLI plugin)
    },
  })

  await ctx.tool.transform((editor: any) => {
    editor.add({
      name: "check_context",
      description: TOOL_DESCRIPTION,
      input: {
        type: "object",
        properties: {
          detailed: { type: "boolean", description: "Show breakdown by category" },
          sessionID: { type: "string", description: "Session ID to check (defaults to current)" },
        },
        additionalProperties: false,
      },
      async execute(input: any, context: any) {
        return { content: await monitor.report(input?.sessionID || context.sessionID, input?.detailed) }
      },
    })
  })

  const controller = new AbortController()
  const handle = async (e: any) => {
    const d = e?.data ?? {}
    switch (e?.type) {
      case "session.model.selected":
        return monitor.setModel(d.sessionID, d.model?.providerID, d.model?.id)
      case "session.step.ended":
        if (monitor.ingest({ id: d.assistantMessageID, sessionID: d.sessionID, tokens: d.tokens, cost: d.cost }))
          await monitor.checkThresholds(d.sessionID)
        return
      case "session.compaction.ended":
      case "session.compacted":
        return monitor.compacted(d.sessionID)
      case "session.deleted":
        return monitor.forget(d.sessionID)
      case "session.step.failed":
      case "session.execution.failed":
        return monitor.overflow(d.sessionID, JSON.stringify(d.error ?? d))
    }
  }

  ;(async () => {
    try {
      for await (const e of ctx.event.subscribe({ signal: controller.signal })) {
        try {
          await handle(e)
        } catch {}
      }
    } catch {
      // stream closed or aborted on unload
    }
  })()

  return () => controller.abort()
}

export default {
  id: "codexen-context-monitor",
  server: serverV1,
  setup: setupV2,
}
