#' Construct an infinite vector object
#'
#' Helper for creating discretes objects that optionally wrap a base
#' vector.
#'
#' @param data List of fields describing the infinite vector.
#' @param ... Additional attributes to set on the object.
#' @param sinks Matrix of sink locations and directions; NULL for no sinks.
#'   Use `sinks_matrix()` to create a matrix.
#' @param name Character vector of the name of the infinite vector.
#' @param subclass Character vector of subclass tags to prepend.
#' @noRd
new_discretes <- function(data,
                          ...,
                          sinks = NULL,
                          name = NULL,
                          subclass = character()) {
  if (is.null(sinks)) {
    sinks <- empty_sinks()
  }
  structure(
    data,
    ...,
    name = name,
    sinks = sinks,
    class = c(subclass, "discretes")
  )
}
