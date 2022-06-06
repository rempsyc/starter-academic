#' ---
#' title: '**Your most beautiful title ever**'
#' subtitle: Second most beautiful subtitle ever
#' author: "Yours truly, Rémi Thériault"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: cerulean
#'     highlight: pygments
#'     toc: yes
#'     toc_depth: 3
#'     toc_float: yes
#'     number_sections: no
#'     df_print: kable
#'     code_folding: show # or: hide
#'     code_download: yes
#'     anchor_sections:
#'       style: symbol
#' ---

#+ echo=FALSE
klippy::klippy(position = c('top', 'right'))
# The two lines above add a "copy code" button on top right of code chunks!
# Because the chunk option echo is set to FALSE with #+, these comments won't show up! Cool huh?

#' # First header level 1
#' Here we will cover the head of mtcars. But first, let's do some hard maths.
2+2
#' # Nice Title
#' ## Nice subtitle
#' Just in a bit.
print("hello world")
#' # A third header
#' What a cool menu on the top left, am I right??!
#'
#' ## Salutations
#' ...matinales? Non. Plutôt :
#'
#' ### Les plus cordiales {.tabset}
#'
#' #### Data
#' There we go
head(mtcars)
#'
#' #### Scatter plot
plot(mtcars$mpg)
#'
#' #### t-test
t.test(mtcars$mpg)
#'
#' #### Correlation
cor.test(mtcars$mpg, mtcars$hp)
#'
#' #### Histogram
hist(mtcars$mpg)
#' #### ???
#' **Bon Appétit!!!**
#' ![surprise](https://remi-theriault.com/images/surprise.jpg){width=70%}
#'

#' ### Conclusion
#' Having a new higher-level header ends the tabset mode.
#'
#' The script for this template can be dowloaded here: https://remi-theriault.com/scripts/report_template.R
