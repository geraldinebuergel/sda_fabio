library(tidyverse)
library(readxl)
library(xlsx)

rm(list = ls()); gc()

#---------------------------------------------
#
# GDP DATA
#
#---------------------------------------------

# load raw eora data file
eora_raw <- read_xlsx("C:/Users/Zoe/Desktop/Value added in production_Eora26_1970-2013 in current million USD.xlsx")

# sum up value added for all sectors per country
eora_raw2 <- slice(eora_raw, 1:4914)
eora_list <- split.data.frame(eora_raw2, rep(1:189, each = 26))
eora_sum <- map(eora_list, dplyr::select, 21:48)
eora_sum <- map(eora_sum, colSums)
eora <- do.call(rbind, eora_sum)

# add country codes
codes_all <- eora_raw2$country.code
country.code <- codes_all[seq(1, length(codes_all), 26)]
eora_codes <- cbind(country.code, eora)

# add RoW reagion back
RoW <- eora_raw[4915,]
RoW <- dplyr::select(RoW, c(2, 21:48))
eora_final <- rbind(eora_codes, RoW, stringsAsFactors = FALSE)

# safe as excel file
write.xlsx(eora_final, "C:/Users/Zoe/Desktop/eora_GDP.xlsx")

#--------------------------------------------------------
#
# DEFLATE GDP DATA  
#
#--------------------------------------------------------

# load arranged GDP file and bea deflators
eora_GDP <- read_csv("C:/Users/Zoe/Desktop/GDP.csv")
deflator <- read_xls("C:/Users/Zoe/Desktop/bea_deflators.xls") # 2012 = 100

# deflate GDP with GDP deflators
eora1 <- select(eora_GDP, 1:4)

split_tibble <- function(tibble, col = 'col') tibble %>% split(., .[,col])

eora2 <- split_tibble(eora1, 'Jahr')

eora3 <- map(eora2, dplyr::select, "Value")

deflator1 <- c(deflator[7, 3:30])
deflator2 <- as.numeric(deflator1)

gdp <- list()
for(i in seq_along(1:28)){
  gdp[[i]] <- eora3[[i]] / deflator2[i]
}

# save as .RData file
save(gdp, file = "GDP_deflated.RData")
