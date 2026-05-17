## Advisor Strategy

**HIGHEST PRIORITY rule. Apply before starting any non-trivial task.**

The executor drives all tasks end-to-end. Opus is the advisor — consulted for planning and hard decisions only, never for routine execution.

### Model assignment

| Task | Model | Effort |
|------|-------|--------|
| Planning (any non-trivial task) | Opus | xHigh or Max |
| Hard tradeoff / uncertain approach | Opus | xHigh or Max |
| Running test scripts / bash scripts etc | Haiku | default |
| Routine execution, tool calls, iteration | executor model (default Sonnet) | default |

**Always use Opus for planning.** Before committing to an approach on any non-trivial task, invoke `powerball-personal:senior` (Opus) to produce the plan. Never plan in Sonnet and proceed — escalate first.

**Always set effort to xHigh or Max when invoking Opus.** A cheap Opus call defeats the purpose. Enable extended thinking when the option is available.

**Use Haiku to trigger test and bash scripts.** Haiku handles script invocation and result collection; return output to the Sonnet executor for interpretation.

### How the advisor responds
Returns a plan, correction, or stop signal — not tool calls, not user-facing output. You resume execution after receiving guidance.

### When to escalate mid-task
- Hard tradeoffs with no clear winner
- A plan feels wrong but you can't articulate why
- Novel problem where missteps are costly

**The inversion:** you are the driver, Opus is a consultant. Escalate only the hard part, not the whole task.
