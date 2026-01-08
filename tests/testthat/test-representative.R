test_that("", {
  expect_identical(representative(numeric()), numeric())
  expect_identical(representative(integer()), integer())
  expect_identical(
    representative(dsct_union(numeric(), integer())),
    numeric()
  )
  expect_length(representative(dsct_union(1:10, numeric(0))), 1)
})
