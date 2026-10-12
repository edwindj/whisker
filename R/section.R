# todo add R specific things, data.frame and vector rendering 
# for data.frames it should render per row (using paste)
# for vectors it should render per item (for ".")
section <- function(texts, keys, renders, types, debug=FALSE, strict=TRUE, checkvars=FALSE){
   force(texts)
   force(keys)
   force(renders)
  force(types)
   
   renderFUN <- function(value, context){
      processSection(value, context, texts, keys, renders, types, debug, strict, checkvars)
   }
   renderFUN
}

processSection <- function(value, context, texts, keys, renders, types, debug=FALSE, strict=TRUE, checkvars=FALSE){
   if (isFalsey(value)){
     return()
   }
   
   if (is.list(value) || is.vector(value)){
     if (is.null(names(value))){
       str <- sapply( value
                    , function(item){
                       context <- c(list(as.list(item)), context)
                       values <- mapply(function(tag, type){
                         resolve(tag, context=context, debug=debug, strict=strict, checkvars=checkvars && type != ">")
                       }, keys, types, SIMPLIFY=FALSE)
                       renderTemplate(values, context, texts, renders)                  
                      }
                    )
       return(paste(str, collapse=""))
     } else {
       context <- c(list(value), context)
     }
   }
   
   values <- mapply(function(tag, type){
     resolve(tag, context=context, debug=debug, strict=strict, checkvars=checkvars && type != ">")
   }, keys, types, SIMPLIFY=FALSE)
   return(renderTemplate(values, context, texts, renders))
}
