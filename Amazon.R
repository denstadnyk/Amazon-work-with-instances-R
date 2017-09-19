source("./Amazon.Rstudio.source.R", verbose = TRUE)
k <- 1
for (k in 1:8) {
  source("./Amazon AWS.restart_instance.R", verbose = TRUE)
  print("restart ok")
  source("./Amazon.Rstudio.source.R", verbose = TRUE)
  print("scrape ok")
}
