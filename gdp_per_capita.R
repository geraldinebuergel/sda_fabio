library(tidyverse)

rm(list = ls()); gc()

load("GDP.RData")
load("Population.RData")

gdp_per_capita <- list()
for(i in seq_along(1:28)){
  gdp_per_capita[[i]] <- gdp[[i]] / pop[[i]]
}

save(gdp_per_capita, file = "GDP_per_capita.RData")
