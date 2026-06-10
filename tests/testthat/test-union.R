test_that("+0 and -0 combined takes first instance.", {
  expect_equal(1 / get_discretes_in(dsct_union(0, -0)), Inf)
  expect_equal(1 / get_discretes_in(dsct_union(-0, 0)), -Inf)
  xboth1 <- dsct_union(arithmetic(-0, 1), arithmetic(0, 1))
  expect_equal(1 / get_discretes_in(xboth1, from = 0, to = 0), -Inf)
  xboth2 <- dsct_union(arithmetic(0, 1), arithmetic(-0, 1))
  expect_equal(1 / get_discretes_in(xboth2, from = 0, to = 0), Inf)
  # While a series containing only -0 and +0 has only one value,
  # the inverse of this series will have two: -Inf and Inf. This is because
  # all components of the discrete series remains intact until expression
  # as a vector via `get_discretes_in()`.
  expect_equal(get_discretes_in(1 / dsct_union(0, -0)), c(-Inf, Inf))
})


test_that("dsct_union merges symmetric discrete series", {
  x <- dsct_union(natural1(), -natural1())
  expect_s3_class(x, "discretes")
  expect_identical(
    next_discrete(x, from = -2.5, n = 5L),
    c(-2L, -1L, 1L, 2L, 3L)
  )
  expect_identical(
    prev_discrete(x, from = 2.5, n = 5L),
    c(2L, 1L, -1L, -2L, -3L)
  )
  expect_identical(num_discretes(x, from = -3, to = 3), 6L)
  expect_false(has_discretes(x, values = 0))
})

test_that("dsct_union recognises duplicates and numeric support", {
  x <- dsct_union(c(-2, 0, 2, 2), natural1())
  expect_identical(
    get_discretes_in(x, from = -2, to = 3),
    c(-2, 0, 1, 2, 3)
  )
  expect_true(all(has_discretes(x, values = c(-2, 0, 1))))
  expect_false(has_discretes(x, values = -3))

  expect_identical(dsct_union(), empty_series())
  expect_identical(dsct_union(integers(), empty_series()), integers())
  expect_identical(
    dsct_union(
      dsct_union(integers(1, 5), integers(10, 15)),
      empty_series(),
      -natural1()
    ),
    dsct_union(
      integers(1, 5),
      integers(10, 15),
      -natural1()
    )
  )
})

test_that("dsct_union detects infinite support", {
  x <- dsct_union(natural1(), c(-5, -4))
  expect_true(num_discretes(x) == Inf)
})

test_that("dsct_union has_discretes follows union semantics with NA inputs", {
  x <- dsct_union(c(NA, 1), natural1())
  expect_identical(
    has_discretes(x, values = c(1, 2, NA)),
    c(TRUE, TRUE, NA)
  )
})

test_that("dsct_union representative draws from combined support", {
  x <- dsct_union(natural1(), -natural1())
  expect_true(has_discretes(x, values = representative(x)))
  y <- dsct_union(c(-4, -2), 5)
  expect_true(representative(y) %in% c(-4, -2, 5))
})

test_that("dsct_union edge cases", {
  expect_identical(num_discretes(dsct_union(integers(), NA_real_)), Inf)
  expect_identical(
    num_discretes(dsct_union(integers(-10, 10), NA_real_)),
    NA_integer_
  )
  expect_identical(
    num_discretes(dsct_union(empty_series(), empty_series())),
    0L
  )
  expect_error(dsct_union(integers(), 1:10, "hello"))
  expect_error(dsct_union(integers(), 1:10, sum))
  expect_identical(dsct_union(), empty_series())
})

test_that("walking a union with an interior accumulation point (sink)", {
  # Regression: querying a union from a point below a component whose atoms
  # accumulate at a finite sink (no smallest atom) used to map to an inverted
  # base interval and trip an assertion. The ranges below are intentionally
  # wider than the functions' images (which warns), so that the query at 2
  # exercises the runtime guard rather than the early range check.
  suppressWarnings({
    below <- dsct_transform(
      natural1(),
      fun = function(n) 5 - 2^(-n),
      inv = function(y) -log2(5 - y),
      domain = c(0, Inf),
      range = c(0, 5),
      dir = "increasing"
    ) # 4.5, 4.75, ... -> 5 from below
    above <- dsct_transform(
      natural1(),
      fun = function(n) 5 + 2^(-n),
      inv = function(y) -log2(y - 5),
      domain = c(0, Inf),
      range = c(5, Inf),
      dir = "decreasing"
    ) # 5.5, 5.25, ... -> 5 from above
  })
  both <- dsct_union(below, above)

  expect_equal(next_discrete(both, 2), 4.5)
  expect_equal(next_discrete(both, 4.4), 4.5)
  expect_equal(next_discrete(both, 2, n = 3), c(4.5, 4.75, 4.875))
  expect_equal(prev_discrete(both, 6), 5.5)
  expect_equal(get_discretes_in(both, from = 4, to = 4.9), c(4.5, 4.75, 4.875))
  expect_equal(num_discretes(both, from = 2, to = 4.9), 3L)
})

test_that("transform counts 0 for a range inside [range] but below the atoms", {
  # `2` is inside the declared range [0, 5] but below every atom (4.5, 4.75,
  # ...), so it maps to an empty base interval and should count 0, not error.
  # The over-wide range warns at construction; suppress it to focus on counting.
  below <- suppressWarnings(dsct_transform(
    natural1(),
    fun = function(n) 5 - 2^(-n),
    inv = function(y) -log2(5 - y),
    domain = c(0, Inf),
    range = c(0, 5),
    dir = "increasing"
  ))
  expect_equal(num_discretes(below, from = -Inf, to = 2), 0L)
  expect_equal(num_discretes(below, from = -Inf, to = 4.6), 1L)
})
