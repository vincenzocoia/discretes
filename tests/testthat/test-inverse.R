test_that("walking on inverse series works", {
  # Function to build an inverse set from a collection of numeric vectors in
  # `...` and test walking the series against `expect` (which doesn't need
  # to be sorted). Tests each n from 0 to the provided one,
  # except when n = Inf, in which case it just tests the provided n.
  expect_next <- function(base, from, inc, expect) {
    dsct <- 1 / as_discretes(base)
    fwd <- sort(expect)
    n <- length(expect) + 1
    n_set <- append(seq_len(n), Inf)
    for (i in n_set) {
      this_next <- next_discrete(
        dsct,
        from = from,
        n = i,
        include_from = inc
      )
      testthat::expect_equal(this_next, head(fwd, i))
    }
    nd <- num_discretes(
      dsct,
      from = from,
      to = ifelse(length(expect), max(expect), Inf),
      include_from = inc,
      include_to = TRUE
    )
    testthat::expect_equal(nd, length(expect))
    testthat::expect_true(all(has_discretes(dsct, values = expect)))
    fnte <- expect[is.finite(expect)]
    testthat::expect_true(all(!has_discretes(dsct, values = fnte + 1e-5)))
    invisible()
  }
  expect_prev <- function(base, from, inc, expect) {
    dsct <- 1 / as_discretes(base)
    expect <- sort(expect, decreasing = TRUE)
    n <- length(expect) + 1
    n_set <- append(seq_len(n), Inf)
    for (i in n_set) {
      this_prev <- prev_discrete(
        dsct,
        from = from,
        n = i,
        include_from = inc
      )
      testthat::expect_equal(this_prev, head(expect, i))
    }
    nd <- num_discretes(
      dsct,
      from = ifelse(length(expect), min(expect), -Inf),
      to = from,
      include_from = TRUE,
      include_to = inc
    )
    testthat::expect_equal(nd, length(expect))
    testthat::expect_true(all(has_discretes(dsct, values = expect)))
    fnte <- expect[is.finite(expect)]
    testthat::expect_true(!any(has_discretes(dsct, values = fnte + 1e-5)))
    invisible()
  }
  
  neg <- c(-0.2, -2)
  pos <- c(0.2, 2)
  
  # Start with the whole gamut
  x <- c(-Inf, neg, -0, 0, pos, Inf)
  expect_true(has_positive_zero(1 / as_discretes(x)))
  expect_true(has_negative_zero(1 / as_discretes(x)))
  expect_next(
    x,
    from = -Inf,
    inc = TRUE,
    expect = c(-Inf, 1 / neg, 0, 1 / pos, Inf)
  )
  expect_next(x, from = -Inf, inc = FALSE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = TRUE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = FALSE, expect = c(-0.5, 0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = TRUE, expect = c(0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = FALSE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = TRUE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = FALSE, expect = c(5, Inf))
  expect_next(x, from = Inf, inc = TRUE, expect = Inf)
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(
    x,
    from = Inf,
    inc = TRUE,
    expect = c(Inf, 1 / pos, 0, 1 / neg, -Inf)
  )
  expect_prev(x, from = Inf, inc = FALSE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = TRUE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = FALSE, expect = c(0.5, 0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = TRUE, expect = c(0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = FALSE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = TRUE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = FALSE, expect = c(-5, -Inf))
  expect_prev(x, from = -Inf, inc = TRUE, expect = -Inf)
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  # Remove -Inf from base -- same answers because of the presence of +Inf,
  # but loses -0
  x <- c(neg, -0, 0, pos, Inf)
  expect_true(has_positive_zero(1 / as_discretes(x)))
  expect_false(has_negative_zero(1 / as_discretes(x)))
  expect_next(
    x,
    from = -Inf,
    inc = TRUE,
    expect = c(-Inf, 1 / neg, 0, 1 / pos, Inf)
  )
  expect_next(x, from = -Inf, inc = FALSE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = TRUE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = FALSE, expect = c(-0.5, 0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = TRUE, expect = c(0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = FALSE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = TRUE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = FALSE, expect = c(5, Inf))
  expect_next(x, from = Inf, inc = TRUE, expect = Inf)
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(
    x,
    from = Inf,
    inc = TRUE,
    expect = c(Inf, 1 / pos, 0, 1 / neg, -Inf)
  )
  expect_prev(x, from = Inf, inc = FALSE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = TRUE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = FALSE, expect = c(0.5, 0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = TRUE, expect = c(0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = FALSE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = TRUE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = FALSE, expect = c(-5, -Inf))
  expect_prev(x, from = -Inf, inc = TRUE, expect = -Inf)
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  # Remove Inf from base -- same answers because of the presence of -Inf,
  # but loses +0
  x <- c(-Inf, neg, -0, 0, pos)
  expect_false(has_positive_zero(1 / as_discretes(x)))
  expect_true(has_negative_zero(1 / as_discretes(x)))
  expect_next(
    x,
    from = -Inf,
    inc = TRUE,
    expect = c(-Inf, 1 / neg, 0, 1 / pos, Inf)
  )
  expect_next(x, from = -Inf, inc = FALSE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = TRUE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = FALSE, expect = c(-0.5, 0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = TRUE, expect = c(0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = FALSE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = TRUE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = FALSE, expect = c(5, Inf))
  expect_next(x, from = Inf, inc = TRUE, expect = Inf)
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(
    x,
    from = Inf,
    inc = TRUE,
    expect = c(Inf, 1 / pos, 0, 1 / neg, -Inf)
  )
  expect_prev(x, from = Inf, inc = FALSE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = TRUE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = FALSE, expect = c(0.5, 0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = TRUE, expect = c(0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = FALSE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = TRUE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = FALSE, expect = c(-5, -Inf))
  expect_prev(x, from = -Inf, inc = TRUE, expect = -Inf)
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  # Remove both infinities from the base -- 0 goes away in the result.
  x <- c(neg, -0, 0, pos)
  expect_false(has_positive_zero(1 / as_discretes(x)))
  expect_false(has_negative_zero(1 / as_discretes(x)))
  expect_next(
    x,
    from = -Inf,
    inc = TRUE,
    expect = c(-Inf, 1 / neg, 1 / pos, Inf)
  )
  expect_next(x, from = -Inf, inc = FALSE, expect = c(1 / neg, 1 / pos, Inf))
  expect_next(x, from = -5, inc = TRUE, expect = c(1 / neg, 1 / pos, Inf))
  expect_next(x, from = -5, inc = FALSE, expect = c(-0.5, 1 / pos, Inf))
  expect_next(x, from = 0, inc = TRUE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0, inc = FALSE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = TRUE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = FALSE, expect = c(5, Inf))
  expect_next(x, from = Inf, inc = TRUE, expect = Inf)
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(
    x,
    from = Inf,
    inc = TRUE,
    expect = c(Inf, 1 / pos, 1 / neg, -Inf)
  )
  expect_prev(x, from = Inf, inc = FALSE, expect = c(1 / pos, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = TRUE, expect = c(1 / pos, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = FALSE, expect = c(0.5, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = TRUE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = 0, inc = FALSE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = TRUE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = FALSE, expect = c(-5, -Inf))
  expect_prev(x, from = -Inf, inc = TRUE, expect = -Inf)
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  # Remove +0 -- lose +Inf.
  x <- c(-Inf, neg, -0, pos, Inf)
  expect_next(x, from = -Inf, inc = TRUE, expect = c(-Inf, 1 / neg, 0, 1 / pos))
  expect_next(x, from = -Inf, inc = FALSE, expect = c(1 / neg, 0, 1 / pos))
  expect_next(x, from = -5, inc = TRUE, expect = c(1 / neg, 0, 1 / pos))
  expect_next(x, from = -5, inc = FALSE, expect = c(-0.5, 0, 1 / pos))
  expect_next(x, from = 0, inc = TRUE, expect = c(0, 1 / pos))
  expect_next(x, from = 0, inc = FALSE, expect = c(1 / pos))
  expect_next(x, from = 0.5, inc = TRUE, expect = c(1 / pos))
  expect_next(x, from = 0.5, inc = FALSE, expect = 5)
  expect_next(x, from = Inf, inc = TRUE, expect = numeric())
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(x, from = Inf, inc = TRUE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = Inf, inc = FALSE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = TRUE, expect = c(1 / pos, 0, 1 / neg, -Inf))
  expect_prev(x, from = 5, inc = FALSE, expect = c(0.5, 0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = TRUE, expect = c(0, 1 / neg, -Inf))
  expect_prev(x, from = 0, inc = FALSE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = TRUE, expect = c(1 / neg, -Inf))
  expect_prev(x, from = -0.5, inc = FALSE, expect = c(-5, -Inf))
  expect_prev(x, from = -Inf, inc = TRUE, expect = -Inf)
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  # Remove -0 -- lose -Inf.
  x <- c(-Inf, neg, 0, pos, Inf)
  expect_next(x, from = -Inf, inc = TRUE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -Inf, inc = FALSE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = TRUE, expect = c(1 / neg, 0, 1 / pos, Inf))
  expect_next(x, from = -5, inc = FALSE, expect = c(-0.5, 0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = TRUE, expect = c(0, 1 / pos, Inf))
  expect_next(x, from = 0, inc = FALSE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = TRUE, expect = c(1 / pos, Inf))
  expect_next(x, from = 0.5, inc = FALSE, expect = c(5, Inf))
  expect_next(x, from = Inf, inc = TRUE, expect = Inf)
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(x, from = Inf, inc = TRUE, expect = c(Inf, 1 / pos, 0, 1 / neg))
  expect_prev(x, from = Inf, inc = FALSE, expect = c(1 / pos, 0, 1 / neg))
  expect_prev(x, from = 5, inc = TRUE, expect = c(1 / pos, 0, 1 / neg))
  expect_prev(x, from = 5, inc = FALSE, expect = c(0.5, 0, 1 / neg))
  expect_prev(x, from = 0, inc = TRUE, expect = c(0, 1 / neg))
  expect_prev(x, from = 0, inc = FALSE, expect = c(1 / neg))
  expect_prev(x, from = -0.5, inc = TRUE, expect = c(1 / neg))
  expect_prev(x, from = -0.5, inc = FALSE, expect = -5)
  expect_prev(x, from = -Inf, inc = TRUE, expect = numeric())
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  # Remove both zeroes -- lose both Infs
  x <- c(-Inf, neg, pos, Inf)
  expect_next(x, from = -Inf, inc = TRUE, expect = c(1 / neg, 0, 1 / pos))
  expect_next(x, from = -Inf, inc = FALSE, expect = c(1 / neg, 0, 1 / pos))
  expect_next(x, from = -5, inc = TRUE, expect = c(1 / neg, 0, 1 / pos))
  expect_next(x, from = -5, inc = FALSE, expect = c(-0.5, 0, 1 / pos))
  expect_next(x, from = 0, inc = TRUE, expect = c(0, 1 / pos))
  expect_next(x, from = 0, inc = FALSE, expect = c(1 / pos))
  expect_next(x, from = 0.5, inc = TRUE, expect = c(1 / pos))
  expect_next(x, from = 0.5, inc = FALSE, expect = 5)
  expect_next(x, from = Inf, inc = TRUE, expect = numeric())
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(x, from = Inf, inc = TRUE, expect = c(1 / pos, 0, 1 / neg))
  expect_prev(x, from = Inf, inc = FALSE, expect = c(1 / pos, 0, 1 / neg))
  expect_prev(x, from = 5, inc = TRUE, expect = c(1 / pos, 0, 1 / neg))
  expect_prev(x, from = 5, inc = FALSE, expect = c(0.5, 0, 1 / neg))
  expect_prev(x, from = 0, inc = TRUE, expect = c(0, 1 / neg))
  expect_prev(x, from = 0, inc = FALSE, expect = c(1 / neg))
  expect_prev(x, from = -0.5, inc = TRUE, expect = c(1 / neg))
  expect_prev(x, from = -0.5, inc = FALSE, expect = -5)
  expect_prev(x, from = -Inf, inc = TRUE, expect = numeric())
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  # All positive; ensure negative cases don't get triggered
  x <- pos
  expect_next(x, from = -Inf, inc = TRUE, expect = 1 / pos)
  expect_next(x, from = -1, inc = TRUE, expect = 1 / pos)
  expect_next(x, from = 0, inc = TRUE, expect = 1 / pos)
  expect_next(x, from = 0.5, inc = TRUE, expect = 1 / pos)
  expect_next(x, from = 0.5, inc = FALSE, expect = 5)
  expect_next(x, from = 10, inc = TRUE, expect = numeric())
  expect_next(x, from = 10, inc = FALSE, expect = numeric())
  expect_next(x, from = Inf, inc = TRUE, expect = numeric())
  expect_next(x, from = Inf, inc = FALSE, expect = numeric())
  
  expect_prev(x, from = Inf, inc = TRUE, expect = 1 / pos)
  expect_prev(x, from = 10, inc = TRUE, expect = 1 / pos)
  expect_prev(x, from = 0.5, inc = TRUE, expect = 0.5)
  expect_prev(x, from = 0.5, inc = FALSE, expect = numeric())
  expect_prev(x, from = 0, inc = TRUE, expect = numeric())
  expect_prev(x, from = -10, inc = TRUE, expect = numeric())
  expect_prev(x, from = -Inf, inc = TRUE, expect = numeric())

  # All negative; ensure positive cases don't get triggered
  x <- neg
  expect_prev(x, from = Inf, inc = TRUE, expect = 1 / neg)
  expect_prev(x, from = 1, inc = TRUE, expect = 1 / neg)
  expect_prev(x, from = 0, inc = TRUE, expect = 1 / neg)
  expect_prev(x, from = -0.5, inc = TRUE, expect = 1 / neg)
  expect_prev(x, from = -0.5, inc = FALSE, expect = -5)
  expect_prev(x, from = -10, inc = TRUE, expect = numeric())
  expect_prev(x, from = -10, inc = FALSE, expect = numeric())
  expect_prev(x, from = -Inf, inc = TRUE, expect = numeric())
  expect_prev(x, from = -Inf, inc = FALSE, expect = numeric())
  
  expect_next(x, from = -Inf, inc = TRUE, expect = 1 / neg)
  expect_next(x, from = -10, inc = TRUE, expect = 1 / neg)
  expect_next(x, from = -0.5, inc = TRUE, expect = -0.5)
  expect_next(x, from = -0.5, inc = FALSE, expect = numeric())
  expect_next(x, from = 0, inc = TRUE, expect = numeric())
  expect_next(x, from = 10, inc = TRUE, expect = numeric())
  expect_next(x, from = Inf, inc = TRUE, expect = numeric())
  
  # The above have been tested on as_discretes(); try on something else.
  x <- 1 / integers()
  expect_equal(next_discrete(x, from = 2), Inf)
  expect_equal(prev_discrete(x, from = -2), numeric())
  expect_equal(next_discrete(x, from = 0.99), 1)
  expect_equal(prev_discrete(x, from = -0.99), -1)
  expect_equal(prev_discrete(x, from = 1.1, n = 5), 1 / (1:5))
  expect_equal(next_discrete(x, from = -1.1, n = 5), -1 / (1:5))
  
  # Try adding a sink on the positive side and negative side: walking the
  # series should stop.
  y <- 1 / dsct_union(natural0(), -1, Inf)
  expect_equal(next_discrete(y, from = -Inf, n = Inf), c(-1, 0))
  y <- 1 / dsct_union(-1 - 1 / natural0(), -1, -0.5)
  expect_equal(next_discrete(y, from = -Inf, n = Inf), c(-2, -1))
  y <- 1 / dsct_union(-natural0(), 1, -Inf)
  expect_equal(prev_discrete(y, from = Inf, n = Inf), c(1, 0))
  y <- 1 / dsct_union(1 + 1 / natural0(), 1, 0.5)
  expect_equal(prev_discrete(y, from = Inf, n = Inf), c(2, 1))
})
