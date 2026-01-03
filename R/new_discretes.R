#' Construct an infinite vector object
#'
#' Helper for creating discretes objects that optionally wrap a base
#' vector.
#'
#' @param subclass Character vector of subclass tags to prepend.
#' @param data List of fields describing the infinite vector.
#' @param base Optional underlying discretes object being transformed.
#' @noRd
new_discretes <- function(data, ..., name = NULL, subclass = character()) {
  structure(data, ..., name = name, class = c(subclass, "discretes"))
}
