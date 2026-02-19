test_that("", {
  expect_identical(representative(numeric()), numeric())
  expect_identical(representative(integer()), integer())
  expect_identical(
    representative(dsct_union(numeric(), integer())),
    numeric()
  )
})
