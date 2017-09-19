## Gets Google SERP
## TIME: ***5 minutes***
# REQUIREMENTS: Start docker
# docker run -d -p 4445:4444 -p 5901:5900 c1c0835a1d2c
# docker stop c1c0835a1d2c
## Code: 
# 1. Open docker image with Selenium (chrome)
# 2. Scrape Google
# 3. Saves all data to file with the name of keyword, used keywords to "used_kw.txt".
# 4. Stops the instance

system("docker run -d -p 4444:4444 -v /dev/shm:/dev/shm 1dec27211cb6")
Sys.sleep(time = 5)

library(RSelenium)
library(dplyr)
library(XML)
library(data.table)

# Get work keywords
keywords <- readLines("keywords.txt")
all_kw <- data.table(keywords)
used_keywords <- readLines("used_kw.txt")
work_keywords <- unlist(all_kw[!all_kw[, keywords %in% used_keywords]]) %>% as.character()
rm(keywords, all_kw, used_keywords)

# Open Selenium chrome
prefs = list("profile.managed_default_content_settings.images" = 2L)
cprof <- list(chromeOptions = list(prefs = prefs))

remDr <- remoteDriver(port = 4444, browserName = "chrome",
                      extraCapabilities = cprof)
remDr$open()
rm(prefs, cprof)

i <- 1
for (i in i:length(work_keywords)) {
  remDr$navigate(paste0("https://google.com/search?num=100&q=",work_keywords[i],"&hl=en"))
  
  top100 <-remDr$getPageSource()[[1]] %>%
    htmlTreeParse(useInternalNodes = TRUE) %>%
    xpathSApply("//div/div/div/h3/a", xmlGetAttr, "href")
  
  if (length(top100) < 2) {
    remDr$close()
    break;}
  
  # write all stuff
  data.frame(Keyword = work_keywords[i],
             URL = top100, Position = c(1:length(top100))) %>%
    write.csv(file = paste0("/home/ubuntu/files/",work_keywords[i],".csv"))
  cat(work_keywords[i], file="used_kw.txt", append=TRUE, sep = "\n")
}
length(readLines("used_kw.txt"))

Sys.sleep(time = 5)

i <- i + 1
remDr$open()
for (i in i:length(work_keywords)) {
  remDr$navigate(paste0("https://google.com/search?num=100&q=",work_keywords[i],"&hl=en"))
  
  top100 <-remDr$getPageSource()[[1]] %>%
    htmlTreeParse(useInternalNodes = TRUE) %>%
    xpathSApply("//div/div/div/h3/a", xmlGetAttr, "href")
  
  if (length(top100) < 2) {
    remDr$close()
    break;}
  
  # write all stuff
  data.frame(Keyword = work_keywords[i],
             URL = top100, Position = c(1:length(top100))) %>%
    write.csv(file = paste0("/home/ubuntu/files/",work_keywords[i],".csv"))
  cat(work_keywords[i], file="used_kw.txt", append=TRUE, sep = "\n")
}
length(readLines("used_kw.txt"))
system("docker stop $(docker ps -q)")
