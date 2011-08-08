\name{whisker.render}
\alias{whisker}
\alias{whisker.render}
\title{Logicless templating}
\usage{
  whisker.render(template, data = parent.frame())

  whisker(template, data = parent.frame())
}
\arguments{
  \item{template}{\code{character} with template text}

  \item{data}{named \code{list} or env}
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

