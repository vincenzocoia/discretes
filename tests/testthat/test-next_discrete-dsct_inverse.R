test_base <- function(base, from, n, inc, expect) {
  res <- next_discrete(
    dsct_invert(base),
    from = from,
    n = n,
    include_from = inc
  )
  testthat::expect_identical(res, expect)
}

test_that("next_discrete works", {
  # Base = 0
  test_base(0, from = Inf, n = 1, inc = TRUE, expect = Inf)
  test_base(0, from = Inf, n = 1, inc = FALSE, expect = numeric())
  test_base(0, from = Inf, n = Inf, inc = TRUE, expect = Inf)
  test_base(0, from = Inf, n = Inf, inc = FALSE, expect = numeric())
  # Base = -0
  test_base(-0, from = Inf, n = 1, inc = TRUE, expect = -Inf)
  test_base(-0, from = Inf, n = 1, inc = FALSE, expect = numeric())
  test_base(-0, from = Inf, n = Inf, inc = TRUE, expect = -Inf)
  test_base(-0, from = Inf, n = Inf, inc = FALSE, expect = numeric())
  # Base has both 0 and -0 (they don't collapse until expressed, therefore
  # inversion will propagate both into -Inf and Inf)
  base <- dsct_union(0, -0)
  test_base(base, from = Inf, n = 1, inc = TRUE, expect = Inf)
  test_base(base, from = Inf, n = 1, inc = FALSE, expect = numeric())
  test_base(base, from = Inf, n = Inf, inc = TRUE, expect = Inf)
  test_base(base, from = Inf, n = Inf, inc = FALSE, expect = numeric())
  test_base(base, from = -Inf, n = Inf, inc = TRUE, expect = c(-Inf, Inf))
  test_base(base, from = -Inf, n = Inf, inc = FALSE, expect = Inf)
})



test_that("Edge cases", {
  expect_identical(
    next_discrete(dsct_inverse(1:10), from = -2, n = 0),
    numeric()
  )
  expect_identical(
    next_discrete(dsct_inverse(dsct_union(1:10, integers())), from = -2, n = 0),
    numeric()
  )
  expect_identical(
    next_discrete(dsct_inverse(0), from = Inf, include_from = FALSE),
    numeric()
  )
})

rm('test_base')