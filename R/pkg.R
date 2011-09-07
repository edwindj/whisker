#' {{Mustache for R}}
#'
#' Whisker is a templating engine for R conforming to the Mustache specification.
#' Mustache is a logicless templating language, meaning that no programming source
#' code can be used in your templates. This may seem very limited, but Mustache is nonetheless
#' powerful and has the advantage of being able to be used unaltered in many programming 
#' languages. For example it make it very easy to write a web application in R using Mustache templates
#' and where the browser can template using javascript's "Mustache.js" 
#'
#' Mustache (and therefore \code{whisker}) takes a simple but different approach to templating compared to 
#' most templating engines. Most templating libraries for example \code{Sweave} and \code{brew} allow the user
#' to mix programming code and text throughout the template. This is powerful, but ties a template directly
#' to a programming language. Furthermore that approach makes it difficult to seperate programming code 
#' from templating code.
#'
#' Whisker on the other hand, takes a Mustache template and uses the variables of the current environment (or the
#' supplied \code{list}) to fill in the variables.
#' 
#' @example examples/pkg.R
#' @name whisker-package 
#' @docType package 
{}