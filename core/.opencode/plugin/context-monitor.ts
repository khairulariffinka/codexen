import type { Plugin } from "@opencode-ai/plugin"
import { tool } from "@opencode-ai/plugin"

interface TokenStats {
  input: number
  output: number
  reasoning: number
  cache: {
    read: number
    write: number
  }
}

interface ThresholdAction {
  percent: number
  action: "warn" | "checkpoint" | "compress" | "critical"
  triggered: boolean
}

const THRESHOLDS: ThresholdAction[] = [
  { percent: 70, action: "warn", triggered: false },
  { percent: 80, action: "checkpoint", triggered: false },
  { percent: 90, action: "compress", triggered: false },
  { percent: 95, action: "critical", triggered: false },
]

const DEFAULT_CONTEXT_LIMIT = 128000

function resetThresholds() {
  THRESHOLDS.forEach((t) => (t.triggered = false))
}

function calculateContextPercentage(tokens: TokenStats, limit: number): number {
  const total = tokens.input + tokens.output + tokens.reasoning
  return Math.round((total / limit) * 100)
}

function formatTokens(n: number): string {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000) return `${(n / 1_000).toFixed(1)}K`
  return String(n)
}

export const ContextMonitor: Plugin = async (ctx) => {
  const sessionStats = new Map<string, TokenStats>()
  const sessionLimits = new Map<string, number>()

  function getStats(sessionID: string): TokenStats {
    if (!sessionStats.has(sessionID)) {
      sessionStats.set(sessionID, {
        input: 0,
        output: 0,
        reasoning: 0,
        cache: { read: 0, write: 0 },
      })
    }
    return sessionStats.get(sessionID)!
  }

  function getContextLimit(sessionID: string, modelLimit?: number): number {
    if (modelLimit && modelLimit > 0) {
      sessionLimits.set(sessionID, modelLimit)
      return modelLimit
    }
    return sessionLimits.get(sessionID) || DEFAULT_CONTEXT_LIMIT
  }

  return {
    event: async ({ event }) => {
      if (event.type === "message.updated") {
        const message = event.properties?.message
        if (!message?.tokens) return

        const sessionID = message.sessionID || "unknown"
        const stats = getStats(sessionID)
        const tokens = message.tokens

        stats.input += tokens.input || 0
        stats.output += tokens.output || 0
        stats.reasoning += tokens.reasoning || 0
        stats.cache.read += tokens.cache?.read || 0
        stats.cache.write += tokens.cache?.write || 0

        const modelLimit = message.model?.limit?.context
        const limit = getContextLimit(sessionID, modelLimit)
        const total = stats.input + stats.output + stats.reasoning
        const percent = calculateContextPercentage(stats, limit)

        for (const threshold of THRESHOLDS) {
          if (!threshold.triggered && percent >= threshold.percent) {
            threshold.triggered = true

            await ctx.client.app.log({
              body: {
                service: "context-monitor",
                level: threshold.action === "critical" ? "error" : "warn",
                message: `Context ${percent}% — ${threshold.action} triggered`,
                extra: {
                  sessionID,
                  percent,
                  tokens: formatTokens(total),
                  limit: formatTokens(limit),
                  threshold: threshold.percent,
                },
              },
            })
          }
        }
      }

      if (event.type === "session.created") {
        resetThresholds()
      }

      if (event.type === "session.error") {
        const error = event.properties?.error
        if (error?.name === "ContextOverflowError") {
          await ctx.client.app.log({
            body: {
              service: "context-monitor",
              level: "error",
              message: "Context overflow detected",
              extra: { error: error.message },
            },
          })
        }
      }
    },

    tool: {
      check_context: tool({
        description:
          "Check current context usage — shows tokens, percentage, and cost estimate",
        args: {
          detailed: tool.schema
            .boolean()
            .optional()
            .describe("Show breakdown by category"),
          sessionID: tool.schema
            .string()
            .optional()
            .describe("Session ID to check (defaults to current)"),
        },
        async execute(args, context) {
          const sessionID = args.sessionID || context.sessionID
          const stats = getStats(sessionID)
          const limit = sessionLimits.get(sessionID) || DEFAULT_CONTEXT_LIMIT
          const total = stats.input + stats.output + stats.reasoning
          const percent = calculateContextPercentage(stats, limit)

          const cost =
            (stats.input * 0.003 + stats.output * 0.015) / 1_000_000

          let output = `**Context Usage**\n`
          output += `• Total: ${formatTokens(total)} / ${formatTokens(limit)} (${percent}%)\n`
          output += `• Input: ${formatTokens(stats.input)}\n`
          output += `• Output: ${formatTokens(stats.output)}\n`
          output += `• Reasoning: ${formatTokens(stats.reasoning)}\n`
          output += `• Cache Read: ${formatTokens(stats.cache.read)}\n`
          output += `• Cache Write: ${formatTokens(stats.cache.write)}\n`
          output += `• Est. Cost: $${cost.toFixed(4)}\n`

          if (args.detailed) {
            output += `\n**Thresholds**\n`
            for (const t of THRESHOLDS) {
              const status = t.triggered ? "✓" : "○"
              output += `• ${t.percent}% (${t.action}): ${status}\n`
            }
          }

          return output
        },
      }),
    },
  }
}

export default ContextMonitor
