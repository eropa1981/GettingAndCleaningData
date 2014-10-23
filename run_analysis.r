library(markdown)
library(knitr)
setwd("c:/Users/Eropa1981/Dropbox/didacticos/Estudio/Johns Hopkins University/03-Getting and Cleaning Data/Assingment")
knit("run_analysis.Rmd", encoding="ISO8859-1")
markdownToHTML("run_analysis.md", "run_analysis.html")

