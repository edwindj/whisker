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