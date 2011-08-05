library(testthat)

context("Inverted sections")

test_that("Falsey",{
  data <- list(boolean=FALSE)
  str <- whisker.render('"{{^boolean}}This should be rendered.{{/boolean}}"', data)
  expect_equal(str, '"This should be rendered."')
})

test_that("Truthy",{
  boolean=TRUE
  str <- whisker.render('"{{^boolean}}This should not be rendered.{{/boolean}}"')
  expect_equal(str, '""')
})

test_that("Context",{
  data <- list(context=list(name='Joe'))
  str <- whisker.render('"{{^context}}Hi {{name}}.{{/context}}"', data=data)
  expect_equal(str, '""')
})

test_that("Lists",{
  list <- list(list(n=1), list(n=2), list(n=3))
  str <- whisker.render('"{{^list}}{{n}}{{/list}}"')
  expect_equal(str, '""')
})

test_that("Empty list",{
  list <- list()
  str <- whisker.render('"{{^list}}Yay lists!{{/list}}"')
  expect_equal(str, '"Yay lists!"')
}) 

test_that("Double",{
  bool <- FALSE
  two <- "second"
  
  str <- whisker.render('{{^bool}}
* first
{{/bool}}
* {{two}}
{{^bool}}
* third
{{/bool}}')
  print(str)
  expect_equal(str, '"* first
* second
* third"')
})