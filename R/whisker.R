#' Logicless templating
#'
#' @param template \code{character} with template text
#' @param data named \code{list} or \code{environment} with variables that will be used during rendering
#' @param partials named \code{list} with partial templates, will be used during template construction
#' @param debug Used for debugging purposes, likely to disappear
#' @param strict \code{logical} if \code{TRUE} the seperation symbol is a "." otherwise a "$"
#' @return \code{character} with rendered template
#' @rdname whisker.render
#' @example examples/whisker_render.R
#' @export
#' @note 
#' By default whisker applies html escaping on the generated text. 
#' To prevent this use \{\{\{variable\}\}\} (triple) in stead of 
#' \{\{variable\}\}.
whisker.render <- function( template
                          , data = parent.frame()
                          , partials = list()
                          , debug = FALSE
                          , strict = TRUE
                          ){
   if (is.null(template) || identical(paste(template, collapse=""), "")){
     return("")
   }
   
   tmpl <- parseTemplate( template
                        , partials=as.environment(partials)
                        , debug=debug
                        , strict=strict
                        )
   
   return(tmpl(data))
}

whisker.renderFile <- function(con
                             , data = parent.frame()
                             , partials = list()
                             , debug = FALSE
                             ){
  template <- paste(readLines(con), collapse='\n')
  whisker.render(template, data, partials, debug)
}

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
  whisker.escape(renderText(x))
}

renderEmpty <- function(x, context){
  ""
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
#   paste(str, collapse="", sep="")
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
  
resolve <- function(tag, context, debug=FALSE, strict=TRUE){
  if (tag=="."){
    return(context[[1]])
  }
  
  split_symbol = if (strict) "." else "$"
  #TODO R supports names that have a "."
  # , so first search for "." and than split
  
  keys <- strsplit(tag, split=split_symbol, fixed=TRUE)[[1]]
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

#' Is a value falsey according to Mustache specifications?
#' 
#' This function is used to test a value before rendering
#' @param x value
#' @return TRUE if falsey, otherwise FALSE
#' @keywords internal
isFalsey <- function(x){
  ( NROW(x)==0
 || (is.logical(x) && !x[1])
 || is.function(x)
  )
}
