#' Logicless templating
#'
#' @param template \code{character}
#' @param data named \code{list} or env
#' @return \code{character} with rendered template
#' @rdname whisker.render
#' @export
whisker.render <- function(template, data=parent.frame(), debug=FALSE){
   tmpl <- parseTemplate(template)
   if (debug) print(tmpl)
   
   s <- mapply(tmpl$keys, tmpl$render, FUN=function(key, render){
     keydata <- resolve(data, key)
     render(keydata)
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

renderText <- function(x){
  as.character(x)
}

renderHTML <- function(x){
  renderText(whisker.escape(x))
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
   
resolve <- function(ctxt, tag, val=ctxt){
  if (tag=="."){
    return(ctxt)
  }
  keys <- strsplit(tag, split=".", fixed=TRUE)[[1]]
  for (key in keys){
    if (is.null(val)){
       val <- ctxt
    }
    val <- if (is.environment(val)){
             get(key, envir=val)
           } else {
             as.list(val)[[key]]
           }
  }
  val
}