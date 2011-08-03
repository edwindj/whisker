# key types regexpr
TRIPLE <- "^\\{(.+)\\}"
AMPERSAND <- "^&(.+)"
SECTION <- "\\#(.+)"
INVERTEDSECTION <- "\\^(.+)"
ENDSECTION <- "/(.+)"
PARTIAL <- "\\\\>(.+)"

#keytypes
keytypes <- c("", "{}", "&", "#", "^", "/", ">")

parseTemplate <- function(template, debug=FALSE){
  #TODO add delimiter switching
  delim <- strsplit("{{ }}"," ")[[1]]
  
  DELIM <- gsub("([{<>}*?+])", "\\\\\\1", delim)
  
  template <- removeComments(template, DELIM)
  
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
  stack <- integer()
  for (i in seq_along(key$key)){
     type <- key$type[i]
     if(type %in% c("#", "^")){
       stack <- c(i, stack)
     } else if (type == "/"){
       h <- stack[1]
       stack <- stack[-1]
       
       if (key$key[h]!=key$key[i]){
          stop("Template contains unbalanced closing tag. Found: '/", key$key[i], "' but expected: '/", key$key[h],"'")
       }
       
       # make a section or inverted section
       idx <- i:(h+1)
       exclude[idx] <- TRUE
       if (debug) print(list(idx=idx, text=text))
       render[h] <- list(section( text[idx]
                                , key$key[idx[-1]]
                                , render[idx[-1]]
                                , debug=debug
                                ) 
                                #TODO add raw template text using first and last
                        )
       
     } else if (type == ">"){
       stop("Partials (not) yet supported")
     }
  }
  if (length(stack)){
     stop("Template does not close the following tags: ", key$rawkey[stack])
  }
  
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
    
  # keys should not contains white space, (triple and ampersand may contain surrounding whitespace
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

removeComments <- function(text, DELIM){
   COMMENT <- paste(DELIM[1],"!.+?", DELIM[2], sep="")
   
   #remove stand alone comment lines
   re <- paste("(^|\n)\\s*",COMMENT,"\\s*?(\n|$)", sep="")
   text <- gsub(re, "\\1",  text)

   #remove inline comments
   text <- gsub(COMMENT, "",  text)
   text
}
