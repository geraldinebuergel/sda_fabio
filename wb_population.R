library(tidyverse)
library(wbstats)
library(xlsx)
library(readxl)

rm(list = ls()); gc()

#------------------------------------------------
#
# SORT WORLD BANK POPULATION DATA
#
#------------------------------------------------

# world bank population data
wb_pop <- wb(indicator = "SP.POP.TOTL", startdate = 1986, enddate = 2013)

write.xlsx(wb_pop, "C:/Users/Zoe/Desktop/wb_pop.xlsx")

# load rearranged population data (including some UN data)
pop1 <- read_xlsx("C:/Users/Zoe/Desktop/fabio_Population.xlsx") %>% 
  dplyr::select(2:5)

split_tibble <- function(tibble, col = 'col') tibble %>% split(., .[,col])

pop <- split_tibble(pop1, 'Jahr') %>% 
  map(dplyr::select, "Value") %>% 
  lapply(as.matrix)

# save as .RData file
save(pop, file = "Population.RData")
