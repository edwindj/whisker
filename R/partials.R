partial <- function(key, partials, indent=""){
  force(key)
  force(partials)

  template <- partials[[key]]
  
  if (is.null(template)){
    # load from file?
    fname <- paste(key, "mustache", sep=".")
    if (file.exists(fname)){
      template <- paste(readLines(fname), collapse="\n")
    } else {
      warning("No partial '",key, "' or file '",fname,"' found")
    }
  }
  
  # should the partial template be parsed?
  if (is.character(template)){
    
    # remove key, because of possible infinite recursion
    partials[[key]] <- NULL
    template <- parseTemplate(template, partials)
    
    #indent the partial template
    env <- environment(template)
    env$texts <- gsub("(\n)", paste("\\1", indent, sep=""), env$texts)
    
    partials[[key]] <- template
  }
  
  renderPartial <- function(value, context){
    # value is not used, since a partial has no value  
    tmpl <- partials[[key]]
    
    return(tmpl(context=context))
  }
  
  renderPartial
}
