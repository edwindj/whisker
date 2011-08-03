library(testthat)

context("Environment")

test_that("Taking variable from enclosing environment works", {
  subject <- "world"
  str <- whisker.render("Hello, {{subject}}!")
  expect_equal( str
              , "Hello, world!"
              )
})

context("Data.frame")

context("Vector")
