library(testthat)

test_that("Whisker", {
  data <- list(data="World")
  
  expect_equal( whisker("Hello {{data}}!", data)
              , "Hello World!"
              )
})