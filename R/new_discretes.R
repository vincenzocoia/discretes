#' Construct an infinite vector object
#'
#' Helper for creating discretes objects that optionally wrap a base
#' vector.
#'
#' @param subclass Character vector of subclass tags to prepend.
#' @param data List of fields describing the infinite vector.
#' @param base Optional underlying discretes object being transformed.
#' @keywords internal
new_discretes <- function(data, ..., subclass = character()) {
  structure(data, ..., class = c(subclass, "discretes"))
}
