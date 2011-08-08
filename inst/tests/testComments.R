# Automatically generated from specification file: 'comments.json'
#
# Comment tags represent content that should never appear in the resulting
# output.
# 
# The tag's content may contain any substring (including newlines) EXCEPT the
# closing delimiter.
# 
# Comment tags SHOULD be treated as standalone when appropriate.
# 
library(testthat)
context('comments')

test_that( "Inline", {
  #"Comment blocks should be removed from the template."
  template <- "12345{{! Comment Block! }}67890"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("1234567890", str, info="Comment blocks should be removed from the template.")
})

test_that( "Multiline", {
  #"Multiline comments should be permitted."
  template <- "12345{{!\n  This is a\n  multi-line comment...\n}}67890\n"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("1234567890\n", str, info="Multiline comments should be permitted.")
})

test_that( "Standalone", {
  #"All standalone comment lines should be removed."
  template <- "Begin.\n{{! Comment Block! }}\nEnd.\n"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("Begin.\nEnd.\n", str, info="All standalone comment lines should be removed.")
})

test_that( "Indented Standalone", {
  #"All standalone comment lines should be removed."
  template <- "Begin.\n  {{! Indented Comment Block! }}\nEnd.\n"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("Begin.\nEnd.\n", str, info="All standalone comment lines should be removed.")
})

test_that( "Standalone Line Endings", {
  #"\"\\r\\n\" should be considered a newline for standalone tags."
  template <- "|\r\n{{! Standalone Comment }}\r\n|"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("|\r\n|", str, info="\"\\r\\n\" should be considered a newline for standalone tags.")
})

test_that( "Standalone Without Previous Line", {
  #"Standalone tags should not require a newline to precede them."
  template <- "  {{! I'm Still Standalone }}\n!"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("!", str, info="Standalone tags should not require a newline to precede them.")
})

test_that( "Standalone Without Newline", {
  #"Standalone tags should not require a newline to follow them."
  template <- "!\n  {{! I'm Still Standalone }}"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("!\n", str, info="Standalone tags should not require a newline to follow them.")
})

test_that( "Multiline Standalone", {
  #"All standalone comment lines should be removed."
  template <- "Begin.\n{{!\nSomething's going on here...\n}}\nEnd.\n"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("Begin.\nEnd.\n", str, info="All standalone comment lines should be removed.")
})

test_that( "Indented Multiline Standalone", {
  #"All standalone comment lines should be removed."
  template <- "Begin.\n  {{!\n    Something's going on here...\n  }}\nEnd.\n"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("Begin.\nEnd.\n", str, info="All standalone comment lines should be removed.")
})

test_that( "Indented Inline", {
  #"Inline comments should not strip whitespace"
  template <- "  12 {{! 34 }}\n"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("  12 \n", str, info="Inline comments should not strip whitespace")
})

test_that( "Surrounding Whitespace", {
  #"Comment removal should preserve surrounding whitespace."
  template <- "12345 {{! Comment Block! }} 67890"
  data <- list()
  str <- whisker.render(template, data=data)
  
  expect_equal("12345  67890", str, info="Comment removal should preserve surrounding whitespace.")
})

