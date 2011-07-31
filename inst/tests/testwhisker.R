library(testthat)
context("Interpolation")
test_that("No Interpolation", {
  data <- list()
  
  expect_equal( whisker("Hello from {Mustache}!", data)
              , "Hello from {Mustache}!"
              )
})

test_that("Basic Interpolation", {
  data <- list(subject="world")
  
  expect_equal( whisker("Hello, {{subject}}!", data)
              , "Hello, world!"
              )
})

test_that("HTML Escaping", {
  data <- list(forbidden= '& " < >')
  
  expect_equal( whisker("These characters should be HTML escaped: {{forbidden}}", data)
              , 'These characters should be HTML escaped: &amp; &quot; &lt; &gt;'
              )
})

test_that("Triple Mustache", {
  data <- list(forbidden= '& " < >')
  
  expect_equal( whisker("These characters should not be HTML escaped: {{{forbidden}}}", data)
              , 'These characters should not be HTML escaped: & " < >'
              )
})

test_that("Ampersand", {
  data <- list(forbidden= '& " < >')
  
  expect_equal( whisker("These characters should not be HTML escaped: {{&forbidden}}", data)
              , 'These characters should not be HTML escaped: & " < >'
              )
})

test_that("Basic Integer Interpolation", {
  data <- list(mph=85)
  
  expect_equal( whisker('"{{mph}} miles an hour!"', data)
              , '"85 miles an hour!"'
              )
})

test_that("Triple Mustache Integer Interpolation", {
  data <- list(mph=85)
  
  expect_equal( whisker('"{{{mph}}} miles an hour!"', data)
              , '"85 miles an hour!"'
              )
})

test_that("Ampersand Integer Interpolation", {
  data <- list(mph=85)
  
  expect_equal( whisker('"{{&mph}} miles an hour!"', data)
              , '"85 miles an hour!"'
              )
})

test_that("Basic Decimal Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker('"{{power}} jiggawatts!"', data)
              , '"1.21 jiggawatts!"'
              )
})

test_that("Triple Mustache Decimal Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker('"{{{power}}} jiggawatts!"', data)
              , '"1.21 jiggawatts!"'
              )
})

test_that("Ampersand Decimal Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker('"{{&power}} jiggawatts!"', data)
              , '"1.21 jiggawatts!"'
              )
})

context("Context Misses")

test_that("Basic Context Miss Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker('I ({{cannot}}) be seen!', data)
              , "I () be seen!"
              )
})

test_that("Triple Mustache Context Miss Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker('I ({{{cannot}}}) be seen!', data)
              , "I () be seen!"
              )
})

test_that("Ampersand Context Miss Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker('I ({{&cannot}}) be seen!', data)
              , "I () be seen!"
              )
})
context("Dotted names")

context("Whitespace Sensitivity")

test_that("Interpolation - Surrounding Whitespace", {
  data <- list(string="---")
  
  expect_equal( whisker("| {{string}} |", data)
              , "| --- |"
              )
})

test_that("Triple Mustache - Surrounding Whitespace", {
  data <- list(string="---")
  
  expect_equal( whisker("| {{{string}}} |", data)
              , "| --- |"
              )
})

test_that("Ampersand - Surrounding Whitespace", {
  data <- list(string="---")
  
  expect_equal( whisker("| {{&string}} |", data)
              , "| --- |"
              )
})

test_that("Interpolation - Standalone", {
  data <- list(string="---")
  
  expect_equal( whisker("  {{string}}\n", data)
              , "  ---\n"
              )
})

test_that("Triple Mustache - Standalone", {
  data <- list(string="---")
  
  expect_equal( whisker("  {{{string}}}\n", data)
              , "  ---\n"
              )
})

test_that("Ampersand - Standalone", {
  data <- list(string="---")
  
  expect_equal( whisker("  {{&string}}\n", data)
              , "  ---\n"
              )
})

context("Whitespace Insensitivity")

test_that("Interpolation With Padding", {
  data <- list(string="---")
  
  expect_equal( whisker("|{{ string }}|", data)
              , "|---|"
              )
})

test_that("Triple Mustache With Padding", {
  data <- list(string="---")
  
  expect_equal( whisker("|{{{ string }}}|", data)
              , "|---|"
              )
})

test_that("Ampersand With Padding", {
  data <- list(string="---")
  
  expect_equal( whisker("|{{& string }}|", data)
              , "|---|"
              )
})