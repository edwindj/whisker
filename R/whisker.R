#' Logicless templating
#'
#' @param template \code{character} with template text
#' @param data named \code{list} or env
#' @return \code{character} with rendered template
#' @rdname whisker.render
#' @export
whisker.render <- function(template, data=parent.frame(), debug=FALSE){
   tmpl <- parseTemplate(template, debug)
   if (debug) print(tmpl)
   
   return( renderBody( ctxt=data
                     , texts=tmpl$texts
                     , keys=tmpl$keys
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

renderBody <- function(ctxt, data=ctxt, texts, keys, renders, debug=FALSE){
   if (debug){
      print(ls.str())
   }
   
   s <- mapply(keys, renders, FUN=function(key, render){
     val <- resolve(ctxt, key, data)
     render(val, ctxt)
   })
   
   sqt <- 2*seq_along(texts)-1
   sqk <- 2*seq_along(keys)
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