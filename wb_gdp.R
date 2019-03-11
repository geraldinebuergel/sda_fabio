library(tidyverse)
library(wbstats)
library(xlsx)
library(readxl)

rm(list = ls()); gc()

#---------------------------------------------------
#
# GDP DATA
#
#---------------------------------------------------

#---------------------------------------------------
# assemble data
#---------------------------------------------------

# world bank constant USD (base year = 2010)
gdp_constant <- wb(indicator = "NY.GDP.MKTP.KD", startdate = 1986, enddate = 2013)
write.xlsx(gdp_constant, "wb_constant.xlsx")

# world bank current USD
gdp_current <- wb(indicator = "NY.GDP.MKTP.CD", startdate = 1986, enddate = 2013)
write.xlsx(gdp_current, "wb_current.xlsx")

# eora current USD
eora1 <- read_xlsx("C:/Users/Zoe/Dropbox/Master Arbeit/excel/Value added in production_Eora26_1970-2013 in current million USD.xlsx")

# sum up value added for all sectors per country
eora2 <- slice(eora1, 1:4914) %>% 
  split.data.frame(rep(1:189, each = 26)) %>% 
  map(dplyr::select, 21:48) %>% 
  map(colSums)
eora3 <- do.call(rbind, eora2)

# add country codes
code1 <- eora1$country.code
code2 <- code1[seq(1, length(code1), 26)]
eora <- cbind(code2[1:189], eora3)

write.xlsx(eora, "eora_current.xlsx")

#---------------------------------------------------
# deflate current data
#---------------------------------------------------

# world bank USA GDP deflator (base year = 2010)
def_usa <- wb(country = "US", indicator = "NY.GDP.DEFL.ZS", startdate = 1986, enddate = 2013)
write.xlsx(def_usa, "wb_def.xlsx")

#---------------------------------------------------
# rearrange constant data
#---------------------------------------------------

split_tibble <- function(tibble, col = 'col') tibble %>% split(., .[,col])

gdp1 <- read_xlsx("C:/Users/Zoe/Dropbox/Master Arbeit/excel/fabio_GDP_constant.xlsx")
gdp <- gdp1[, 2:5] %>% 
  split_tibble("Year") %>% 
  map(~.x[["Value"]])

save(gdp, file = "GDP.RData")
