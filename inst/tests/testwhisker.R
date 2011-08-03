library(testthat)
context("Interpolation basics")
test_that("No Interpolation", {
  data <- list()
  
  expect_equal( whisker.render("Hello from {Mustache}!", data)
              , "Hello from {Mustache}!"
              )
})

test_that("Basic Interpolation", {
  data <- list(subject="world")
  
  expect_equal( whisker.render("Hello, {{subject}}!", data)
              , "Hello, world!"
              )
})

test_that("HTML Escaping", {
  data <- list(forbidden= '& " < >')
  str <- whisker.render("These characters should be HTML escaped: {{forbidden}}", data)
  expect_equal( str
              , 'These characters should be HTML escaped: &amp; &quot; &lt; &gt;'
              )
})

test_that("Triple Mustache", {
  data <- list(forbidden= '& " < >')
  
  expect_equal( whisker.render("These characters should not be HTML escaped: {{{forbidden}}}", data)
              , 'These characters should not be HTML escaped: & " < >'
              )
})

test_that("Ampersand", {
  data <- list(forbidden= '& " < >')
  
  expect_equal( whisker.render("These characters should not be HTML escaped: {{&forbidden}}", data)
              , 'These characters should not be HTML escaped: & " < >'
              )
})

test_that("Basic Integer Interpolation", {
  data <- list(mph=85)
  
  expect_equal( whisker.render('"{{mph}} miles an hour!"', data)
              , '"85 miles an hour!"'
              )
})

test_that("Triple Mustache Integer Interpolation", {
  data <- list(mph=85)
  
  expect_equal( whisker.render('"{{{mph}}} miles an hour!"', data)
              , '"85 miles an hour!"'
              )
})

test_that("Ampersand Integer Interpolation", {
  data <- list(mph=85)
  
  expect_equal( whisker.render('"{{&mph}} miles an hour!"', data)
              , '"85 miles an hour!"'
              )
})

test_that("Basic Decimal Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker.render('"{{power}} jiggawatts!"', data)
              , '"1.21 jiggawatts!"'
              )
})

test_that("Triple Mustache Decimal Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker.render('"{{{power}}} jiggawatts!"', data)
              , '"1.21 jiggawatts!"'
              )
})

test_that("Ampersand Decimal Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker.render('"{{&power}} jiggawatts!"', data)
              , '"1.21 jiggawatts!"'
              )
})

context("Interpolation Context Misses")

test_that("Basic Context Miss Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker.render('I ({{cannot}}) be seen!', data)
              , "I () be seen!"
              )
})

test_that("Triple Mustache Context Miss Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker.render('I ({{{cannot}}}) be seen!', data)
              , "I () be seen!"
              )
})

test_that("Ampersand Context Miss Interpolation", {
  data <- list(power=1.210)
  
  expect_equal( whisker.render('I ({{&cannot}}) be seen!', data)
              , "I () be seen!"
              )
})
context("Interpolation dotted names")

test_that("Dotted Names - Basic Interpolation", {
  data <- list(person=list(name="Joe"))
  
  expect_equal( whisker.render('"{{person.name}}" == "Joe"', data)
              , '"Joe" == "Joe"'
              )
})

test_that("Dotted Names - Triple Mustache Interpolation", {
  data <- list(person=list(name="Joe"))
  
  expect_equal( whisker.render('"{{{person.name}}}" == "Joe"', data)
              , '"Joe" == "Joe"'
              )
})

test_that("Dotted Names - Ampersand Interpolation", {
  data <- list(person=list(name="Joe"))
  
  expect_equal( whisker.render('"{{&person.name}}" == "Joe"', data)
              , '"Joe" == "Joe"'
              )
})

test_that("Dotted Names - Arbitrary Depth", {
  data <- list(a=list(b=list(c=list(d=list(e=list(name="Phil"))))))
  
  expect_equal( whisker.render('"{{a.b.c.d.e.name}}" == "Phil"', data)
              , '"Phil" == "Phil"'
              )
})

test_that("Dotted Names - Broken chains", {
  data <- list(a=list())
  
  expect_equal( whisker.render('"{{a.b.c}}" == ""', data)
              , '"" == ""'
              )
})

test_that("Dotted Names - Broken chain resolution", {
  data <- list(a=list(b=list()), c=list(name="Jim"))
  
  expect_equal( whisker.render('"{{a.b.c.name}}" == ""', data)
              , '"" == ""'
              )
})
context("Interpolation Whitespace Sensitivity")

test_that("Interpolation - Surrounding Whitespace", {
  data <- list(string="---")
  
  expect_equal( whisker.render("| {{string}} |", data)
              , "| --- |"
              )
})

test_that("Triple Mustache - Surrounding Whitespace", {
  data <- list(string="---")
  
  expect_equal( whisker.render("| {{{string}}} |", data)
              , "| --- |"
              )
})

test_that("Ampersand - Surrounding Whitespace", {
  data <- list(string="---")
  
  expect_equal( whisker.render("| {{&string}} |", data)
              , "| --- |"
              )
})

test_that("Interpolation - Standalone", {
  data <- list(string="---")
  
  expect_equal( whisker.render("  {{string}}\n", data)
              , "  ---\n"
              )
})

test_that("Triple Mustache - Standalone", {
  data <- list(string="---")
  
  expect_equal( whisker.render("  {{{string}}}\n", data)
              , "  ---\n"
              )
})

test_that("Ampersand - Standalone", {
  data <- list(string="---")
  
  expect_equal( whisker.render("  {{&string}}\n", data)
              , "  ---\n"
              )
})

context("Interpolation Whitespace Insensitivity")

test_that("Interpolation With Padding", {
  data <- list(string="---")
  
  expect_equal( whisker.render("|{{ string }}|", data)
              , "|---|"
              )
})

test_that("Triple Mustache With Padding", {
  data <- list(string="---")
  
  expect_equal( whisker.render("|{{{ string }}}|", data)
              , "|---|"
              )
})

test_that("Ampersand With Padding", {
  data <- list(string="---")
  
  expect_equal( whisker.render("|{{& string }}|", data)
              , "|---|"
              )
})