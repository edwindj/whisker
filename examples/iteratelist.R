# create an iteration list from a named vector
x <- c(a=1, b=2)
iteratelist(x)

# iterate over the members of a list
x <- list(name="John", age="30", gender="male")
iteralist(x, name="variable") 

# iterate over an unnamed vector
values <- c(1,2,3,4)

template <- 
'{{#values}}
* Value: {{.}}
{{/values}}'

whisker.render(template)

#or 

values <- iteratelist(values, value="count")

template <- 
'{{#values}}
* Value: {{count}}
{{/values}}'

whisker.render(template)
