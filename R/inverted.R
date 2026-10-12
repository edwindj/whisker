inverted <- function(texts, keys, renders, types, debug=FALSE, strict=TRUE, checkvars=FALSE){
   force(texts)
   force(keys)
   force(renders)   
   force(types)
   renderFUN <- function(value, context){
      processInverted(value, context, texts, keys, renders, types, debug, strict, checkvars)
   }
   renderFUN
}
 
processInverted <- function(value, context, texts, keys, renders, types, debug=FALSE, strict=TRUE, checkvars=FALSE){
   if (!isFalsey(value)){
     return()
   }
    values <- mapply(function(tag, type){
       resolve(tag, context=context, debug=debug, strict=strict, checkvars=checkvars && type != ">")
    }, keys, types, SIMPLIFY=FALSE)
   return(renderTemplate(values, context, texts, renders))
}
