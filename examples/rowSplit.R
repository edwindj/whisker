dat <- head(InsectSprays)
dat <- unname(rowSplit(dat))

template <- 
"{{#dat}}
count: {{count}}, spray: {{spray}}\n
{{/dat}}"

whisker.render(template)
