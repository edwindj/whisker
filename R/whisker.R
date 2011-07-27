#' Whisker
#'
#' This is whisker
#' @param template \code{character}
#' @param data named \code{list} 
#' @export
whisker <- function(template, data){
   parse(template)
}

parse <- function(template){
  delim <- strsplit("{{ }}"," ")[[1]]
  
  buildre <- function(delim){
     re <- paste(delim[1],"\\s*(\\S+)\\s*", delim[2], sep="")
     re <- gsub("([{<>}])", "\\\\\\1", re)
     re
  }
  re <- buildre(delim)
  
  rex <- regexpr(re, template)

  print(list( delim=delim
  #          , re = re
            , rex=rex
            )
       )
}
