# Version: 6 -- 'black cat'
# Author: Mingdong Zhou
# Encoding: utf-8
# The goal is to finish the task that
# update the price per carrier per line to catapalt system.
# It need two input,
# both there path name must be fixed, one is carrier.csv
# another is rate.csv.
# The carrier.csv format must be one data element one line
# and the rate.csv must be do not have variable name.
library(readr)
library(writexl)
source('.\\bin\\GetCode.R')
source('.\\bin\\GetId.R')
source('.\\bin\\Select.R')
name <- scan(".\\data\\carrier.csv", what = "charatar")
name <- name[which(!duplicated(name))]
name <- toupper(name)
codeName <- GetCode(name)
contractId <- GetId(codeName) 
rate <- read_csv(".\\data\\rate.csv", col_names = FALSE)
names(rate)[c(7, 8, 10)] <- c("Carrier", "ETD", "X20GP")
rate$Carrier <- as.character(rate$Carrier)
rate <- Select(rate, id = "Carrier", set = codeName)
rate$ETD <- as.character(rate$ETD) 
rate$ETD <- as.Date(rate$ETD, "%m/%d/%Y") 
rate$ETD[rate$ETD < Sys.Date()] <- Sys.Date()
rate$ETD <- as.character(rate$ETD, "%m/%d/%Y")
len <- 10:13
rate[, len] <- round(rate[, len])
rm(len)
ContractId <- c()
for(i in seq(dim(rate)[1])) {
  for(r in seq(codeName)) {
    if((rate$Carrier[i]) == codeName[r]) {
       ContractId[i] <- contractId[r]
    }
  }
}
rm(i, r)
rate$ContractId <- ContractId
rate$idetification <-
  rep(paste("SPRC", format(Sys.Date(), "%y%m%d"), sep = ""),
    dim(rate)[1])
rate <- rate[c(18, 1:4, 7:9, 15:17, 10:13)]
rate <- rate[!duplicated(rate), ]
rate <- rate[which(!is.na(rate$X20GP)), ]
write_csv(rate, "update.csv", col_names = FALSE, na = "")
keyWord <- paste(codeName, contractId, sep = "_")
write.csv(keyWord, "keyword.csv")
cat("Done! Outing in file keyword.csv and update.csv\n",
  date())
rm(list = ls())
