#' Construct a transformation discrete set object
#'
#' @inheritParams new_discretes
#' @param subclass Character vector of subclass tags to prepend.
#' @returns Object of class `c("dsct_transform", "discretes")`, with
#'   additional classes given by `subclass`.
#' @noRd
new_dsct_transform <- function(data,
                               ...,
                               sinks = NULL,
                               name = NULL,
                               subclass = character()) {
  new_discretes(
    data,
    ...,
    sinks = sinks,
    name = name,
    subclass = c(subclass, "dsct_transform")
  )
}
