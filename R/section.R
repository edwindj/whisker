# todo add R specific things, data.frame and vector rendering 
# for data.frames it should render per row (using paste)
# for vectors it should render per item (for ".")
section <- function(texts, keys, renders){
   force(texts)
   force(keys)
   force(renders)
   
   renderFUN <- function(value, context){
      processSection(value, context, texts, keys, renders)
   }
   renderFUN
}

processSection <- function(value, context, texts, keys, renders){
   if (isFalsey(value)){
     return()
   }
   if (is.list(value)){
     context <- c(list(value), context)
   }
   values <- lapply(X=keys, FUN=resolve, context=context)
   return(renderTemplate(values, context, texts, renders))
}
