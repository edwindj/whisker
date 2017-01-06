inverted <- function(texts, keys, renders, ...){
   force(texts)
   force(keys)
   force(renders)   
   renderFUN <- function(value, context){
      processInverted(value, context, texts, keys, renders, ...)
   }
   renderFUN
}
 
processInverted <- function(value, context, texts, keys, renders, ...){
   if (!isFalsey(value)){
     return()
   }
   values <- lapply(keys, resolve, context=context)
   return(renderTemplate(values, context, texts, renders, keys, ...))
}
