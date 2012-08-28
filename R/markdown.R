# Utility for markdown files

whisker.markdownToHTML <- function( template
                        , data = parent.frame()
                        , partials = list()
                        , debug = FALSE
                      ){
  if (!require(markdown)){
    stop("This function needs the package 'markdown', which can be installed from CRAN.")
  }
  
  if (is.null(template) || template == ""){
    return("")
  }
  
  md.tmpl <- parseTemplate(template, partials=as.environment(partials), debug=debug)
}

md <- function(x, ...){
  UseMethod("md")
}

md.default <- function(x, ...){
  as.character(x)
}

md.data.frame <- function(x, ...){
  header <- paste(names(x), collapse="|")
  line <- paste("---", collapse="|")
  rows <- lapply(1:nrow(x), function(r){
    paste(x[r,], collapse="|")
  })
  rows <- paste(rows, collapse="\n")
  paste(header, line, rows, sep="\n")
}

# md.list <- function(x, indent=0, ...){
#   ID <- paste(rep(" ", indent), collapse="")
#   l <- sapply(x, md, indent=indent+1, ...)
#   paste(ID, "*", l, collapse="\n")
# }
# 
# md(head(cars))
# 
# a <- list(a=1, b=list(b1=23, b2=34))
# md(a)