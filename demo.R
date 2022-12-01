## Install dependencies if needed
#install.packages("paws")

readRenviron("~/Documents/Credentials/.Renviron")

library(paws)
ec2 <- paws::ec2()
