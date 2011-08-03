# todo add R specific things, data.frame and vector rendering 
# for data.frames it should render per row (using paste)
# for vectors it should render per item (for ".")
section <- function(texts, keys, renders, debug=FALSE){
   texts <- texts
   keys <- keys
   renders <- renders
   
   renderFUN <- function(val, context){
      if (val == FALSE){
         return()
      }
      
      if (val == TRUE){
         return(renderBody(context, val, texts, keys, renders, debug=debug))
      }
      
      if (is.data.frame(val)){
         return(renderBody(context, val, texts, keys, renders, debug=debug))
      }
      
      # if (is.list(val)) {
         # # create a new context from the list that is a child of the given context
      # }
      
      renderBody(context, val, texts, keys, renders, debug=debug)
   }
   renderFUN
}