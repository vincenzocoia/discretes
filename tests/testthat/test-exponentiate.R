test_that("Exponentiation works: basic check.", {
  expect_identical(
    get_discretes_in(exp(as_discretes(c(-1, 1, 10)))),
    exp(c(-1, 1, 10))
  )
  expect_identical(
    get_discretes_in(2^as_discretes(c(-1, 1, 10))),
    2^c(-1, 1, 10)
  )
  expect_identical(
    get_discretes_in(0.5^as_discretes(c(-1, 1, 10))),
    rev(0.5^c(-1, 1, 10))
  )
})

test_that("Exponentiation via different mechanisms match.", {
  expect_same_exp <- function(x, y) {
    expect_identical(num_discretes(x, to = 0), 0L)
    expect_identical(num_discretes(y, to = 0), 0L)
    expect_identical(num_discretes(x, to = -1), 0L)
    expect_identical(num_discretes(y, to = -1), 0L)
    expect_equal(
      next_discrete(x, from = 0.1, n = 10, include_from = TRUE),
      next_discrete(y, from = 0.1, n = 10, include_from = TRUE)
    )
    expect_equal(
      prev_discrete(x, from = 1000, n = 10, include_from = TRUE),
      prev_discrete(y, from = 1000, n = 10, include_from = TRUE)
    )
  }
  # Base e
  x <- discretes:::dsct_exp(integers())
  y <- discretes:::dsct_raise(integers(), base = exp(1))
  z <- exp(integers())
  expect_same_exp(x, y)
  expect_same_exp(y, z)
  
  # Base 2
  x <- discretes:::dsct_raise(integers(), base = 2)
  y <- 2^integers()
  expect_same_exp(x, y)
  
  # Base 0.5
  x <- discretes:::dsct_raise(integers(), base = 0.5)
  y <- 0.5^integers()
  expect_same_exp(x, y)
  
  # This also works. Notice how the sets reduce.
  x <- 0^dsct_union(integers(), -Inf, Inf)
  expect_identical(num_discretes(x), 3L)
  expect_identical(get_discretes_in(x), c(0, 1, Inf))
  
  y <- 1^dsct_union(integers(), -Inf, Inf)
  expect_identical(num_discretes(y), 1L)
  expect_identical(get_discretes_in(y), 1)
})

test_that("Exponentiation edge cases.", {
  # Negative base throws an error
  expect_error(discretes:::dsct_raise(integers(), base = -2))
  expect_error((-2)^integers())
  
  # Empty base returns empty. Empty set returns empty.
  expect_identical(
    discretes:::dsct_raise(integers(), base = numeric(0)),
    empty_set("double")
  )
  expect_identical(numeric(0)^integers(), empty_set("double"))
  expect_identical(2^empty_set(), empty_set())
  expect_identical(1^empty_set(), empty_set())
  expect_identical(0^empty_set(), empty_set())
})