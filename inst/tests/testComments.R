library(testthat)

context("Comments")

test_that("Inline", {
  data <- list()
  
  expect_equal( whisker('12345{{! Comment Block! }}67890', data)
              , '1234567890'
              )
})

test_that("Multiline", {
  data <- list()
  
  expect_equal( whisker('12345{{!
        This is a
        multi-line comment...
      }}67890', data)
              , '1234567890'
              )
})

test_that("Standalone", {
  data <- list()
  expect_equal( whisker('Begin.
{{! Comment Block! }}
End.', data)
              , 'Begin.
End.'
              )
})

test_that("Indented Standalone", {
  data <- list()
  expect_equal( whisker('Begin.
  {{! Comment Block! }}
End.', data)
              , 'Begin.
End.'
              )
})

test_that("Standalone Line Endings", {
  data <- list()
  expect_equal( whisker('|\r\n{{! Standalone Comment }}\r\n|', data)
              , '|\r\n|'
              )
})

test_that("Standalone Without Previous Line", {
  data <- list()
  expect_equal( whisker("  {{! I'm Still Standalone }}\n!", data)
              , '!'
              )
})

test_that("Standalone Without Newline", {
  data <- list()
  expect_equal( whisker("!\n  {{! I'm Still Standalone }}", data)
              , "!\n"
              )
})

test_that("Multiline Standalone", {
  data <- list()
  expect_equal( whisker("Begin.
{{!
Something's going on here...
}}
End.", data)
              , "Begin.
End."
              )
})

test_that("Indented Multiline Standalone", {
  data <- list()
  expect_equal( whisker("Begin.
{{!
  Something's going on here...
}}
End.", data)
              , "Begin.
End."
              )
})

test_that("Indented Inline", {
  data <- list()
  expect_equal( whisker("  12 {{! 34 }}\n", data)
              , "  12 \n"
              )
})

test_that("Surrounding Whitespace", {
  data <- list()
  expect_equal( whisker('12345 {{! Comment Block! }} 67890', data)
              , '12345  67890'
              )
})
