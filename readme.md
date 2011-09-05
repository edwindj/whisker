Whisker
=======

Whisker is a [{{Mustache}}](http://mustache.github.com) implementation in [R](http://www.r-project.org/) confirming to the Mustache specification.
Mustache is a logicless templating language, meaning that no programming source
code can be used in your templates. This may seem very limited, but Mustache is 
nonetheless powerful and has the advantage of being able to be used unaltered in 
many programming 
languages. For example it make it very easy to write a web application in R using Mustache templates
and where the browser can template using javascript's "Mustache.js" 

Mustache (and therefore whisker) takes a simple but different approach to
templating compared to most templating engines. Most templating library 
for example `Sweave`, `brew` allow the user to mix programming code and text 
throughout the template. This is powerful, but ties a template directly
to a programming language. Furthermore it make it difficult to seperate 
programming code from templating code.

Whisker on the other hand, takes a Mustache template and uses the variables of the 
current `environment` (or the supplied `list` to fill in the variables).

Installation
============

Whisker is not (yet) available from CRAN but can be installed from github

```
library(devtools)

#dev_mode()
install_github("whisker", "edwindj")
```

Usage
-----

###render

`whisker.render` accepts a `character`

```
template <- 
'Hello {{name}}
You have just won ${{value}}!
{{#in_ca}}
Well, ${{taxed_value}}, after taxes.
{{/in_ca}}'

data <- list( name = "Chris"
            , value = 10000
            , taxed_value = 10000 - (10000 * 0.4)
            , in_ca = TRUE
            )

whisker.render(template, data)
```

###escape