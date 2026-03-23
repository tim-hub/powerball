# Verification Report Format

## Summary Scorecard

```
## Verification Report: <change-name>

### Summary
| Dimension    | Status           |
|--------------|------------------|
| Completeness | X/Y tasks, N reqs|
| Correctness  | M/N reqs covered |
| Coherence    | Followed/Issues  |
```

## Issues by Priority

1. **CRITICAL** (Must fix before archive):
   - Incomplete tasks
   - Missing requirement implementations
   - Each with specific, actionable recommendation

2. **WARNING** (Should fix):
   - Spec/design divergences
   - Missing scenario coverage
   - Each with specific recommendation

3. **SUGGESTION** (Nice to fix):
   - Pattern inconsistencies
   - Minor improvements
   - Each with specific recommendation

## Final Assessment

- If CRITICAL issues: "X critical issue(s) found. Fix before archiving."
- If only warnings: "No critical issues. Y warning(s) to consider. Ready for archive (with noted improvements)."
- If all clear: "All checks passed. Ready for archive."

## Output Format Rules

- Table for summary scorecard
- Grouped lists for issues (CRITICAL/WARNING/SUGGESTION)
- Code references in format: `file.ts:123`
- Specific, actionable recommendations
- No vague suggestions like "consider reviewing"
