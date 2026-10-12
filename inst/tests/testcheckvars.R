library(testthat)
context("Missing variable checks")

capture_warnings <- function(expr){
  warnings <- character()
  value <- withCallingHandlers(expr, warning=function(condition){
    warnings <<- c(warnings, conditionMessage(condition))
    invokeRestart("muffleWarning")
  })
  list(value=value, warnings=warnings)
}

test_that("missing variables in list items are reported", {
  template <- "{{#repo}}<b>{{person}}</b>{{/repo}}"
  data <- list(repo=list(list(pesron="bob"), list(person="dan"), list(person="mary")))

  result <- capture_warnings(whisker.render(template, data, checkvars=TRUE))

  expect_equal(result$value, "<b></b><b>dan</b><b>mary</b>")
  expect_equal(result$warnings, "Missing 'person'")
})

test_that("the original issue example reports top-level and list-item misses", {
  template <- "Hello {{name}}\nYou won {{value}} dollars!\n{{#in_ca}}Taxed: {{taxed_value}}\n{{/in_ca}}{{#repo}}<b>{{person}}</b>{{/repo}}"
  data <- list(name="Chris", taxed_value=6000, repo=list(list(pesron="bob"), list(person="dan"), list(person="mary")))

  result <- capture_warnings(whisker.render(template, data, checkvars=TRUE))

  expect_equal(result$warnings, c("Missing 'value'", "Missing 'in_ca'", "Missing 'person'"))
  expect_match(result$value, "<b></b><b>dan</b><b>mary</b>")
})

test_that("parent-context fallbacks are not reported as missing", {
  template <- "{{#items}}{{name}}{{/items}}"
  data <- list(name="parent", items=list(list(), list()))

  result <- capture_warnings(whisker.render(template, data, checkvars=TRUE))

  expect_equal(result$value, "parentparent")
  expect_length(result$warnings, 0)
})

test_that("defined NULL values are not reported as missing", {
  result <- capture_warnings(whisker.render("{{value}}", list(value=NULL), checkvars=TRUE))

  expect_equal(result$value, "")
  expect_length(result$warnings, 0)
})

test_that("checks follow nested list iteration", {
  template <- "{{#groups}}{{#people}}{{name}}{{/people}}{{/groups}}"
  data <- list(groups=list(list(people=list(list(name="Ada"), list(nmae="Grace")))))

  result <- capture_warnings(whisker.render(template, data, checkvars=TRUE))

  expect_equal(result$value, "Ada")
  expect_equal(result$warnings, "Missing 'name'")
})

test_that("missing section and inverted-section names are reported", {
  result <- capture_warnings(whisker.render("{{#missing}}x{{/missing}}{{^also_missing}}y{{/also_missing}}", list(), checkvars=TRUE))

  expect_equal(result$value, "y")
  expect_equal(result$warnings, c("Missing 'missing'", "Missing 'also_missing'"))
})

test_that("defined falsey values and partial names are not reported", {
  result <- capture_warnings(whisker.render("{{#empty}}x{{/empty}}{{>card}}", list(empty=FALSE), partials=list(card="{{present}}"), checkvars=TRUE))

  expect_equal(result$value, "")
  expect_equal(result$warnings, "Missing 'present'")
})

test_that("checks are disabled by default", {
  expect_silent(whisker.render("{{missing}}", list()))
})