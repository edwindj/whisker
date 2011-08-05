library(testthat)

context("sections")

test_that("Truthy",{
  data <- list(boolean=TRUE)
  str <- whisker.render('"{{#boolean}}This should be rendered.{{/boolean}}"', data)
  expect_equal(str, '"This should be rendered."')
})

test_that("Falsey",{
  boolean=FALSE
  str <- whisker.render('"{{#boolean}}This should not be rendered.{{/boolean}}"')
  expect_equal(str, '""')
})

test_that("Context",{
  data <- list(context=list(name='Joe'))
  str <- whisker.render('"{{#context}}Hi {{name}}.{{/context}}"', data=data, debug=TRUE)
  expect_equal(str, '"Hi Joe."')
})  