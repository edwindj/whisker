# todo add R specific things, data.frame and vector rendering 
# for data.frames it should render per row (using paste)
# for vectors it should render per item (for ".")
section <- function(){
   ctxt <- NULL
   sectionkey <- NULL
   keys < -NULL
   text <- NULL
   
   val <- resolve(ctxt, sectionkey) # get value of sectionkey
   if (is.list(val) && !is.data.frame(val)){
      # create a new context from the list that is a child of the given context
   }

   # further resolution should be done using external supplied ctxt and the value of the section key   
}