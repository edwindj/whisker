#' Create an iteration list from a R object
#'
#' In some case it is useful to iterate over a named `list` or `vector`
#' `iteratelist` will create a new unnamed `list` with name value members:
#' each item will be a list where 'name' is the corresponding name and 'value' is the original
#' value in list `x`.
#' @param x `list` or other object that will be coerced to `list`
#' @param name `character` name for resulting name member.
#' @param value `character` name for resulting value member.
#' @return unnamed `list` with name value lists
#' @example examples/iteratelist.R
#' @export
iteratelist <- function(x, name="name", value="value"){
  x <- as.list(x)
  nms <- names(x)
  lapply( seq_along(x)
        , function(i){
            l <- list()
            l[name] <- nms[i]
            l[value] <- x[i]
            l
          }
        )
}
