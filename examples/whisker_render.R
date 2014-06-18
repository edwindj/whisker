template <- "Hello {{place}}!"
place <- "World"

whisker.render(template)

# to prevent html escaping use triple {{{}}}
template <- 
  "I'm escaped: {{name}}
And I'm not: {{{name}}}"

data <- list( name = '<My Name="Nescio&">')
whisker.render(template, data)
# I'm escaped: &lt;My Name=&quot;Nescio&amp;&quot;&gt;
# And I'm not: <My Name="Nescio&">
