Instructions for Copilot when performing a code review:

## 1. Separation of Concerns
- Keep logic decoupled. UI components should not handle raw data fetching; services should not handle UI state.
- Each function/class must have a single responsibility.

## 2. DRY (Don't Repeat Yourself)
- If a logic pattern appears more than once, suggest a reusable abstraction.
- Check the `/utils` or `/hooks` directories before creating new helper logic.

## 3. Code Review Protocol
- Critique PRs based on architectural integrity first.
- Ask: "Is this logic placed in the correct layer?" and "Can this be simplified by using existing patterns?"

Instructions for Copilot when writing code:

## 1. Avoid comments unless absolutely neccessary
- Do not write C# (CSharp) doc comments `///`
- Do not write method comments
- Consider writing a regular /* comment */ for a class ONLY if it is really neccessary
- Avoid using // comments in general unless they describe some really obscure mechanic, which is not readily apparent from code.
