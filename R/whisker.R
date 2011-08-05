#' Logicless templating
#'
#' @param template \code{character} with template text
#' @param data named \code{list} or env
#' @return \code{character} with rendered template
#' @rdname whisker.render
#' @export
whisker.render <- function(template, data=parent.frame(), debug=FALSE){
   tmpl <- parseTemplate(template, debug)
   #if (debug) print(tmpl)
   
   values <- sapply(tmpl$keys, resolve, context=data)
   
   return( renderTemplate( values=values
                         , context=data
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
  x
}

renderHTML <- function(x, context){
  renderText(whisker.escape(x))
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
  
getValue <- function(key, context){
    val <- if (is.environment(val)){
             get(key, envir=val)
           } else {
             as.list(val)[[key]]
           }
    val
}
   
resolve <- function(tag, context,  val=context){
  
  if (tag=="."){
    return(context)
  }
  
  keys <- strsplit(tag, split=".", fixed=TRUE)[[1]]
  for (key in keys){
    if (is.null(val)){
       val <- context
    }
    val <- if (is.environment(val)){
             get(key, envir=val)
           } else {
             as.list(val)[[key]]
           }
  }
  val
}

isFalsey <- function(x){
  ( NROW(x)==0
 || (is.logical(x) && !x[1])
 || is.function(x)
  )
}