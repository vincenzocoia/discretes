### Traversal contract for `discretes` subclasses

- **Both directions are required.** Implement `next_discrete()` and
  `prev_discrete()` for every subclass. The sequence owner already knows how
  forward/backward steps should behave, even for unusual constructions such as
  Fibonacci-like streams or concatenated series.

- **Linear transforms don’t infer direction.** Scale/shift wrappers choose
  whether to call `next_discrete()` or `prev_discrete()` based on the sign of
  their scale. They do not attempt to synthesize a “negated series.”

- **Fallback stays optional.** `prev_discrete.default()` can continue to mirror
  via negation for classes where that is genuinely correct, but it should be
  treated as a convenience, not the primary mechanism.

This contract keeps asymmetric or composite sequences in control of their own
reverse traversal and prevents negative scaling from relying on ad hoc negation
to locate prior terms.

