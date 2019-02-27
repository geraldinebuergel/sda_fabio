library(tidyverse)

#rm(list = ls()); gc()

#------------------------------------------------
#
# SORT WORLD BANK POPULATION DATA IN LIST
#
#------------------------------------------------

pop_raw <- read.csv("C:/Users/Zoe/Desktop/Population.csv")

pop1 <- dplyr::select(pop_raw, 1:4)

split_tibble <- function(tibble, col = 'col') tibble %>% split(., .[,col])

pop <- split_tibble(pop1, 'Jahr')

pop_values <- map(pop, dplyr::select, "Value")
