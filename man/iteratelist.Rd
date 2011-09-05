\name{iteratelist}
\alias{iteratelist}
\title{Create an iteration list from a R object}
\usage{
  iteratelist(x, name = "name", value = "value")
}
\arguments{
  \item{x}{\code{list} or other object that will be coerced
  to \code{list}}

  \item{name}{\code{character} name for resulting name
  member.}

  \item{value}{\code{character} name for resulting value
  member.}
}
\value{
  unnamed \code{list} with name value lists
}
\description{
  In some case it is useful to iterate over a named
  \code{list} or \code{vector} \code{iteratelist} will
  create a new unnamed \code{list} with key value members:
  each item will be a list where 'key' is the corresponding
  name and 'value' is the original value in list \code{x}.
}

