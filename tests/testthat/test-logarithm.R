test_that("Logarithms work: basic check.", {
  x <- c(0.5, 1, 10)
  dsct <- dsct_numeric(x)
  expect_equal(
    as.numeric(log(dsct)),
    log(x)
  )
  expect_equal(
    as.numeric(log10(dsct)),
    log10(x)
  )
  expect_equal(
    as.numeric(log2(dsct)),
    log2(x)
  )
  expect_equal(
    as.numeric(log(dsct, base = 0.5)),
    rev(log(x, base = 0.5))
  )
})

test_that("Logarithms via different mechanisms match.", {
  expect_same_log <- function(x, y) {
    expect_equal(
      next_discrete(x, from = -10, n = 10),
      next_discrete(y, from = -10, n = 10)
    )
    expect_equal(
      prev_discrete(x, from = 4, n = 10),
      prev_discrete(y, from = 4, n = 10)
    )
  }
  
  ## Natural log
  x <- discretes:::dsct_log(natural0(), base = exp(1))
  y <- log(natural0())
  expect_same_log(x, y)
  
  ## Base 10
  x <- discretes:::dsct_log(natural1(), base = 10)
  y <- log(natural1(), base = 10)
  z <- log10(natural1())
  expect_same_log(x, y)
  expect_same_log(y, z)
  
  ## Base 2
  x <- discretes:::dsct_log(natural0(), base = 2)
  y <- log(natural0(), base = 2)
  z <- log2(natural0())
  expect_same_log(x, y)
  expect_same_log(y, z)
  
  ## Base between 0 and 1
  x <- discretes:::dsct_log(natural0(), base = 0.5)
  y <- -discretes:::dsct_log(natural0(), base = 2)
  expect_same_log(x, y)
})

test_that("Logarithms - edge cases.", {
  ## Error when negative values are present in the set
  expect_error(log(integers()))
  expect_error(log(integers(), base = 7))
  expect_error(log2(integers(), base = 7))
  
  ## Error with negative or 0 base or 1 base
  expect_error(log(natural1(), base = 0))
  expect_error(log(natural1(), base = -2))
  expect_error(log(natural1(), base = 1))
  
  ## Empty base returns empty. Empty set returns empty.
  expect_identical(
    log(natural1(), base = numeric(0)),
    dsct_empty("double")
  )
  expect_identical(
    log(dsct_empty()),
    dsct_empty()
  )
})
