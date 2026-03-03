test_that("Drop works.", {
  x <- 1 / integers()
  y <- dsct_drop(
    x,
    from = -0.5,
    to = 0.5,
    include_from = FALSE,
    include_to = FALSE
  )
  expect_identical(as.numeric(y), c(-1, -0.5, 0.5, 1, Inf))
  expect_identical(num_discretes(y), 5L)
  expect_identical(next_discrete(y, n = Inf, from = 0), c(0.5, 1, Inf))
  expect_identical(
    next_discrete(y, n = Inf, from = -0.5, include_from = TRUE),
    c(-0.5, 0.5, 1, Inf)
  )
  expect_identical(prev_discrete(y, n = Inf, from = 0), c(-0.5, -1))
  expect_identical(
    prev_discrete(y, n = Inf, from = 0.5, include_from = TRUE),
    c(0.5, -0.5, -1)
  )
  
  # Dropping is a union of two keeps; or, is just a single keep.
  x <- integers(0, 10)
  expect_s3_class(dsct_drop(x, from = 5), "dsct_keep")
  expect_s3_class(dsct_drop(x, to = 5), "dsct_keep")
  expect_s3_class(dsct_drop(x, from = 3, to = 7), "dsct_union")
})

test_that("Keep works.", {
  # Check that probing a "dsct_keep" object (`x`) has the provided
  # numeric values (`y`) inside.
  check_keep <- function(x, y) {
    # outside, on boundary, and inside boundary.
    base <- x[["base"]]
    left <- x[["left"]]
    right <- x[["right"]]
    include_left <- x[["include_left"]]
    include_right <- x[["include_right"]]
    y <- sort(y)
    mid_y <- median(y)
    froms <- c(left - 1, left, mid_y, right, right + 1)
    n_set <- c(0:length(y), Inf)
    expect_identical(as.numeric(x), y)
    expect_true(representative(x) %in% y)
    expect_identical(typeof_dsct(x), typeof(representative(base)))
    expect_identical(get_discretes_at(x, values = y), y)
    expect_true(all(has_discretes(x, values = y)))
    for (from in froms) {
      for (n in n_set) {
        expect_identical(
          next_discrete(x, from = from, include_from = TRUE, n = n),
          utils::head(y[y >= from], n)
        )
        expect_identical(
          next_discrete(x, from = from, include_from = FALSE, n = n),
          utils::head(y[y > from], n)
        )
        expect_identical(
          prev_discrete(x, from = from, include_from = TRUE, n = n),
          utils::head(sort(y[y <= from], decreasing = TRUE), n)
        )
        expect_identical(
          prev_discrete(x, from = from, include_from = FALSE, n = n),
          utils::head(sort(y[y < from], decreasing = TRUE), n)
        )
      }
      expect_identical(
        num_discretes(
          x,
          from = from,
          to = Inf,
          include_from = FALSE,
          include_to = TRUE
        ),
        length(y[y > from])
      )
      expect_identical(
        num_discretes(
          x,
          from = -Inf,
          to = from,
          include_from = TRUE,
          include_to = FALSE
        ),
        length(y[y < from])
      )
      expect_identical(
        num_discretes(
          x,
          from = from,
          to = Inf,
          include_from = TRUE,
          include_to = TRUE
        ),
        length(y[y >= from])
      )
      expect_identical(
        num_discretes(
          x,
          from = -Inf,
          to = from,
          include_from = TRUE,
          include_to = TRUE
        ),
        length(y[y <= from])
      )
    }
  }
  
  x <- 1 / integers()
  check_keep(dsct_keep(x, from = 0.25, include_from = TRUE), c(1 / 1:4, Inf))
  check_keep(dsct_keep(x, from = 0.25, include_from = FALSE), c(1 / 1:3, Inf))
  check_keep(dsct_keep(x, to = -0.25, include_to = TRUE), -1 / 1:4)
  check_keep(dsct_keep(x, to = -0.25, include_to = FALSE), -1 / 1:3)
  check_keep(
    dsct_keep(x, from = 0.25, to = 1, include_from = TRUE, include_to = TRUE),
    1 / 1:4
  )
  check_keep(
    dsct_keep(x, from = 0.25, to = 1, include_from = TRUE, include_to = FALSE),
    1 / 2:4
  )
  check_keep(
    dsct_keep(x, from = 0.25, to = 1, include_from = FALSE, include_to = TRUE),
    1 / 1:3
  )
  check_keep(
    dsct_keep(x, from = 0.25, to = 1, include_from = FALSE, include_to = FALSE),
    1 / 2:3
  )
  
  ## Check non-values (check_keep() does not do this)
  expect_identical(
    has_discretes(
      dsct_keep(
        integers(),
        from = 1,
        to = 6,
        include_from = FALSE,
        include_to = FALSE
      ),
      values = c(0, 1, 6, 7)
    ),
    c(FALSE, FALSE, FALSE, FALSE)
  )
  expect_identical(
    has_discretes(
      dsct_keep(
        integers(),
        from = 1,
        to = 6,
        include_from = TRUE,
        include_to = FALSE
      ),
      values = c(0, 1, 6, 7)
    ),
    c(FALSE, TRUE, FALSE, FALSE)
  )
  expect_identical(
    has_discretes(
      dsct_keep(
        integers(),
        from = 1,
        to = 6,
        include_from = FALSE,
        include_to = TRUE
      ),
      values = c(0, 1, 6, 7)
    ),
    c(FALSE, FALSE, TRUE, FALSE)
  )
  expect_identical(
    has_discretes(
      dsct_keep(
        integers(),
        from = 1,
        to = 6,
        include_from = TRUE,
        include_to = TRUE
      ),
      values = c(0, 1, 6, 7)
    ),
    c(FALSE, TRUE, TRUE, FALSE)
  )
})

test_that("Edge cases", {
  x <- dsct_keep(integers(), from = 1, to = 9)
  expect_identical(has_discretes(x, values = numeric()), logical())
  expect_identical(
    num_discretes(x, from = 2, to = 2),
    1L
  )
  expect_identical(
    num_discretes(x, from = 2, to = 2, include_from = FALSE),
    0L
  )
  expect_identical(
    num_discretes(x, from = 2, to = 2, include_to = FALSE),
    0L
  )
  # [0, 0]
  y <- dsct_keep(
    integers(),
    from = 0,
    to = 0,
    include_from = TRUE,
    include_to = TRUE
  )
  expect_identical(get_discretes_in(y), 0L)
  expect_identical(num_discretes(y), 1L)
  expect_identical(next_discrete(y, from = -Inf), 0L)
  expect_identical(prev_discrete(y, from = Inf), 0L)
  expect_true(has_discretes(y, values = 0))
  # (0, 0]
  y <- dsct_keep(
    integers(),
    from = 0,
    to = 0,
    include_from = FALSE,
    include_to = TRUE
  )
  expect_identical(get_discretes_in(y), integer())
  expect_identical(num_discretes(y), 0L)
  expect_identical(next_discrete(y, from = -Inf), integer())
  expect_identical(prev_discrete(y, from = Inf), integer())
  expect_false(has_discretes(y, values = 0))
  # [0, 0)
  y <- dsct_keep(
    integers(),
    from = 0,
    to = 0,
    include_from = TRUE,
    include_to = FALSE
  )
  expect_identical(get_discretes_in(y), integer())
  expect_identical(num_discretes(y), 0L)
  expect_identical(next_discrete(y, from = -Inf), integer())
  expect_identical(prev_discrete(y, from = Inf), integer())
  expect_false(has_discretes(y, values = 0))
  # (0, 0)
  y <- dsct_keep(
    integers(),
    from = 0,
    to = 0,
    include_from = FALSE,
    include_to = FALSE
  )
  expect_identical(get_discretes_in(y), integer())
  expect_identical(num_discretes(y), 0L)
  expect_identical(next_discrete(y, from = -Inf), integer())
  expect_identical(prev_discrete(y, from = Inf), integer())
  expect_false(has_discretes(y, values = 0))
  
  # Keep everything. Keep nothing.
  x <- integers(1, 5)
  expect_identical(dsct_drop(x, from = 7, to = 9), x)
  expect_identical(dsct_drop(x, from = -9, to = -7), x)
  expect_identical(dsct_drop(x, from = 5, to = 9, include_from = FALSE), x)
  expect_identical(dsct_drop(x, from = -9, to = 1, include_to = FALSE), x)
  expect_identical(dsct_drop(x, from = 0, to = 6), empty_series("integer"))
})

test_that("Sinks are preserved or eliminated.", {
  x <- 1 / integers()
  expect_false(has_sink_in(dsct_drop(x, from = -0.3, to = 0.3)))
  yr <- dsct_keep(x, from = 0)
  expect_true(has_sink_in(yr, to = 1))
  expect_identical(nrow(sinks(yr)), 1L)
  yl <- dsct_keep(x, to = 0)
  expect_true(has_sink_in(yl, from = -1))
  expect_identical(nrow(sinks(yr)), 1L)
})

test_that("Representative works.", {
  x <- 1 / natural0()
  y <- dsct_union(x, 2 - x)
  # left sink
  z <- dsct_keep(y, from = 0, to = 1)
  expect_true(has_sink_at(z, 0, dir = "right"))
  expect_true(has_discretes(z, representative(z)))
  # right sink
  z <- dsct_keep(y, from = 1, to = 2)
  expect_true(has_sink_in(z, from = 1.9, to = 2))
  expect_true(has_discretes(z, representative(z)))
  # both side have sinks
  z <- dsct_keep(y, from = 0, to = 2)
  expect_true(has_sink_in(z, from = 0, to = 0.1))
  expect_true(has_sink_in(z, from = 1.9, to = 2))
  expect_true(has_discretes(z, representative(z)))
  # infinite sinks on both sides
  x <- dsct_union(integers(), -Inf, Inf)
  z <- dsct_keep(x, include_from = FALSE, include_to = FALSE)
  expect_true(has_sink_in(z, to = -100))
  expect_true(has_sink_in(z, from = 100))
  expect_true(has_discretes(z, representative(z)))
})

test_that("Signed zero", {
  # Both
  x <- c(-9, -0, 0, 9)
  y <- dsct_keep(x, from = -5, to = 5)
  expect_true(has_negative_zero(y))
  expect_true(has_positive_zero(y))
  
  # Negative
  x <- c(-9, -0, 9)
  y <- dsct_keep(x, from = -5, to = 5)
  expect_true(has_negative_zero(y))
  expect_false(has_positive_zero(y))
  
  # Positive
  x <- c(-9, 0, 9)
  y <- dsct_keep(x, from = -5, to = 5)
  expect_false(has_negative_zero(y))
  expect_true(has_positive_zero(y))
})
