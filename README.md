![version](http://www.r-pkg.org/badges/version/whisker)
![downloads](http://cranlogs.r-pkg.org/badges/whisker)
[![Build Status](https://travis-ci.org/edwindj/whisker.png?branch=master)](https://travis-ci.org/edwindj/whisker)
[![Build status](https://ci.appveyor.com/api/projects/status/p8t4sin18l54h72d?svg=true)](https://ci.appveyor.com/project/edwindj/whisker)

Whisker
=======

Whisker is a [{{Mustache}}](http://mustache.github.com) implementation in 
[R](http://www.r-project.org/) confirming to the Mustache specification.
Mustache is a logicless templating language, meaning that no programming source
code can be used in your templates. This may seem very limited, but Mustache is 
nonetheless powerful and has the advantage of being able to be used unaltered in 
many programming languages. It makes it very easy to write a web application in R 
using Mustache templates which could also be re-used for client-side rendering with
"Mustache.js".

Mustache (and therefore whisker) takes a simple, but different, approach to
templating compared to most templating engines. Most templating libraries, 
such as `Sweave`, `knitr` and `brew`, allow the user to mix programming code and text 
throughout the template. This is powerful, but ties your template directly
to a programming language and makes it difficult to seperate programming code from 
templating code.

Whisker, on the other hand, takes a Mustache template and uses the variables of the 
current `environment` (or the supplied `list`) to fill in the variables.

Mustache syntax
---------------

The syntax of Mustache templates is described in http://mustache.github.com/mustache.5.html 
How the mustache template are used with whisker can be found in the whisker documentation, and below.

Mustache specification
----------------------
Whisker conforms to the [Mustache 1.1 specificaton](https://github.com/mustache/spec) except for delimiter switching and
lambdas. We expect that these will be implented shortly.

Installation
============

To install whisker use the following statement in your R console

```S
install.packages("whisker")
```

The latest whisker version is not yet available on CRAN, but can be installed from github:

```S
library(devtools)

# dev_mode()
install_github("whisker", "edwindj")
```

Usage
-----

`whisker.render` accepts a `character` template and a list or environment containing data to render:


```S
library(whisker)
template <- 
'Hello {{name}}
You have just won ${{value}}!
{{#in_ca}}
Well, ${{taxed_value}}, after taxes.
{{/in_ca}}
'

data <- list( name = "Chris"
            , value = 10000
            , taxed_value = 10000 - (10000 * 0.4)
            , in_ca = TRUE
            )

text <- whisker.render(template, data)
cat(text)
```

```
## Hello Chris
## You have just won $10000!
## Well, $6000, after taxes.
```


Or using a text file


```S
library(whisker)

template <- readLines("./template.html")
data <- list( name = "Chris"
            , value = 10000
            , taxed_value = 10000 - (10000 * 0.4)
            , in_ca = TRUE
            )

writeLines(whisker.render(template, data), "./output.html")
```


Note
----

By default `whisker` applies `html` escaping on the generated text.
To prevent this use `{{{variable}}}` (triple) in stead of `{{variable}}`.


```S
template <- 
"I'm escaped: {{name}}
And I'm not: {{{name}}}"

data <- list( name = '<My Name="Nescio">')
whisker.render(template, data)
```

Generates:
```
I'm escaped: &lt;My Name=&quot;Nescio&quot;&gt;
And I'm not: <My Name="Nescio">
```
