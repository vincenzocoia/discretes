#' Construct a discrete set object
#'
#' @param data List of fields describing the infinite vector.
#' @param ... Additional attributes to set on the object.
#' @param sinks Matrix of sink locations and directions; NULL for no sinks.
#'   Use `sinks_matrix()` to create a matrix.
#' @param name Character vector of the name of the infinite vector.
#' @param subclass Character vector of subclass tags to prepend.
#' @returns Object of class "discretes", with additional classes given by
#'   `subclass`.
#' @noRd
new_discretes <- function(data,
                          ...,
                          sinks = sinks_matrix(),
                          name = NULL,
                          subclass = character()) {
  structure(
    data,
    ...,
    name = name,
    sinks = sinks,
    class = c(subclass, "discretes")
  )
}
