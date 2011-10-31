ALTDELIM <- "~~~~~~~~~~~~~ ~~~~~~~~~~~~~"

#' change a delimiter tag into two escaped characters 
#' 
#' @param tag character with delimiter tag seperated with a space
#' @param tag character with delimiter tag seperated with a space
#' @keywords internal
tag2delim <- function(tag="{{ }}", escape=TRUE){
  delim <- strsplit(tag," ")[[1]]
  if (escape)
    gsub("([[{}*?+])", "\\\\\\1", delim)
  else
    delim
}

#' Split a character in three parts 
#' 
#' It differs from strsplit in that it only splits on the first occurrence
#' and returns all parts of the string given
#' @param x character text to be split
#' @param pattern pattern used for splitting
#' @keywords internal
rxsplit <- function(x, pattern){
  matched <- regexpr(pattern, x)
  if (matched == -1){
    return(x)
  }
  ml <- attr(matched, "match.length")
  c( substring(x,1,matched-1)
   , substring(x,matched, matched+ml-1)
   , substring(x, matched + ml)
   )
}

#' enclose a key with delimiters
#' 
#' @param x character with delimiter seperated with a space
#' @param delim character vector with escaped delimiters
#' @keywords internal
delimit <- function(x, delim=tag2delim()){
  paste(delim[1], x, delim[2], sep="")
}

replace_delim_tags <- function(template){
  text <- list()
  defdelim <- tag2delim()
  altdelim <- tag2delim(ALTDELIM, escape=FALSE)
  
  defkeytag <- delimit("(.+?)", defdelim)
  altkeytag <- delimit("\\1", altdelim)
  
  tag <- "{{ }}"
  
  while (!is.na(template)){
    delim <- tag2delim(tag)
    delimtag <- delimit(DELIM, delim)
    keytag <- delimit("(.+?)", delim)
    template <- inlineStandAlone(template, delim, DELIM)
    rx <- rxsplit(template, delimtag)
    txt <- rx[1]
    
    if (tag != "{{ }}"){
      txt <- gsub(defkeytag, altkeytag, txt)
    }
    txt <- gsub(keytag, "{{\\1}}", txt)
    
    text[length(text)+1] <- txt
    
    tag <- sub(delimtag, "\\1", rx[2])
    template <- rx[3]
  }
  #print(text)
  paste(text, collapse="")
}
  
literal_tags <- function(txt){
  altdelim <- tag2delim(ALTDELIM)
  defdelim <- tag2delim("{{ }}", escape=FALSE)
  
  altkeytag <- delimit("(.+?)", altdelim)
  defkeytag <- delimit("\\1", defdelim)
  gsub(altkeytag, defkeytag, txt)
}

### quick testing
#delim2rx("<% %>")

# template <- "test {{=<% %>}} <%key%> {{key1}} <%=[[ ]]%> bla, [[key2]]  [[={{ }}]] {{key3}} 1, 2, 3"
#rxsplit(template, delimtag)
# r <- replace_delim_tags(template)
# r
# literal_tags(r)

#replace_delim_tags(template)