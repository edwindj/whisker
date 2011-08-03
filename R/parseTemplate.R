# key types regexpr
TRIPLE <- "^\\{(.+)\\}"
AMPERSAND <- "^&(.+)"
SECTION <- "\\#(.+)"
INVERTEDSECTION <- "\\^(.+)"
ENDSECTION <- "\\\\(.+)"

#keytypes
keytypes <- c("", "{}", "&", "#", "^", "/")

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
  
  key <- data.frame(rawkey=keys, first=first, last=last)
  
  # keys should not contains white space, (triple and ampersand may contain surrounding whitespace
  keys <- gsub("\\s", "", keys)
  key$key <- gsub("\\s", "", key$rawkey)
  key$type <- factor("", levels=keytypes)
  
  key$type[grep(TRIPLE, key$rawkey)] <- "{}"
  key$type[grep(AMPERSAND, key$rawkey)] <- "&"
  key$type[grep(SECTION, key$rawkey)] <- "#"
  key$type[grep(INVERTEDSECTION, key$rawkey)] <- "^"
  key$type[grep(ENDSECTION, key$rawkey)] <- "/"

  key$key <- gsub(TRIPLE, "\\1",key$key)
  key$key <- gsub(AMPERSAND, "\\1",key$key)
  key$key <- gsub(SECTION, "\\1",key$key)
  key$key <- gsub(INVERTEDSECTION, "\\1",key$key)
  key$key <- gsub(ENDSECTION, "\\1",key$key)
 
  #print(key)
  
  #TODO add section stuff
  render <- list()
  render[1:length(keys)] <- list(renderHTML)

  # triple mustache
  txt <- grep(TRIPLE, keys)
  keys <- gsub(TRIPLE, "\\1",keys)
  render[txt] <- list(renderText)
  
  #ampersand
  txt <- grep(AMPERSAND, keys)
  keys <- gsub(AMPERSAND, "\\1",keys)
  render[txt] <- list(renderText)
    
  structure( list( text=text
                 , keys=keys
                 , render=render
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
