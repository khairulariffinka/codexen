// Unit tests for core/.opencode/plugins/context-monitor.ts (mock client, no network)
// Covers both adapters: OpenCode v1 (`server`) and v2 (`setup`).
// Run: (cd core/.opencode && npm install) && node tests/test-context-monitor.mts   (Node >= 22.18)
import plugin from "../core/.opencode/plugins/context-monitor.ts"
import * as mod from "../core/.opencode/plugins/context-monitor.ts"
import { readFileSync } from "node:fs"

let fails = 0
const ok = (c: boolean, m: string) => { console.log((c ? "PASS " : "FAIL ") + m); if (!c) fails++ }

// ── module shape (v1 + v2 loaders) ─────────────────────────────────────────
ok(Object.keys(mod).length === 1 && "default" in mod, "only a default export: " + Object.keys(mod))
ok(typeof plugin.id === "string" && plugin.id.length > 0, "has id (required by v1 path plugins and v2)")
ok(typeof plugin.server === "function", "v1: server() function")
ok(typeof plugin.setup === "function", "v2: setup() function")
const src = readFileSync(new URL("../core/.opencode/plugins/context-monitor.ts", import.meta.url), "utf8")
ok(!/^import\s+(?!type\b)/m.test(src), "no runtime top-level imports (v2 needs no npm deps)")

// ── v1 ─────────────────────────────────────────────────────────────────────
console.log("\n# v1 adapter")
const logs: any[] = [], toasts: any[] = []
const msgs: any[] = []
const client: any = {
  config: { providers: async () => ({ data: { providers: [{ id: "anthropic", models: { "m1": { limit: { context: 100000 } } } }] } }) },
  app: { log: async (o: any) => { logs.push(o.body) } },
  tui: { showToast: async (o: any) => { toasts.push(o.body) } },
  session: { messages: async () => ({ data: msgs }) },
}
const h: any = await plugin.server({ client } as any)
const am = (id: string, input: number, cr = 0, out = 0, cost = 0.01) => ({ id, sessionID: "s1", role: "assistant", providerID: "anthropic", modelID: "m1", cost, tokens: { input, output: out, reasoning: 0, cache: { read: cr, write: 0 } } })
const fire = (info: any) => h.event({ event: { type: "message.updated", properties: { info } } })
const run = async () => h.tool.check_context.execute({ detailed: true }, { sessionID: "s1" })
// repeated updates of same message should not double count
for (let i = 0; i < 5; i++) await fire(am("a1", 1000, 40000, 500))
let r = await run()
ok(r.includes("41.5K / 100.0K (42%)"), "snapshot not cumulative, real limit used")
ok(r.includes("$0.0100"), "cost deduped per message")
ok(toasts.length === 0, "no toast below 70%")
await fire({ ...am("a2", 1000, 74000, 0), }); ok(toasts.length === 1 && /75%/.test(toasts[0].message), "70% warn toast")
await fire(am("a2", 1000, 74000, 100)); ok(toasts.length === 1, "no repeat toast same threshold")
await fire(am("a3", 1000, 95000, 0)); ok(toasts.length === 2 && toasts[1].variant === "error" && /critical|NOW/.test(toasts[1].message), "jump to 96% fires only top threshold")
await fire(am("a4", 1000, 20000, 0)); await fire(am("a5", 1000, 80000, 0)); ok(toasts.length === 3, "re-armed after compaction")
// empty in-progress update should not reset
await fire({ ...am("a6", 0, 0, 0), cost: 0 }); r = await run(); ok(r.includes("81.0K"), "empty update ignored")
// legacy shape
await h.event({ event: { type: "message.updated", properties: { message: { ...am("b1", 5000), sessionID: "s2" } } } })
r = await h.tool.check_context.execute({}, { sessionID: "s2" }); ok(r.includes("5.0K"), "legacy properties.message supported")
// user message ignored
await fire({ id: "u1", sessionID: "s1", role: "user" }); ok(true, "user message no crash")
// api refresh when no events (plugin loaded mid-session)
msgs.push({ info: { ...am("c1", 2000, 10000), sessionID: "s3" } })
r = await h.tool.check_context.execute({}, { sessionID: "s3" }); ok(r.includes("12.0K"), "refresh from session API")
// session.compacted resets the reading
await h.event({ event: { type: "session.compacted", properties: { sessionID: "s2" } } })
r = await h.tool.check_context.execute({}, { sessionID: "s2" }); ok(r.includes("Context: 0 /"), "v1 session.compacted resets context")
// failing client
const bad: any = { config: { providers: async () => { throw 1 } }, app: { log: async () => { throw 1 } }, session: { messages: async () => { throw 1 } } }
const hb: any = await plugin.server({ client: bad } as any)
await hb.event({ event: { type: "message.updated", properties: { info: am("x", 190000) } } })
r = await hb.tool.check_context.execute({}, { sessionID: "s1" }); ok(r.includes("/ 200.0K"), "failing client -> default limit, no throw")
await h.event({ event: { type: "session.error", properties: { sessionID: "s1", error: { name: "UnknownError", data: { message: "prompt is too long: context overflow" } } } } })
ok(logs.some(l => /overflow/.test(l.message)), "overflow logged")

// ── v2 ─────────────────────────────────────────────────────────────────────
console.log("\n# v2 adapter")
// Minimal async event bus standing in for ctx.event.subscribe({ signal })
function bus() {
  const queue: any[] = []; let wake: (() => void) | undefined
  return {
    emit(e: any) { queue.push(e); wake?.() },
    subscribe({ signal }: { signal: AbortSignal }) {
      return (async function* () {
        while (!signal.aborted) {
          if (queue.length) { yield queue.shift(); continue }
          await new Promise<void>((res) => { wake = res; signal.addEventListener("abort", () => res(), { once: true }) })
          wake = undefined
        }
      })()
    },
  }
}
const tick = () => new Promise((res) => setTimeout(res, 5))
const ev = bus()
const tools: any[] = []
const context2: any[] = []
const warned: string[] = []
const origWarn = console.warn, origErr = console.error
console.warn = (m: string) => { warned.push(String(m)) }
console.error = (m: string) => { warned.push(String(m)) }
const ctx: any = {
  event: { subscribe: (o: any) => ev.subscribe(o) },
  model: { list: async () => ({ location: {}, data: [{ id: "m2", providerID: "openai", limit: { context: 50000 } }] }) },
  session: { context: async () => context2 },
  tool: { transform: async (cb: any) => { cb({ add: (t: any) => tools.push(t) }) } },
}
const cleanup: any = await plugin.setup(ctx)
ok(typeof cleanup === "function", "v2 setup returns cleanup")
const t2 = tools.find((t) => t.name === "check_context")
ok(!!t2 && t2.input?.type === "object", "v2 check_context tool registered with JSON schema")
const run2 = async (sessionID = "v1s", detailed = true) => (await t2.execute({ detailed }, { sessionID })).content as string
const tok = (input: number, cr = 0, out = 0) => ({ input, output: out, reasoning: 0, cache: { read: cr, write: 0 } })
ev.emit({ type: "session.model.selected", data: { sessionID: "v1s", model: { id: "m2", providerID: "openai" } } })
ev.emit({ type: "session.step.ended", data: { sessionID: "v1s", assistantMessageID: "am1", finish: "stop", cost: 0.02, tokens: tok(1000, 9000, 500) } })
await tick()
r = await run2()
ok(r.includes("openai/m2") && r.includes("10.5K / 50.0K (21%)"), "v2 step.ended tokens + model.list limit")
ok(r.includes("$0.0200"), "v2 cost from step.ended")
ok(/v2/.test(r), "v2 report notes log-only alerts")
ev.emit({ type: "session.step.ended", data: { sessionID: "v1s", assistantMessageID: "am2", finish: "stop", cost: 0.01, tokens: tok(1000, 40000) } })
await tick()
ok(warned.some((w) => /Context 82%/.test(w) && /checkpoint-writer/.test(w)), "v2 threshold alert logged (82% -> checkpoint)")
// model unknown (plugin loaded mid-session) -> looked up via ctx.session.context
context2.push({ id: "x1", type: "assistant", model: { id: "m2", providerID: "openai" }, tokens: tok(500, 4500), cost: 0.005 })
ev.emit({ type: "session.step.ended", data: { sessionID: "v2s", assistantMessageID: "x1", finish: "stop", cost: 0.005, tokens: tok(500, 4500) } })
await tick()
r = await run2("v2s", false)
ok(r.includes("openai/m2") && r.includes("5.0K / 50.0K (10%)"), "v2 model resolved from session.context")
// threshold alert (not just the report) must use the real limit when model came only from session.context
context2.length = 0
context2.push({ id: "y1", type: "assistant", model: { id: "m2", providerID: "openai" } })
const before = warned.length
ev.emit({ type: "session.step.ended", data: { sessionID: "v3s", assistantMessageID: "y1", finish: "stop", cost: 0, tokens: tok(1000, 39000) } })
await tick()
ok(warned.slice(before).some((w) => /Context 80%/.test(w) && /v3s/.test(w)), "v2 alert uses looked-up model limit (80% of 50K, not 20% of 200K)")
ev.emit({ type: "session.compaction.ended", data: { sessionID: "v1s", reason: "auto", text: "", recent: "" } })
await tick()
context2.length = 0
r = await run2("v1s", false); ok(r.includes("Context: 0 /"), "v2 session.compaction.ended resets context")
ev.emit({ type: "session.step.failed", data: { sessionID: "v1s", error: { message: "maximum context length exceeded" } } })
await tick()
ok(warned.some((w) => /overflow/i.test(w)), "v2 overflow logged")
ev.emit({ type: "garbage" }); ev.emit(null); await tick(); ok(true, "v2 unknown/null events ignored")
cleanup(); await tick(); ok(true, "v2 cleanup aborts subscription")
console.warn = origWarn; console.error = origErr

process.exit(fails ? 1 : 0)
