#' Construct an infinite vector object
#'
#' Helper for creating infvctr objects that optionally wrap a base vector.
#'
#' @param subclass Character vector of subclass tags to prepend.
#' @param data List of fields describing the infinite vector.
#' @param base Optional underlying infvctr being transformed.
#' @keywords internal
new_infvctr <- function(data, ..., subclass = character()) {
  structure(data, ..., class = c(subclass, "infvctr"))
}
