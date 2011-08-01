#' Logicless templating
#'
#' @param template \code{character}
#' @param data named \code{list} or env
#' @export
whisker <- function(template, data){
   tmpl <- parseTemplate(template)
   #print(tmpl)
   
   # to do check different key names
   
   s <- mapply(tmpl$keys, tmpl$func, FUN=function(key, fun){
     keydata <- resolve(data, key)
     fun(keydata)
   })
   
   sqt <- 2*seq_along(tmpl$text)-1
   sqk <- 2*seq_along(tmpl$keys)
   str <- character()
   str[sqt] <- tmpl$text
   str[sqk] <- s
   str <- as.list(str)
   str["sep"] <- ""
   
   do.call(paste, str)
}

parseTemplate <- function(template){
  #TODO add delimiter switching

  delim <- strsplit("{{ }}"," ")[[1]]
    
  template <- removeComments(template, delim)
 
  keyregexpr <- function(delim){
     delim <- gsub("([{<>}])", "\\\\\\1", delim)
     re <- paste(delim[1],"\\s*(.+?)\\s*", delim[2], sep="")
     re
  }
     
  re <- keyregexpr(delim)
  
  text <- strsplit(template, re)[[1]]
  
  first <- gregexpr(re, template)[[1]]
  last <- attr(first, "match.length") + first - 1
  keys <- substring(template, first, last)
  keys <- gsub(re, "\\1", keys)

  #TODO add section stuff
  func <- list()
  func[1:length(keys)] <- list(toHTML)

  # triple mustache
  txt <- grep("^\\{(.+)\\}", keys)
  keys <- gsub("^\\{\\s*(.+?)\\s*\\}", "\\1",keys)
  func[txt] <- list(toText)
  
  #ampersand
  txt <- grep("^&(.+)", keys)
  keys <- gsub("^&\\s*(.+?)\\s*", "\\1",keys)
  func[txt] <- list(toText)
    
  structure( list( text=text
                 , keys=keys
                 , func=func
                 )
            , class="template"
            )
}

toText <- function(x){
  as.character(x)
}

toHTML <- function(x){
  x <- gsub("&", "&amp;", x)
  x <- gsub("<", "&lt;", x)
  x <- gsub(">", "&gt;", x)
  x <- gsub('"', "&quot;", x)
  x
} 
   
makeSection <- function(key, text, keys){
}

makeInvertedSection <- function(key, text, keys){
}

resolve <- function(ctxt, tag){
  if (tag=="."){
    return(ctxt)
  }
  val <- ctxt
  keys <- strsplit(tag, split=".", fixed=TRUE)[[1]]
  for (key in keys){
    val <- if (is.environment(val)){
             get(key, envir=val)
           } else {
             as.list(val)[[key]]
           }
  }
  val
}
  
removeComments <- function(text, delim){
   delim <- gsub("([{<>}])", "\\\\\\1", delim)
   
   #remove stand alone commentlines
   re <- paste("(^|\n)\\s*",delim[1],"!.+?", delim[2],"\\s*?(\n|$)", sep="")
   text <- gsub(re, "\\1",  text)

   #remove inline comments
   re <- paste(delim[1],"!.+?", delim[2], sep="")
   text <- gsub(re, "",  text)

   text
}
