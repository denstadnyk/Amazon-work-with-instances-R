## Restarts instance on amazon AWS (us-west).
## TIME: ***4 minutes***
# REQUIREMENTS: Start docker
# docker run -d -p 4445:4444 -p 5901:5900 c1c0835a1d2c
# docker stop c1c0835a1d2c
## Code: 
# 1. Open docker image with Selenium (chrome)
# 2. Login into Amazon AWS
# 3. Stops the instance
# 4. Waits and starts the instance

library(RSelenium)
library(dplyr)
library(XML)

# Login and password to AWS panel
login <- "email@gmail.com"
password <- "password"

system("docker run -d -p 4445:4444 -p 5901:5900 c1c0835a1d2c")
amazonAwsUrl <- "https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2"

remDr <- remoteDriver(port = 4445, browserName = "chrome")
remDr$open()
remDr$navigate(amazonAwsUrl)

# Insert login
webElemLogin <-  remDr$findElement(using = "xpath", ".//*[@id='ap_email']")
webElemLogin$clickElement()
webElemLogin$sendKeysToElement(list(login))

# Insert password
webElemPasswd <-  remDr$findElement(using = "xpath", ".//*[@id='ap_password']")
webElemPasswd$clickElement()
webElemPasswd$sendKeysToElement(list(password))

# Click "Login!"
webElemLog_in <-  remDr$findElement(using = "xpath", ".//*[@id='signInSubmit-input']")
webElemLog_in$clickElement()
Sys.sleep(time = 20)



# Click Menu - STOP instance
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-menuButton']")
webElem$clickElement()
Sys.sleep(time = 2)
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-menu-instance-state']")
webElem$clickElement()
Sys.sleep(time = 2)
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-action-stop-instances']")
webElem$clickElement()
Sys.sleep(time = 2)
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-dialogBoxSubmitButton-button']")
webElem$clickElement()
Sys.sleep(time = 90)

# Click Menu - START instance
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-menuButton']")
webElem$clickElement()
Sys.sleep(time = 3)
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-menu-instance-state']")
webElem$clickElement()
Sys.sleep(time = 4)
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-action-start-instances']")
webElem$clickElement()
Sys.sleep(time = 4)
webElem <-  remDr$findElement(using = "xpath", ".//*[@id='gwt-debug-dialogBoxSubmitButton-button']")
webElem$clickElement()
Sys.sleep(time = 80)


## Get IP!
ip <- remDr$getPageSource()[[1]] %>%
  htmlTreeParse(useInternalNodes = TRUE) %>%
  xpathSApply("//*[@id='gwt-debug-detailsPublicIp']/div/div[2]", xmlValue)
if (length(ip) < 1) {
  Sys.sleep(time = 90)
  ip <- remDr$getPageSource()[[1]] %>%
    htmlTreeParse(useInternalNodes = TRUE) %>%
    xpathSApply("//*[@id='gwt-debug-detailsPublicIp']/div/div[2]", xmlValue)
}
host <- paste0("http://",ip,"/auth-sign-in")
remDr$close()
rm(ip, remDr, webElem, webElemLog_in, webElemLogin, webElemPasswd, amazonAwsUrl)
system("docker stop c1c0835a1d2c")
