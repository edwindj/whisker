#' Split a data.frame or matrix into rows
#' 
#' Utility function for splitting a data.frame into rows.
#' In a whisker template it can be useful to iterate over the rows of a data.frame or matrix.
#' For example rendering a table in HTML.
#' @param x `data.frame` or `matrix`
#' @param ... other options will be passed onto [split()]
#' @export 
#' @example examples/rowSplit.R
rowSplit <- function(x, ...){
  unname(split(x, seq_len(nrow(x)), ...))
}
