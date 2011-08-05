renderPartial <- function(value, context){
   template <- as.character(value)
   tmpl <- parseTemplate()
   processSection(value, context, texts, keys, renders, debug=debug)
}