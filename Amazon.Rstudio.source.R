## Source script to scrape Google TOP
## TIME: 3.5-4 minutes

library(RSelenium)

system("docker run -d -p 4445:4444 -p 5901:5900 593e47f379db")


## Connect
remDrA <- remoteDriver(port = 4445, browserName = "chrome")
remDrA$open()
remDrA$navigate(host)

# Insert login
webElemLogin <-  remDrA$findElement(using = "xpath", ".//*[@id='username']")
webElemLogin$clickElement()
webElemLogin$sendKeysToElement(list('rstudio'))

# Insert password
webElemPasswd <-  remDrA$findElement(using = "xpath", ".//*[@id='password']")
webElemPasswd$clickElement()
webElemPasswd$sendKeysToElement(list('rstudio'))

# Click "Login!"
webElemLog_in <-  remDrA$findElement(using = "xpath", ".//*[@id='buttonpanel']/button")
webElemLog_in$clickElement()
Sys.sleep(time = 80)

# R Session Error
#webElemLog_in <-  remDrA$findElement(using = "xpath", "html/body/div[5]/div/table/tbody/tr[2]/td[2]/div/table/tbody/tr[2]/td/table/tbody/tr/td[2]/table/tbody/tr/td/button")
#webElemLog_in$clickElement()
#Sys.sleep(time = 3)


# Click SOURCE
webElem <-  remDrA$findElement(using = "xpath", "html/body/div[2]/div[2]/div/div[3]/div/div[4]/div/div/div[2]/div/div[5]/div/div[2]/div/div[2]/div/div[3]/div/div[2]/div/div[2]/table/tbody/tr/td[2]/table/tbody/tr/td[8]/button")
webElem$clickElement()
Sys.sleep(time = 160)


remDrA$close()

# Garbage collector
rm(host, remDrA, webElem, webElemLog_in, webElemLogin, webElemPasswd)
system("docker stop 593e47f379db")
