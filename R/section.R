# todo add R specific things, data.frame and vector rendering 
# for data.frames it should render per row (using paste)
# for vectors it should render per item (for ".")
section <- function(texts, keys, renders, debug=FALSE){
   texts <- texts
   keys <- keys
   renders <- renders
   
   renderFUN <- function(value, context){
      processSection(value, context, texts, keys, renders, debug=debug)
   }
   renderFUN
}

processSection <- function(value, context, texts, keys, renders, debug=FALSE){
   if (isFalsey(value)){
     return()
   }
   
   values <- sapply(keys, resolve, context=context)
   #print(list(values=values))
   return(renderTemplate(values, context, texts, renders, debug=debug))
}
