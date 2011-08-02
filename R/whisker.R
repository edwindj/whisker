#' Logicless templating
#'
#' @param template \code{character}
#' @param data named \code{list} or env
#' @rdname whisker.render
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

#' @rdname whisker.render
whisker.render <- whisker

parseTemplate <- function(template){
  #TODO add delimiter switching

  delim <- strsplit("{{ }}"," ")[[1]]
  DELIM <- gsub("([{<>}])", "\\\\\\1", delim)
    
  template <- removeComments(template, DELIM)
  
  KEY <- paste(DELIM[1],"(.+?)", DELIM[2], sep="")
  
  text <- strsplit(template, KEY)[[1]]
  
  first <- gregexpr(KEY, template)[[1]]
  last <- attr(first, "match.length") + first - 1
  keys <- substring(template, first, last)
  keys <- gsub(KEY, "\\1", keys)
  # remove all white spaces 
  keys <- gsub("\\s", "", keys)
  
  #TODO add section stuff
  func <- list()
  func[1:length(keys)] <- list(whisker.escape)

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

#' escape basic HTML characters
#'
#' This method will be called for double mustache entries
#' @export
#' @param x \code{character} that will be escaped
#' @return HTML escaped character 
whisker.escape <- function(x){
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
  
removeComments <- function(text, DELIM){
   COMMENT <- paste(DELIM[1],"!.+?", DELIM[2], sep="")
   
   #remove stand alone comment lines
   re <- paste("(^|\n)\\s*",COMMENT,"\\s*?(\n|$)", sep="")
   text <- gsub(re, "\\1",  text)

   #remove inline comments
   text <- gsub(COMMENT, "",  text)
   text
}
