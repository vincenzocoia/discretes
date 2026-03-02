test_that("Powers work: basic check.", {
  # Positive
  expect_identical(get_discretes_in(as_discretes(0:5)^2), (0:5)^2)
  expect_identical(get_discretes_in(sqrt(as_discretes(0:5))), sqrt(0:5))
  expect_identical(get_discretes_in(as_discretes(0:5)^1), as.double(0:5))
  expect_identical(get_discretes_in(as_discretes(-5:5)^3), (-5:5)^3)
  # Zero
  expect_identical(
    get_discretes_in(as_discretes(c(-Inf, -5, 0, 5, Inf))^0),
    unique(c(-Inf, -5, 0, 5, Inf)^0)
  )
  # Negative
  expect_identical(get_discretes_in(as_discretes(0:5)^-2), rev((0:5)^-2))
  expect_identical(get_discretes_in(as_discretes(0:5)^-0.5), rev(1 / sqrt(0:5)))
  expect_identical(get_discretes_in(as_discretes(0:5)^-1), rev(1 / (0:5)))
  expect_identical(get_discretes_in(as_discretes(-5:5)^-3), sort((-5:5)^-3))
  # Fractional power only supported when values are non-negative.
  expect_identical(get_discretes_in(as_discretes(0:5)^2.1), (0:5)^2.1)
  expect_error(as_discretes(0:-5)^2.1)
  expect_error(as_discretes(5:-5)^2.1)
  # Odd powers
  expect_identical(get_discretes_in(as_discretes(-5:5)^3), (-5:5)^3)
  # Even powers -- they are union series if both positive and negative values.
  expect_identical(get_discretes_in(as_discretes(-5:0)^2), (0:5)^2)
  expect_identical(get_discretes_in(as_discretes(0:5)^2), (0:5)^2)
  expect_s3_class(integers()^2, "dsct_union")
  expect_identical(get_discretes_in(as_discretes(-5:5)^2), (0:5)^2)
  expect_identical(
    get_discretes_in(as_discretes(-5:5 + 0.1)^2),
    sort((-5:5 + 0.1)^2)
  )
})

test_that("Powers via different mechanisms match.", {
  expect_same_powers <- function(x, y) {
    expect_equal(
      next_discrete(x, from = -10, n = 10, include_from = TRUE),
      next_discrete(y, from = -10, n = 10, include_from = TRUE)
    )
    expect_equal(
      prev_discrete(x, from = 10, n = 10, include_from = TRUE),
      prev_discrete(y, from = 10, n = 10, include_from = TRUE)
    )
  }
  
  ## Square
  x <- discretes:::dsct_power(natural0(), power = 2)
  y <- natural0()^2
  expect_identical(next_discrete(x, from = -Inf, n = 5), (0:4)^2)
  expect_same_powers(x, y)
  
  ## Square root
  x <- discretes:::dsct_power(natural0(), power = 0.5)
  y <- natural0()^0.5
  z <- sqrt(natural0())
  expect_same_powers(x, y)
  expect_same_powers(y, z)
  
  ## Cube
  x <- discretes:::dsct_power(integers(), power = 3)
  y <- integers()^3
  expect_identical(
    get_discretes_in(x, from = -3^3 - 1, to = 3^3 + 1),
    (-3:3)^3
  )
  expect_same_powers(x, y)
  
  ## Inversion via -1 power
  x <- discretes:::dsct_power(natural0(), power = -1)
  y <- natural0()^(-1)
  z <- 1 / natural0()
  expect_same_powers(x, y)
  expect_same_powers(y, z)
  
  ## Negative power other than -1
  base <- as_discretes(0:10)
  w <- discretes:::dsct_power(base, power = -2)
  x <- base^(-2)
  y <- 1 / (base^2)
  z <- (1 / base)^2
  expect_same_powers(w, x)
  expect_same_powers(x, y)
  expect_same_powers(y, z)
  
  ## Negative fraction
  x <- discretes:::dsct_power(natural0(), power = -0.5)
  y <- natural0()^-0.5
  z <- 1 / sqrt(natural0())
  expect_same_powers(x, y)
  expect_same_powers(y, z)
})

test_that("Powers - edge cases.", {
  ## Non-odd powers error out if there are negative values in the set.
  expect_no_error(integers()^5)
  expect_no_error(integers()^(-5))
  expect_error(integers()^2.5)
  expect_error(integers()^(-2.5))
  expect_error(integers()^0.5)
  expect_error(integers()^(-0.5))
  
  ## Negative zero doesn't survive ^(-1) in R, but it does with `1/`;
  ## so it is in discretes.
  expect_identical(
    get_discretes_in(as_discretes(c(-0, 0))^(-1)),
    unique(c(-0, 0)^(-1)) # Inf
  )
  expect_identical(
    get_discretes_in(1 / as_discretes(c(-0, 0))),
    unique(1 / c(-0, 0)) # c(-Inf, Inf)
  )
})
