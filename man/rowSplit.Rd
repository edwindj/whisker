\name{rowSplit}
\alias{rowSplit}
\title{Split a data.frame or matrix into rows}
\usage{
  rowSplit(x, ...)
}
\arguments{
  \item{x}{\code{data.frame} or \code{matrix}}

  \item{...}{other options will be passed onto
  \code{\link{split}}}
}
\description{
  Utility function for splitting a data.frame into rows. In
  a whisker template it can be useful to iterate over the
  rows of a data.frame or matrix. For example rendering a
  table in HTML.
}

