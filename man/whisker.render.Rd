\name{whisker.render}
\alias{whisker.render}
\title{Logicless templating}
\usage{
  whisker.render(template, data = parent.frame(),
    partials = list(), debug = FALSE)
}
\arguments{
  \item{template}{\code{character} with template text}

  \item{data}{named \code{list} or \code{environment} with
  variables that will be used during rendering}

  \item{partials}{named \code{list} with partial templates,
  will be used during template construction}

  \item{debug}{Used for debugging purposes, likely to
  disappear}
}
\value{
  \code{character} with rendered template
}
\description{
  Logicless templating
}
\examples{
template <- "Hello {{place}}!"
place <- "World"

whisker.render(template)
}

