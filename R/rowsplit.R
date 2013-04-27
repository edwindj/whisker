#' Split a data.frame or matrix into rows
#' 
#' Utility function for splitting a data.frame into rows.
#' In a whisker template it can be useful to iterate over the rows of a data.frame or matrix.
#' For example rendering a table in HTML.
#' @param x \code{data.frame} or \code{matrix}
#' @param ... other options will be passed onto \code{\link{split}}
#' @export
rowSplit <- function(x, ...){
  split(x, seq_len(nrow(x)), ...)
}