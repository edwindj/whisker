# todo add R specific things, data.frame and vector rendering 
# for data.frames it should render per row (using paste)
# for vectors it should render per item (for ".")
section <- function(text, keys, render){
   
   ctxt <- NULL
   sectionkey <- NULL
   text <- NULL
   
   renderFUN <- function(val){
      if (val == FALSE){
         print("hi")
         return("")
      }
      
      if (val == TRUE){
      }
      
      if (is.list(val) && !is.data.frame(val)){
         # create a new context from the list that is a child of the given context
      }
      # further resolution should be done using external supplied ctxt and the value of the section key   
   }
   renderFUN
}