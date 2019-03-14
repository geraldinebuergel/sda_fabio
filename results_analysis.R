library(tidyverse)

rm(list = ls()); gc()

#---------------------------------------------------
#
# ANALYSE RESULTS
#
#---------------------------------------------------

load("results_tbl.RData")

TWN <- results_tbl %>% 
  filter(country == "TWN") %>% 
  select(delta_F, year)

ggplot(USA, aes(x = year, y = delta_F)) +
  geom_bar(stat = "identity")
