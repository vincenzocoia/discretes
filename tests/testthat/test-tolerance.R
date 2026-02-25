test_that("zero tolerance for integers is meaningful - traversing", {
  # Numeric
  x <- c(4L, 1L, -5L, 9L)
  expect_identical(
    next_discrete(x, from = 1, n = Inf, include_from = TRUE, tol = 0),
    c(1L, 4L, 9L)
  )
  expect_identical(
    next_discrete(x, from = 1, n = Inf, include_from = FALSE, tol = 0),
    c(4L, 9L)
  )
  expect_identical(
    prev_discrete(x, from = 1, n = Inf, include_from = TRUE, tol = 0),
    c(1L, -5L)
  )
  expect_identical(
    prev_discrete(x, from = 1, n = Inf, include_from = FALSE, tol = 0),
    -5L
  )
  # Discretes
  x <- integers(-2, 4)
  expect_identical(
    next_discrete(x, from = 1, n = Inf, include_from = TRUE, tol = 0),
    c(1L, 2L, 3L, 4L)
  )
  expect_identical(
    next_discrete(x, from = 1, n = Inf, include_from = FALSE, tol = 0),
    c(2L, 3L, 4L)
  )
  expect_identical(
    prev_discrete(x, from = 1, n = Inf, include_from = TRUE, tol = 0),
    c(1L, 0L, -1L, -2L)
  )
  expect_identical(
    prev_discrete(x, from = 1L, n = Inf, include_from = FALSE, tol = 0),
    c(0L, -1L, -2L)
  )
})

test_that("tol affects arithmetic membership and walking", {
  x <- arithmetic(representative = 0, spacing = 0.1)

  # Membership: 0.3 is hard to identify exactly via (value - rep) / spacing.
  expect_true(has_discretes(x, 0.3))
  expect_false(has_discretes(x, 0.3, tol = 0))

  # Walking: a query slightly above a member can snap back with tol > 0.
  from_hi <- 0.3 + 1e-12
  expect_equal(
    next_discrete(x, from = from_hi, include_from = TRUE),
    0.3
  )
  expect_equal(
    next_discrete(x, from = from_hi, include_from = TRUE, tol = 0),
    0.4
  )
  expect_identical(
    num_discretes(x, from = from_hi, to = 0.55, include_from = TRUE),
    3L
  )
  expect_identical(
    num_discretes(x, from = from_hi, to = 0.55, include_from = TRUE, tol = 0),
    2L
  )
  # ...but going backwards, will skip the member if include = FALSE and tol > 0.
  expect_equal(
    prev_discrete(x, from = from_hi, include_from = FALSE),
    0.2
  )
  expect_equal(
    prev_discrete(x, from = from_hi, include_from = FALSE, tol = 0),
    0.3
  )

  # Symmetric case: slightly below a member.
  from_lo <- 0.3 - 1e-12
  expect_equal(
    prev_discrete(x, from = from_lo, include_from = TRUE),
    0.3
  )
  expect_equal(
    prev_discrete(x, from = from_lo, include_from = TRUE, tol = 0),
    0.2
  )
  expect_identical(
    num_discretes(x, from = 0.05, to = from_lo, include_from = TRUE),
    3L
  )
  expect_identical(
    num_discretes(x, from = 0.05, to = from_lo, include_from = TRUE, tol = 0),
    2L
  )
  # ...but going forwards, will skip the member if include = FALSE and tol > 0.
  expect_equal(
    next_discrete(x, from = from_lo, include_from = FALSE),
    0.4
  )
  expect_equal(
    next_discrete(x, from = from_lo, include_from = FALSE, tol = 0),
    0.3
  )
})


test_that("tol affects membership for explicit numeric sets", {
  v <- c(0.1, 0.2, 0.1 * 3, 0.4, 0.5) # Third entry is slightly >0.3, not equal.

  expect_true(has_discretes(v, 0.3))
  expect_false(has_discretes(v, 0.3, tol = 0))

  # num_discretes() uses has_discretes() for point-queries when from == to.
  expect_equal(
    num_discretes(
      v,
      from = 0.3,
      to = 0.3,
      include_from = TRUE,
      include_to = TRUE
    ),
    1L
  )
  expect_equal(
    num_discretes(
      v,
      from = 0.3,
      to = 0.3,
      include_from = TRUE,
      include_to = TRUE,
      tol = 0
    ),
    0L
  )
  
  # Walking: a query slightly above a member can snap back with tol > 0.
  from_hi <- 0.3 + 1e-12
  expect_equal(
    next_discrete(v, from = from_hi, include_from = TRUE),
    0.3
  )
  expect_equal(
    next_discrete(v, from = from_hi, include_from = TRUE, tol = 0),
    0.4
  )
  expect_identical(
    num_discretes(v, from = from_hi, to = 0.55, include_from = TRUE),
    3L
  )
  expect_identical(
    num_discretes(v, from = from_hi, to = 0.55, include_from = TRUE, tol = 0),
    2L
  )
  # ...but going backwards, will skip the member if include = FALSE and tol > 0.
  expect_equal(
    prev_discrete(v, from = from_hi, include_from = FALSE),
    0.2
  )
  expect_equal(
    prev_discrete(v, from = from_hi, include_from = FALSE, tol = 0),
    0.3
  )
  
  # Symmetric case: slightly below a member.
  from_lo <- 0.3 - 1e-12
  expect_equal(
    prev_discrete(v, from = from_lo, include_from = TRUE),
    0.3
  )
  expect_equal(
    prev_discrete(v, from = from_lo, include_from = TRUE, tol = 0),
    0.2
  )
  expect_identical(
    num_discretes(v, from = 0.05, to = from_lo, include_from = TRUE),
    3L
  )
  expect_identical(
    num_discretes(v, from = 0.05, to = from_lo, include_from = TRUE, tol = 0),
    2L
  )
  # ...but going forwards, will skip the member if include = FALSE and tol > 0.
  expect_equal(
    next_discrete(v, from = from_lo, include_from = FALSE),
    0.4
  )
  expect_equal(
    next_discrete(v, from = from_lo, include_from = FALSE, tol = 0),
    0.3
  )
})

test_that("with transforms, tol is applied in root space.", {
  raw <- 10^(-10:10)
  frozen <- 10^as_discretes(-10:10)

  exponent <- 5 + 1e-12 
  q <- 10^exponent

  # In value-space (raw numeric vector), q can be too far from 1e5.
  # In root-space (frozen discretes), exponent can be close enough to 5.
  expect_false(has_discretes(raw, q))
  expect_true(has_discretes(frozen, q))
  expect_false(has_discretes(frozen, q, tol = 0))
  
  # Membership works when the base is arithmetic (integers):
  x <- 10^integers()
  expect_true(has_discretes(x, q))
  expect_false(has_discretes(x, q, tol = 0))
})

