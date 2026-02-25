test_that("Ops with length-0 vectors", {
  # Numeric vs Integer
  expect_identical(integers() * integer(), empty_set("integer"))
  expect_identical(integers() + integer(), empty_set("integer"))
  expect_identical(integers() * numeric(), empty_set("double"))
  expect_identical(integers() + numeric(), empty_set("double"))
  expect_identical(integers() ^ integer(), empty_set("double"))
  expect_identical(integer() ^ integers(), empty_set("double"))
  expect_identical(integers() ^ numeric(), empty_set("double"))
  expect_identical(numeric() ^ integers(), empty_set("double"))
  # Length-0 series
  expect_identical(empty_set() * 2, empty_set())
  expect_identical(empty_set() + 2, empty_set())
  expect_identical(empty_set() ^ 2, empty_set())
  expect_identical(2 ^ empty_set(), empty_set())
  expect_identical(empty_set("integer") * 2L, empty_set("integer"))
  expect_identical(empty_set("integer") + 2L, empty_set("integer"))
})

test_that("^ works for number^discretes", {
  x <- 2^integers()
  expect_true(all(has_discretes(x, values = c(0.5, 1, 2, 4, 8))))
  expect_equal(next_discrete(x, from = 1.3, n = 3), c(2, 4, 8))

  y <- 0.5^integers()
  expect_true(all(has_discretes(y, values = c(0.5, 1, 2, 4))))
  expect_equal(next_discrete(y, from = 0.6, n = 3), c(1, 2, 4))

  one <- 1^integers()
  expect_equal(get_discretes_in(one), 1)
  expect_identical(next_discrete(one, from = 0, n = 5), 1)

  zeroone <- 0^integers()
  expect_equal(get_discretes_in(zeroone), c(0, 1, Inf))
  expect_equal(next_discrete(zeroone, from = -Inf, n = 5), c(0, 1, Inf))

  zero <- 0^natural1()
  expect_equal(get_discretes_in(zero), 0)
  expect_equal(next_discrete(zero, from = -Inf, n = 5), 0)

  infone <- Inf^integers()
  expect_equal(get_discretes_in(infone), c(0, 1, Inf))
  expect_equal(next_discrete(infone, from = -Inf, n = 5), c(0, 1, Inf))

  inf <- Inf^natural1()
  expect_equal(get_discretes_in(inf), Inf)
  expect_equal(next_discrete(inf, from = -Inf, n = 5), Inf)
})

test_that("^ errors for unsupported bases (number^discretes)", {
  expect_error((-2)^integers())
  expect_error((-Inf)^integers())
})

test_that("Checks when discretes are negative", {
  expect_equal(
    get_discretes_in(integers()^(-1), to = -0.1),
    get_discretes_in(dsct_invert(integers()), to = -0.1)
  )
  expect_equal(
    get_discretes_in(integers()^(-1), from = 0.1),
    get_discretes_in(dsct_invert(integers()), from = 0.1)
  )

  expect_identical(arithmetic(0, 1)^1, arithmetic(0, 1))
  expect_identical(next_discrete(integers()^1, from = 0.5, n = 3), c(1, 2, 3))

  one <- integers()^0
  expect_identical(get_discretes_in(one), 1)
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

test_that("Bad Ops.", {
  expect_error(integers() %% 2)
  expect_error(integers() == 2)
  expect_error(integers() * integers())
})
