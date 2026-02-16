test_that("Ops with length-0 vectors", {
  # Numeric vs Integer
  expect_identical(integers() * integer(), dsct_empty("integer"))
  expect_identical(integers() + integer(), dsct_empty("integer"))
  expect_identical(integers() * numeric(), dsct_empty("numeric"))
  expect_identical(integers() + numeric(), dsct_empty("numeric"))
  expect_identical(integers() ^ integer(), dsct_empty("numeric"))
  expect_identical(integer() ^ integers(), dsct_empty("numeric"))
  expect_identical(integers() ^ numeric(), dsct_empty("numeric"))
  expect_identical(numeric() ^ integers(), dsct_empty("numeric"))
  # Length-0 series
  expect_identical(dsct_empty() * 2, dsct_empty())
  expect_identical(dsct_empty() + 2, dsct_empty())
  expect_identical(dsct_empty() ^ 2, dsct_empty())
  expect_identical(2 ^ dsct_empty(), dsct_empty())
  expect_identical(dsct_empty("integer") * 2L, dsct_empty("integer"))
  expect_identical(dsct_empty("integer") + 2L, dsct_empty("integer"))
})

test_that("^ works for number^discretes", {
  x <- 2^integers()
  expect_true(all(test_discrete(x, values = c(0.5, 1, 2, 4, 8))))
  expect_equal(next_discrete(x, from = 1.3, n = 3), c(2, 4, 8))

  y <- 0.5^integers()
  expect_true(all(test_discrete(y, values = c(0.5, 1, 2, 4))))
  expect_equal(next_discrete(y, from = 0.6, n = 3), c(1, 2, 4))

  one <- 1^integers()
  expect_equal(as.numeric(one), 1)
  expect_identical(next_discrete(one, from = 0, n = 5), 1)

  zeroone <- 0^integers()
  expect_equal(as.numeric(zeroone), c(0, 1))
  expect_equal(next_discrete(zeroone, from = -Inf, n = 5), c(0, 1))

  zero <- 0^natural1()
  expect_equal(as.numeric(zero), 0)
  expect_equal(next_discrete(zero, from = -Inf, n = 5), 0)

  infone <- Inf^integers()
  expect_equal(as.numeric(infone), c(1, Inf))
  expect_equal(next_discrete(infone, from = -Inf, n = 5), c(1, Inf))

  inf <- Inf^natural1()
  expect_equal(as.numeric(inf), Inf)
  expect_equal(next_discrete(inf, from = -Inf, n = 5), Inf)
})

test_that("^ errors for unsupported bases (number^discretes)", {
  expect_error((-2)^integers())
  expect_error((-Inf)^integers())
})

test_that("^ only supports powers 0, 1, -1 when discretes is on the left", {
  expect_identical(integers()^(-1), dsct_invert(integers()))

  expect_identical(arithmetic(0, 1)^1, arithmetic(0, 1))
  expect_identical(next_discrete(integers()^1, from = 0.5, n = 3), c(1, 2, 3))

  one <- integers()^0
  expect_identical(as.numeric(one), 1)
  expect_identical(next_discrete(one, from = -Inf, n = 5), 1)

  cube <- integers()^3
  expect_identical(
    next_discrete(cube, from = -28, n = 7),
    c(-27, -8, -1, 0, 1, 8, 27)
  )

  expect_error(integers()^2)
  expect_error(integers()^4)
  expect_error(integers()^0.5)
  expect_error(integers()^(-2))
  expect_error(integers()^(-4))
  expect_error(integers()^(-0.5))
})

test_that("^ requires scalar other side (or length-0)", {
  expect_error(integers()^c(0, 1))
  expect_error(c(2, 3)^integers())
})

test_that("NA, NaN not allowed", {
  # Explicit
  expect_error(integers() + NA)
  expect_error(integers() - NA)
  expect_error(integers() * NA)
  expect_error(integers() / NA)
  expect_error(integers() ^ NA)
  expect_error(NA ^ integers())
  expect_error(integers() + NaN)
  expect_error(integers() - NaN)
  expect_error(integers() * NaN)
  expect_error(integers() / NaN)
  expect_error(integers() ^ NaN)
  # Arising from computation
  expect_error(integers() / 0)
  expect_error(dsct_union(-Inf, 2) * 0)
  expect_error(dsct_union(Inf, 2) * 0)
  expect_error(integers() * Inf)
  expect_error(integers() * -Inf)
  expect_error(dsct_union(Inf, integers()) - Inf)
  expect_error(dsct_union(-Inf, integers()) + Inf)
})
