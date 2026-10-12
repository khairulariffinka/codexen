// Unit tests for core/.opencode/plugin/context-monitor.ts (mock client, no network)
// Run: (cd core/.opencode && npm install) && node tests/test-context-monitor.mts   (Node >= 22.18)
import { ContextMonitor } from "../core/.opencode/plugin/context-monitor.ts"
import * as mod from "../core/.opencode/plugin/context-monitor.ts"
const logs: any[] = [], toasts: any[] = []
const msgs: any[] = []
const client: any = {
  config: { providers: async () => ({ data: { providers: [{ id: "anthropic", models: { "m1": { limit: { context: 100000 } } } }] } }) },
  app: { log: async (o: any) => { logs.push(o.body) } },
  tui: { showToast: async (o: any) => { toasts.push(o.body) } },
  session: { messages: async () => ({ data: msgs }) },
}
let fails = 0
const ok = (c: boolean, m: string) => { console.log((c ? "PASS " : "FAIL ") + m); if (!c) fails++ }
ok(Object.keys(mod).length === 1, "only one export: " + Object.keys(mod))
const h: any = await ContextMonitor({ client } as any)
const am = (id: string, input: number, cr = 0, out = 0, cost = 0.01) => ({ id, sessionID: "s1", role: "assistant", providerID: "anthropic", modelID: "m1", cost, tokens: { input, output: out, reasoning: 0, cache: { read: cr, write: 0 } } })
const fire = (info: any) => h.event({ event: { type: "message.updated", properties: { info } } })
const run = async () => h.tool.check_context.execute({ detailed: true }, { sessionID: "s1" })
// repeated updates of same message should not double count
for (let i = 0; i < 5; i++) await fire(am("a1", 1000, 40000, 500))
let r = await run(); console.log(r)
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
// failing client
const bad: any = { config: { providers: async () => { throw 1 } }, app: { log: async () => { throw 1 } }, session: { messages: async () => { throw 1 } } }
const hb: any = await ContextMonitor({ client: bad } as any)
await hb.event({ event: { type: "message.updated", properties: { info: am("x", 190000) } } })
r = await hb.tool.check_context.execute({}, { sessionID: "s1" }); ok(r.includes("/ 200.0K"), "failing client -> default limit, no throw")
await h.event({ event: { type: "session.error", properties: { sessionID: "s1", error: { name: "UnknownError", data: { message: "prompt is too long: context overflow" } } } } })
ok(logs.some(l => /overflow/.test(l.message)), "overflow logged")
process.exit(fails ? 1 : 0)
