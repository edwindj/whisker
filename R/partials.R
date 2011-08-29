partial <- function(key, partials, indent=""){
  force(key)
  force(partials)

  template <- partials[[key]]
  
  # TODO check for missing partials?
  
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