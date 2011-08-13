#key type regexpr
TRIPLE <- "^\\{(.+)\\}"
AMPERSAND <- "^&(.+)"
SECTION <- "\\#(.+?)"
INVERTEDSECTION <- "\\^(.+?)"
ENDSECTION <- "/(.+?)"
PARTIAL <- ">(.+?)"
COMMENT <- "!.+?"

#keytypes
keytypes <- c("", "{}", "&", "#", "^", "/", ">")

parseTemplate <- function(template, partials=list(), debug=FALSE){
  #TODO add delimiter switching
  delim <- strsplit("{{ }}"," ")[[1]]
  
  DELIM <- gsub("([{<>}*?+])", "\\\\\\1", delim)
  
  template <- paste(template, collapse="\n")
  template <- removeComments(template, DELIM)
  template <- inlineStandAlone(template, DELIM, SECTION)
  template <- inlineStandAlone(template, DELIM, INVERTEDSECTION)
  template <- inlineStandAlone(template, DELIM, ENDSECTION, end=TRUE)
 
  KEY <- paste(DELIM[1],"(.+?)", DELIM[2], sep="")
  
  text <- strsplit(template, KEY)[[1]] 
  key <- getKeyInfo(template, KEY)
  n <- nrow(key)
  
  render <- list()
  #default rendering method
  render[1:n] <- list(renderHTML)  
  #literal rendering
  literal <- key$type %in% c("{}", "&")
  render[literal] <- list(renderText)
  
  # parse sections and inverted sections
  exclude <- logical(n)
  insection <- integer(n)
  stack <- 0L
  for (i in seq_along(key$key)){
     h <- stack[1]
     insection[i] <- h
     type <- key$type[i]

     if(type %in% c("#", "^")){
       # section and inverted section
       stack <- c(i, stack)
     } else if (type == "/"){
       #end section
       stack <- stack[-1]
       
       if (key$key[h]!=key$key[i]){
          stop("Template contains unbalanced closing tag. Found: '/", key$key[i], "' but expected: '/", key$key[h],"'")
       }
       
       # make a section or inverted section
       idx <- which(h==insection)
       kidx <- idx[-length(idx)]

       renderFUN <- if (key$type[h] == "#") section
                    else inverted
      
       render[h] <- list(renderFUN( text[idx]
                                  , key$key[kidx]
                                  , render[kidx]
                                  ) 
                        )
       } else if (type == ">"){
         render[i] <- renderEmpty
         #partial
         stop("Partials not (yet) supported")
     } 
  }
  if (length(stack) > 1){
     stop("Template does not close the following tags: ", key$rawkey[stack])
  }
  
  exclude <- insection > 0
  keys <- key$key[!exclude]
  text <- text[c(!exclude, TRUE)[seq_along(text)]] # only select text that is needed
  render <- render[!exclude]
  
  structure( list( texts=text
                 , keys=keys
                 , renders=render
                 , keyinfo = key  #debugging purposes
                 )
            , class="template"
            )
}

getKeyInfo <- function(template, KEY){
  first <- gregexpr(KEY, template)[[1]]
  last <- attr(first, "match.length") + first - 1
  keys <- substring(template, first, last)
  keys <- gsub(KEY, "\\1", keys)
  
  key <- data.frame(rawkey=keys, first=first, last=last)
  
  # keys should not contain white space, (triple and ampersand may contain surrounding whitespace
  key$key <- gsub("\\s", "", key$rawkey)
  key$type <- factor("", levels=keytypes)
  
  key$type[grep(TRIPLE, key$rawkey)] <- "{}"
  key$type[grep(AMPERSAND, key$rawkey)] <- "&"
  key$type[grep(SECTION, key$rawkey)] <- "#"
  key$type[grep(INVERTEDSECTION, key$rawkey)] <- "^"
  key$type[grep(ENDSECTION, key$rawkey)] <- "/"
  key$type[grep(PARTIAL, key$rawkey)] <- ">"

  key$key <- gsub(TRIPLE, "\\1",key$key)
  key$key <- gsub(AMPERSAND, "\\1",key$key)
  key$key <- gsub(SECTION, "\\1",key$key)
  key$key <- gsub(INVERTEDSECTION, "\\1",key$key)
  key$key <- gsub(ENDSECTION, "\\1",key$key)
  key$key <- gsub(PARTIAL, "\\1",key$key)
  key
}

inlineStandAlone <- function(text, DELIM, keyregexp, end=FALSE){
   dKEY <- paste(DELIM[1],keyregexp, DELIM[2], sep="")
   
   #remove stand alone comment lines
   re <- paste("(^|\r?\n)\\s*?(",dKEY,")\\s*?(\n|$)", sep="")
   if (end)
     gsub(re, "\\1\\2",  text)
   else
     gsub(re, "\\1\\2",  text)     
}

removeComments <- function(text, DELIM){
   text <- inlineStandAlone(text, DELIM, COMMENT)
  
   #remove inline comments
   dCOMMENT <- paste(DELIM[1],COMMENT, DELIM[2], sep="")   
   gsub(dCOMMENT, "",  text)
}
