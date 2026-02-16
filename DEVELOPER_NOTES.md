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

### Accomodating Infinity

Should infinity be supported in the discretes package?

Reasons in favour:

- `Inf` and `-Inf` are naturally occurring members of numeric vectors, and will
  be encountered in the wild.
- The closed set of real numbers is a mathematically understood and valid
  concept.
- Some day in the future, probability distributions containing infinity as an
  outcome may be included in probaverse, which the discretes package is intended
  to serve.
- Although more complicated to include, the absence of infinity as an outcome
  feels like a noticeable hole in the package that compromises quality,
  not serving the 90% of use cases for the package.
  
Notes:

- `+0` and `-0` will need to be tracked explicitly, since they are treated as
  identical to R.
- Only allowing `Inf` and `-Inf` in numeric vectors and not in "discretes"
  objects (like arithmetic series) causes inconsistencies:
  `1 / dsct_union(0, natural1())` should give the same result as
  `1 / natural0()`, yet it would not.
- Sketchy internal logic would be required when testing whether `Inf` or `-Inf`
  are members of the series, especially under an inverse series:
  - Checking membership of their inverse checks membership of `0` in the base
    series, since there is no distinguishing between `+0` and `-0`.
  - If only numeric vectors are allowed, then clunky logic would be needed:
    if ever a numeric vector is encountered, then invert the numeric vector
    itself and check for `-Inf` and `Inf`.

### Infinity, and preserving input vectors

When a user inputs a numeric vector to act as a "discretes" object, it's
important to _not_ process the vector first, by operations like `unique()`.
One reason is because of +0 or -0: these would collapse to one of the two
under `unique()`, after which inversion would result in only one of `Inf` or
`-Inf` rather than both.

### Negative Zero

R supports both `-0` and `+0` (of type double), where the sign gets expressed
upon inversion (`-Inf`, `Inf`). R recognizes the vector `c(-0, 0)` as having
one `unique()` value, whereas its reciprocal has two.

The discretes package aims to be consistent with how R would handle discrete
value series as if they were vectors. Operations are therefore delegated to
the vector form of the series. This will preserve `-0` and `+0` behaviour.

### Preventing loops

- test_discretes is the lowest level and cannot rely on any other functions.
- num_discretes can rely on test_discretes.
- next_discrete and prev_discrete can rely on num_discretes and test_discretes,
  but not on each other.
- non-generics like as.numeric() can use any of the above functions.