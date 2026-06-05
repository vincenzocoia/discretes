---
title: 'discretes: Representing enumerable numeric series in R without listing their members'
tags:
  - R
  - discrete mathematics
  - probability
  - numerical computing
  - scientific computing
authors:
  - name: Vincenzo Coia
    orcid: 0000-0002-3028-4329
    corresponding: true
    affiliation: 1
  - name: Carlo De Michele
    orcid: 0000-0002-7098-4725
    affiliation: 1
affiliations:
  - name: C2E Lab, Department of Civil and Environmental Engineering (DICA), Politecnico di Milano, Milan, Italy
    index: 1
date: 5 June 2026
bibliography: paper.bib
---

# Summary

Many computations need to describe a set of numbers that is countable but too large to store. A clear example is the set of values a discrete random variable can take: a Poisson variable can be any of $0, 1, 2, \ldots$, without end. A computer cannot hold infinitely many numbers, and in R there is no built-in way to write down `0:Inf` and work with
it. The **discretes** package represents such sets — it calls them *numeric
series* — by storing the rule that generates a series rather than its members. A
series can be traversed one value at a time, tested for membership, counted over
an interval, combined with other series, and transformed by arithmetic, all
without ever listing its elements. Where a choice has to be made, discretes
follows the rules R already uses for ordinary numeric vectors, so that a series
behaves the way a vector would if a vector could be infinite.

# Statement of need

discretes was written for the probaverse project [@probaverse], a set of R packages that treat probability distributions as first-class objects. A central goal there is to support any distribution a user might construct, not only named families. Most named distributions with a discrete component — Poisson, geometric, hypergeometric — live on the natural numbers [@JohnsonKotzKemp], and it is tempting to assume every discrete support does. That assumption breaks as soon as distributions are shifted, scaled, or combined, which is exactly what applied modelling requires. To reason about an arbitrary distribution we have to answer concrete questions about its support: What is the next admissible value above a cutoff? Are there finitely or infinitely many outcomes between two points? Is a particular number an outcome at all?

Base R has finite numeric vectors and sequence helpers (`seq()`, `:`), but no type for an infinite enumerable set that can be transformed and queried consistently. The usual workarounds — store a long prefix of the values, hard-code the support of each named distribution, or quietly truncate the set — are fragile, and they tend to fail near the values that matter most, such as a limit the series approaches. discretes provides this missing abstraction, and although it was written for probability, it is a general-purpose tool for enumerable numeric series.

# State of the field

Several R packages address neighbouring problems. Zseq [@Zseq] supplies named integer sequences such as the Fibonacci and prime numbers, but not a general way to construct and transform series. sets [@sets] implements finite set operations and abstract set algebra, with no notion of successor and predecessor along the number line. set6 [@set6] offered object-oriented infinite sets but is no longer on CRAN and was not built around agreement with R's numeric-vector behaviour. peruse [@peruse] iterates over general sequences with a well-defined starting value, with less attention to arithmetic manipulation and limit points. discretes was written as its own layer rather than as a wrapper over these because its target object is a locally enumerable numeric series — closed under operations commonly applied to numeric vectors, and explicit about the floating-point cases (signed zero, infinities) that those operations expose.

# Software design

## What the package represents

discretes does not try to represent every countable set of numbers. Infinitely dense sets such as the rationals are excluded, because they have no well-defined "next" value: every real number is a limit point of the rationals. What discretes does handle is series whose values are isolated except at a finite number of limit points. Following the package's shorthand, we call these limit points *sinks*. The natural numbers $0, 1, 2, \ldots$ have a single sink, at infinity. The series $1, 1/2, 1/4, \ldots$ has a sink at $0$, approached from the right. Allowing finitely many sinks covers the supports that arise in practice while keeping every series finitely describable.

## Two base series, then manipulation

Every series is built from one of two base forms. The first is an *arithmetic
series*, stored as a seed value, a spacing, and the number of steps to take left
and right of the seed; either count may be infinite, which is how a base series
acquires a sink. The integers, the natural numbers, and any evenly spaced grid
are arithmetic series. The second is an explicit *numeric vector*. A finite set of
values often has no generating pattern — the outcomes can be scattered anywhere
among the reals — so the vector itself is stored and treated as a series.

From these two forms, new series are built by manipulation: union of several
series; the arithmetic operations `+`, `-`, `*`, `/`, and exponentiation; functions such as
`log` and `exp`; trimming a series to an interval; and arbitrary transformations,
including non-monotonic ones, through `dsct_transform()`. This is a deliberately
small set of primitives, but composing them reaches a large majority of the
numeric series one actually needs.

It does not reach all of them. Sequences with their own bespoke logic, such as the Fibonacci numbers, could have been supported but were left out on purpose: the aim was to cover the common cases well, not to chase every constructible set. (The Fibonacci example also makes a point about sets. Although the sequence is written $1, 1, 2, 3, 5, \ldots$, a set holds each value once, so the two discrete values above $0$ are $1$ and $2$, not $1$ and $1$.)

This mirrors how the rest of probaverse is built. The distionary package supplies
base distributions and distplyr manipulates and combines them; the named families
act like a few axes through the space of all distributions, and manipulation
fills in the space between them. discretes applies the same idea one level down,
to the numeric series that describe distribution supports.

## Querying without enumerating

A numeric series answers a fixed set of questions, and these define the contract that every series type must satisfy: `next_discrete()` and `prev_discrete()` to
traverse, `num_discretes()` to count the values in an interval, `has_discretes()` to test membership, and `has_sink_at()` / `has_sink_in()` to report limit points.

The same contract is what makes manipulation work. A transformation is itself a new series whose definition happens to refer to another series. Because it is a series, it implements the same contract, and it answers a query by querying the series underneath it. Wrapping manipulations on top of one another builds a ladder of these objects; a query descends the ladder until it reaches a base series — an arithmetic series or a vector — where the question can be answered directly. The package uses S3 method dispatch for this, with one method per series type for each generic. Traversal is defined directly for each type rather than, say, treating a backward step as a forward step on a negated series, which would invite infinite recursion on composed objects.

## Congruence with base R

One rule runs through the package: a series should behave exactly as a numeric
vector would. Whenever an operation has an established meaning for vectors,
discretes defers to it rather than inventing a parallel convention. R defines
$0^0$ as $1$, for instance, so a series does the same, and results keep R's
integer type where a vector would.

Making this precise requires separating two views of a series: its *encoding* — the parameters that define it, such as a seed, spacing, and step counts for arithmetic series, or the original vector — and its *expression*, the actual numeric values R produces when
the series is realized. Operations that need a concrete answer are delegated to R
on the expressed values.

## Signed zero

The clearest case where encoding and expression must be kept apart is signed
zero. In IEEE-754 arithmetic R has both $+0$ and $-0$; `identical(0, -0)` is
`TRUE`, and mathematically there is only one zero, so a series containing both
still reports a single value. But the two are not interchangeable: `1 / 0` is
`Inf` while `1 / -0` is `-Inf` [@Goldberg1991]. (The difference is visible in the raw bytes:
`writeBin(-0, raw())` sets the sign bit, giving `00 00 00 00 00 00 00 80`, as opposed to all zeros for $+0$.) A series that expressed itself as a single $0$ would invert to a single infinity and silently lose the other. discretes therefore tracks the latent signs with `has_positive_zero()` and `has_negative_zero()`: the set $\{0, -0\}$ is one value when enumerated, but its reciprocal is the two-value series $\{-\infty, +\infty\}$ (infinities are themselves allowed as discrete values). Getting this right is not pedantry — it is what lets inversion of a support agree with the inversion R would perform on the corresponding vector.

# Research impact

discretes is released on CRAN under the MIT license, documented with a pkgdown site and four vignettes — two introducing the construction and querying of series, two covering the finer points of numerical tolerance and signed zero — and tested with an extensive testthat suite that checks the series' behavioural contracts, including the sink and signed-zero cases [@discretes_repo]. Its current use is for probaverse, where it represents distribution supports so that downstream code can combine models and run computations on precise outcomes rather than numerically derived values. This is a concrete present application rather than a speculative one: infinite-but-regular supports are routine in discrete modeling, and handling their limits and floating-point edge cases correctly is a prerequisite for dependable simulation and inference.

# AI usage disclosure

Generative AI assisted with drafting and editing this manuscript. The authors reviewed every technical statement and design description for accuracy. Generative AI was not used to make the core design decisions for the discretes software itself, nor to decide on the content of this article.

# Acknowledgements

Development of discretes was supported by the European Space Agency, BGC
Engineering Inc., and the Politecnico di Milano. The need for the package arose
from work on the probaverse project. The authors thank colleagues who reviewed
package behaviour and documentation during open development.

# References

