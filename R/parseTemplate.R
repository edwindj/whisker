#key type regexpr
TRIPLE <- "^\\{(.+)\\}"
AMPERSAND <- "^&(.+)"
SECTION <- "\\#([ A-z0-9.]+)"
INVERTEDSECTION <- "\\^([ A-z0-9.]+)"
ENDSECTION <- "/([ A-z0-9.]+)"
PARTIAL <- ">\\s*(.+?)\\s*"
COMMENT <- "!.+?"
DELIM <- "=\\s*(.+?)\\s*="

STANDALONE <- "[#/^][A-z0-9]+"

#keytypes
keytypes <- c("", "{}", "&", "#", "^", "/", ">")


# current parsing code is not a clean parsing state machine!
# This is partly due to that this would be clumsy in R, 
# It's on my list to do the parsing in C (would be significantly faster)
parseTemplate <- function(template, partials=new.env(), debug=FALSE, strict=TRUE){
  #TODO add delimiter switching

  delim <- tag2delim()
  
  template <- paste(template, collapse="\n")
  template <- replace_delim_tags(template)
  template <- removeComments(template, delim)
  
  template <- inlinePartial(template, delim)
  template <- inlineStandAlone2(template, delim, STANDALONE)
#   template <- inlineStandAlone(template, delim, ENDSECTION)
#   template <- inlineStandAlone(template, delim, SECTION)
#   template <- inlineStandAlone(template, delim, INVERTEDSECTION)
 
  KEY <- delimit("(.+?)", delim)
 
  text <- strsplit(template, KEY)[[1]] 
  text <- literal_tags(text)
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
         #partial
         indent <- sub(">([ \t]*).+","\\1", key$rawkey[i])
         render[i] <- list(partial(key$key[i], partials, indent))
     } 
  }
  if (length(stack) > 1){
     stop("Template does not close the following tags: ", key$rawkey[stack])
  }
  
  exclude <- insection > 0
  keys <- key$key[!exclude]
  texts <- text[c(!exclude, TRUE)[seq_along(text)]] # only select text that is needed
  renders <- render[!exclude]
  
  compiled <- function(data=list(), context=list(data)){
    values <- lapply(keys, resolve, context=context, strict=strict)
    keyinfo <- key
    renderTemplate( values=values
                  , context=context
                  , texts=texts
                  , renders=renders
                  , debug=debug
                  )
  }
  
  class(compiled) <- "template"
  compiled
}

getKeyInfo <- function(template, KEY){
  first <- gregexpr(KEY, template)[[1]]
  last <- attr(first, "match.length") + first - 1
  keys <- substring(template, first, last)
  keys <- gsub(KEY, "\\1", keys)
  
  key <- data.frame(rawkey=keys, first=first, last=last, stringsAsFactors=FALSE)
  
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

inlineStandAlone2 <- function(text, delim, keyregexp){
  # remove groups from regexp
  keyregexp <- gsub("\\(|\\)","",keyregexp)
  
  dKEY <- delimit(keyregexp, delim)
  
  re <- paste("(?<=\n|^)([ \t]*)(",dKEY,")\\s*?(\n|$)", sep="")
  
  rex <- gregexpr(re, text, perl=T)
  rex1 <- gregexpr(dKEY, text)
  gsub(re, "\\2",  text, perl=T)
}

inlineStandAlone <- function(text, delim, keyregexp){
   # remove groups from regexp
   keyregexp <- gsub("\\(|\\)","",keyregexp)
   
   dKEY <- delimit(keyregexp, delim)
   
   re <- paste("(^|\n)([ \t]*)(",dKEY,")\\s*?(\n|$)", sep="")

   rex <- regexpr(re, text)
   gsub(re, "\\1\\3",  text)
}

removeComments <- function(text, delim){
   text <- inlineStandAlone(text, delim, COMMENT)
  
   #remove inline comments
   dCOMMENT <- paste(delim[1],COMMENT, delim[2], sep="")   
   gsub(dCOMMENT, "",  text)
}

inlinePartial <- function(text, delim){
   dKEY <- paste(delim[1],PARTIAL, delim[2], sep="")
   text <- gsub(dKEY, "{{>\\1}}", text)
   re <- paste("(^|\n)([ \t]*)",dKEY,"\\s*?(\n|$)", sep="")
   rep <- paste("\\1\\2", delim[1],">\\2\\3",delim[2], sep="")
   gsub(re, rep,  text)   
}
