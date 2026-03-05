# Contributing to discretes

Thank you for considering contributing to discretes! This document
provides guidelines and instructions for contributing to the package.

## Code of Conduct

Please note that this project is released with a [Code of
Conduct](https://discretes.netlify.app/CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## How Can I Contribute?

### Reporting Bugs

If you find a bug, please open an issue on
[GitHub](https://github.com/vincenzocoia/discretes/issues) with:

- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Your R session info (output of
  [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html))
- A minimal reproducible example (reprex)

You can create a reprex using the [reprex
package](https://reprex.tidyverse.org/), for example.

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an
enhancement suggestion, please include:

- A clear, descriptive title
- A detailed description of the proposed enhancement
- Explanation of why this enhancement would be useful
- Examples of how the enhancement would be used

If your suggestion is about adding a new distribution family, please
indicate why you think the family is significant enough to be included.

### Pull Requests

We welcome pull requests! Here’s the process:

1.  **Fork the repository** and clone it locally.
2.  **Create a branch** for your changes.
3.  **Make your changes** following the coding style guidelines.
4.  **Write or update tests** to cover your changes.
5.  **Run checks** locally.
6.  **Update documentation** including roxygen2 comments and vignettes
    if needed.
7.  **Commit your changes** with clear, descriptive commit messages.
8.  **Push to your fork** and submit a pull request to the `development`
    branch.

## Coding Style

discretes follows the [tidyverse style
guide](https://style.tidyverse.org/). Key points:

- Use `<-` for assignment, not `=`
- Use `snake_case` for function and variable names
- Keep lines to a maximum of 80 characters
- Add spaces around operators (`x + y`, not `x+y`)
- Add spaces after commas (`f(x, y)`, not `f(x,y)`)

### Documentation Style

- All exported functions must have complete roxygen2 documentation
- Include `@param` for all parameters with clear descriptions
- Include `@returns` describing what the function returns
- Include `@examples` with working examples
- Use proper markdown formatting in documentation

## Questions?

If you have questions about contributing, please contact the maintainer:
Vincenzo Coia (<vincenzo.coia@gmail.com>).

## Life Cycle Statement

This package is

``` R
  - in an initially stable state of development, with minor
    subsequent development envisioned.
```

## Design Decisions

### Traversal contract for `discretes` subclasses

- **Both directions are required.** Implement
  [`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
  and
  [`prev_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
  for every subclass. Do not code
  [`prev_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
  as walking forward on the negated series, to avoid infinite recursion.
  The sequence owner already knows how forward/backward steps should
  behave, even for unusual constructions such as Fibonacci-like streams
  or concatenated series.

- \*\*num_discretes(), has_discretes(), representative(), and
  has\_\*\_zero()\*\* S3 methods are also expected for a new series.

Ensure these are coded so as to avoid recursion loops.

### Accommodating Infinity

Infinity as discrete values is supported in the discretes package.
Reasons why:

- `Inf` and `-Inf` are naturally occurring members of numeric vectors,
  and will be encountered in the wild.
- The closed set of real numbers is a mathematically understood and
  valid concept.
- Some day in the future, probability distributions containing infinity
  as an outcome may be included in probaverse, which the discretes
  package is intended to serve.
- Although more complicated to include, the absence of infinity as an
  outcome feels like a noticeable hole in the package that compromises
  quality, not serving the 90% of use cases for the package.

Notes:

- `+0` and `-0` will need to be tracked explicitly, since they are
  treated as identical in R. Behaviour around signed zero will copy the
  behaviour of numeric vectors in base R.
- Only allowing `Inf` and `-Inf` in numeric vectors and not in
  “discretes” objects (like arithmetic series) causes inconsistencies:
  `1 / dsct_union(0, natural1())` should give the same result as
  `1 / natural0()`, yet it would not.
- Sketchy internal logic would be required when testing whether `Inf` or
  `-Inf` are members of the series, especially under an inverse series:
  - Checking membership of their inverse checks membership of `0` in the
    base series, since there is no distinguishing between `+0` and `-0`.
  - If only numeric vectors are allowed, then clunky logic would be
    needed: if ever a numeric vector is encountered, then invert the
    numeric vector itself and check for `-Inf` and `Inf`.
- When a user inputs a numeric vector to act as a “discretes” object,
  it’s important to *not* process the vector first, by operations like
  [`unique()`](https://rdrr.io/r/base/unique.html). One reason is
  because of +0 or -0: these would collapse to one of the two under
  [`unique()`](https://rdrr.io/r/base/unique.html), after which
  inversion would result in only one of `Inf` or `-Inf` rather than
  both.
