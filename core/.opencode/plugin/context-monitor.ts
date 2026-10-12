import type { Plugin } from "@opencode-ai/plugin"
import { tool } from "@opencode-ai/plugin"

// NOTE: Only export the plugin function. OpenCode treats every exported
// function in a plugin file as a plugin, so helpers must stay module-private.

interface TokenSnapshot {
  input: number
  output: number
  reasoning: number
  cache: { read: number; write: number }
}

interface SessionState {
  // Tokens of the latest assistant message = current context window size
  last: TokenSnapshot
  // Sum of cost across assistant messages (keyed by message ID, so repeated
  // message.updated events for the same message never double-count)
  costByMessage: Map<string, number>
  providerID?: string
  modelID?: string
  triggered: Set<number>
}

type Action = "warn" | "checkpoint" | "compress" | "critical"

const THRESHOLDS: { percent: number; action: Action; hint: string }[] = [
  { percent: 70, action: "warn", hint: "Context getting full — plan to wrap up or checkpoint soon." },
  { percent: 80, action: "checkpoint", hint: "Run @checkpoint-writer to save session state." },
  { percent: 90, action: "compress", hint: "Compact the session (/compact) after checkpointing." },
  { percent: 95, action: "critical", hint: "Context almost full — checkpoint and compact NOW." },
]

const DEFAULT_CONTEXT_LIMIT = 200_000

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

export const ContextMonitor: Plugin = async (ctx) => {
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
      const data = unwrap<any>(await ctx.client.config.providers())
      const provider = data?.providers?.find((p: any) => p.id === providerID)
      const limit = Number(provider?.models?.[modelID]?.limit?.context) || 0
      if (limit > 0) {
        limitCache.set(key, limit)
        return limit
      }
    } catch {
      // fall through to default
    }
    return DEFAULT_CONTEXT_LIMIT
  }

  function ingest(info: any): string | undefined {
    if (!info || info.role !== "assistant" || !info.tokens || !info.sessionID) return
    const s = state(info.sessionID)
    const snap = toSnapshot(info.tokens)
    // Ignore empty in-progress updates so they don't reset the reading to 0
    if (contextTotal(snap) > 0) s.last = snap
    if (info.id) s.costByMessage.set(info.id, Number(info.cost) || 0)
    if (info.providerID) s.providerID = info.providerID
    if (info.modelID) s.modelID = info.modelID
    return info.sessionID
  }

  async function safeLog(level: "info" | "warn" | "error", message: string, extra: Record<string, unknown>) {
    try {
      await ctx.client.app.log({ body: { service: "context-monitor", level, message, extra } })
    } catch {}
  }

  async function safeToast(variant: "warning" | "error", message: string) {
    try {
      await (ctx.client as any).tui?.showToast?.({
        body: { title: "Context Monitor", message, variant, duration: 8000 },
      })
    } catch {}
  }

  async function checkThresholds(sessionID: string) {
    const s = state(sessionID)
    const limit = await contextLimit(s.providerID, s.modelID)
    const total = contextTotal(s.last)
    const percent = percentOf(total, limit)

    // Context shrank (e.g. after compaction) — re-arm thresholds above it
    for (const p of [...s.triggered]) if (percent < p) s.triggered.delete(p)

    // Only fire the highest newly-crossed threshold to avoid toast spam
    const crossed = THRESHOLDS.filter((t) => percent >= t.percent && !s.triggered.has(t.percent))
    if (crossed.length === 0) return
    crossed.forEach((t) => s.triggered.add(t.percent))
    const top = crossed[crossed.length - 1]
    const msg = `Context ${percent}% (${formatTokens(total)}/${formatTokens(limit)}) — ${top.hint}`
    await safeLog(top.action === "critical" ? "error" : "warn", msg, {
      sessionID,
      percent,
      action: top.action,
    })
    await safeToast(top.action === "critical" || top.action === "compress" ? "error" : "warning", msg)
  }

  async function refreshFromApi(sessionID: string) {
    try {
      const data = unwrap<any[]>(await ctx.client.session.messages({ path: { id: sessionID } }))
      if (!Array.isArray(data)) return
      for (const m of data) ingest(m?.info)
    } catch {
      // keep event-based state
    }
  }

  return {
    event: async ({ event }) => {
      const e = event as any
      if (e.type === "message.updated") {
        // Plugin hooks: properties.info; tolerate legacy properties.message and v2 data.info
        const sessionID = ingest(e.properties?.info ?? e.properties?.message ?? e.data?.info)
        if (sessionID) await checkThresholds(sessionID)
        return
      }
      if (e.type === "session.deleted") {
        const id = e.properties?.info?.id
        if (id) sessions.delete(id)
        return
      }
      if (e.type === "session.error") {
        const err = e.properties?.error
        const text = `${err?.name ?? ""} ${err?.data?.message ?? err?.message ?? ""}`
        if (/context|overflow|too long|maximum.*tokens/i.test(text)) {
          await safeLog("error", "Context overflow detected", {
            sessionID: e.properties?.sessionID,
            error: text.trim(),
          })
        }
      }
    },

    tool: {
      check_context: tool({
        description: "Check current context usage — shows tokens, percentage, and cost estimate",
        args: {
          detailed: tool.schema.boolean().optional().describe("Show breakdown by category"),
          sessionID: tool.schema.string().optional().describe("Session ID to check (defaults to current)"),
        },
        async execute(args, context) {
          const sessionID = args.sessionID || context.sessionID
          await refreshFromApi(sessionID)
          const s = state(sessionID)
          const limit = await contextLimit(s.providerID, s.modelID)
          const total = contextTotal(s.last)
          const percent = percentOf(total, limit)
          const cost = [...s.costByMessage.values()].reduce((a, b) => a + b, 0)

          let out = `**Context Usage**\n`
          out += `• Model: ${s.providerID && s.modelID ? `${s.providerID}/${s.modelID}` : "unknown"}\n`
          out += `• Context: ${formatTokens(total)} / ${formatTokens(limit)} (${percent}%)\n`
          out += `• Session cost: $${cost.toFixed(4)}\n`

          if (args.detailed) {
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
          }
          return out
        },
      }),
    },
  }
}
