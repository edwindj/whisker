#' Whisker
#'
#' This is whisker
#' @param template \code{character}
#' @param data named \code{list} 
#' @export
whisker <- function(template, data){
   tmpl <- parse(template)
   
   s <- sapply(tmpl$keys, function(key){
     data[[key]]
   })
   
   sqt <- 2*seq_along(tmpl$text)-1
   sqk <- 2*seq_along(tmpl$keys)
   str <- character()
   str[sqt] <- tmpl$text
   str[sqk] <- s
   str <- as.list(str)
   str["sep"] <- ""
   
   do.call(paste, str)
}

parse <- function(template){
  delim <- strsplit("{{ }}"," ")[[1]]
  
  buildre <- function(delim){
     re <- paste(delim[1],"\\s*(\\S+)\\s*", delim[2], sep="")
     re <- gsub("([{<>}])", "\\\\\\1", re)
     re
  }
  re <- buildre(delim)
  
  
  text <- strsplit(template, re)[[1]]
  
#  getkeys <- function(rex){
  first <- gregexpr(re, template)[[1]]
  last <- attr(first, "match.length") + first - 1
  keys <- substring(template, first, last)
  keys <- gsub(re, "\\1", keys)
 # }

#   print(list( delim=delim
#             , re = re
#             , text=text
#             , keys=keys
#             #, keys = getkeys(rex)
#             )
#        )
  list( text=text
      , keys=keys
      )
}
