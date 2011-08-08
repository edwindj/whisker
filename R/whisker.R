#' Logicless templating
#'
#' @param template \code{character} with template text
#' @param data named \code{list} or env with variable that will be used during rendering
#' @param partials named \code{list} with partial templates, will be used during template contruction
#' @return \code{character} with rendered template
#' @rdname whisker.render
#' @example example/whisker_render.R
#' @export
whisker.render <- function(template, data=parent.frame(), partials=list(), debug=FALSE){
   tmpl <- parseTemplate(template, partials=partials, debug=debug)
   context <- list(data)
   
   values <- lapply(tmpl$keys, resolve, context=context)
   if(debug) print(list( whisker.render=values
                       , keyinfo=tmpl$keyinfo
                       , context=context
                       , data=data
                       , keys=tmpl$keys)
                       )
   
   return( renderTemplate( values=values
                         , context=context
                         , texts=tmpl$texts
                         , renders=tmpl$renders
                         , debug=debug
                         )
          )
}

#' @rdname whisker.render
#' @export
whisker <- whisker.render

# TODO change this into whisker...
whisker.future <- function( infile=stdin()
                          , outfile=stdout()
                          , data=if (!missing(infile)) parent.frame()
                                 else NULL
                          , text=NULL
                          , render=!is.null(data)
                          ){
  if (missing(infile) && !is.null(text)){
     infile <- textConnection(text)
  }
  template <- paste(readLines(infile), collapse="\n")
  template <- parseTemplate(template)
  #compile template
  
  invisible(template)
}

renderText <- function(x, context){
  paste(x, collapse=",")
}

renderHTML <- function(x, context){
  renderText(whisker.escape(x))
}

renderEmpty <- function(x, context){
  "hi"
}

renderTemplate <- function(values, context, texts, renders, debug=FALSE){
   
   s <- mapply(values, renders, FUN=function(value, render){
     render(value, context)
   })
   
   sqt <- 2*seq_along(texts)-1
   sqk <- 2*seq_along(s)
   str <- character()
   str[sqt] <- texts
   str[sqk] <- s
   str <- as.list(str)
   str["sep"] <- ""
   
   do.call(paste, str)
}


#' escape basic HTML characters
#'
#' This method is called for normal mustache keys
#' @export
#' @param x \code{character} that will be escaped
#' @return HTML escaped character 
whisker.escape <- function(x){
  x <- gsub("&", "&amp;", x)
  x <- gsub("<", "&lt;", x)
  x <- gsub(">", "&gt;", x)
  x <- gsub('"', "&quot;", x)
  x
}
  
resolve <- function(tag, context, debug=TRUE){
  if (tag=="."){
    return(context[[1]])
  }
  
  #TODO R supports names that have a "."
  # , so first search for "." and than split
  
  keys <- strsplit(tag, split=".", fixed=TRUE)[[1]]
  if (!length(keys))
    return()
  
  for (data in context){
    value <- data
    for (key in keys){
       value <- value[[key]]
    }
    if (!is.null(value)) return(value)
  }
}

isFalsey <- function(x){
  ( NROW(x)==0
 || (is.logical(x) && !x[1])
 || is.function(x)
  )
}