# key types
TRIPLE <- "^\\{(.+)\\}"
AMPERSAND <- "^&(.+)"
SECTION <- "\\#(.+)"
INVERTEDSECTION <- "\\^(.+)"
ENDSECTION <- "\\\\(.+)"

parseTemplate <- function(template){
  #TODO add delimiter switching

  delim <- strsplit("{{ }}"," ")[[1]]
  DELIM <- gsub("([{<>}*?+])", "\\\\\\1", delim)
    
  template <- removeComments(template, DELIM)
  
  KEY <- paste(DELIM[1],"(.+?)", DELIM[2], sep="")
  
  text <- strsplit(template, KEY)[[1]]
  
  first <- gregexpr(KEY, template)[[1]]
  last <- attr(first, "match.length") + first - 1
  keys <- substring(template, first, last)
  keys <- gsub(KEY, "\\1", keys)
  
  # keys should not contains white space, (triple and ampersand may contain surrounding whitespace
  keys <- gsub("\\s", "", keys)
  
  #TODO add section stuff
  func <- list()
  func[1:length(keys)] <- list(whisker.escape)

  # triple mustache
  txt <- grep(TRIPLE, keys)
  keys <- gsub(TRIPLE, "\\1",keys)
  func[txt] <- list(toText)
  
  #ampersand
  txt <- grep(AMPERSAND, keys)
  keys <- gsub(AMPERSAND, "\\1",keys)
  func[txt] <- list(toText)
    
  structure( list( text=text
                 , keys=keys
                 , func=func
                 )
            , class="template"
            )
}

removeComments <- function(text, DELIM){
   COMMENT <- paste(DELIM[1],"!.+?", DELIM[2], sep="")
   
   #remove stand alone comment lines
   re <- paste("(^|\n)\\s*",COMMENT,"\\s*?(\n|$)", sep="")
   text <- gsub(re, "\\1",  text)

   #remove inline comments
   text <- gsub(COMMENT, "",  text)
   text
}
