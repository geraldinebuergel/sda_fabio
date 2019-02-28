library(tidyverse)
library(wbstats)

rm(list = ls()); gc()

#------------------------------------------------
#
# SORT WORLD BANK POPULATION DATA
#
#------------------------------------------------

# identify unequal regions
iso_fabio <- as.character(c("ARM","AFG","ALB","DZA","AGO","ATG","ARG","AUS",
                            "AUT","BHS","BHR","BRB","BLX","BGD","BOL","BWA",
                            "BRA","BLZ","SLB","BRN","BGR","MMR","BDI","CMR",
                            "CAN","CPV","CAF","LKA","TCD","CHL","CHN","COL",
                            "COG","CRI","CUB","CYP","CSK","AZE","BEN","DNK",
                            "DMA","DOM","BLR","ECU","EGY","SLV","EST","FJI",
                            "FIN","FRA","PYF","DJI","GEO","GAB","GMB","DEU",
                            "BIH","GHA","KIR","GRC","GRD","GTM","GIN","GUY",
                            "HTI","HND","HKG","HUN","HRV","ISL","IND","IDN",
                            "IRN","IRQ","IRL","ISR","ITA","CIV","KAZ","JAM",
                            "JPN","JOR","KGZ","KEN","KHM","PRK","KOR","KWT",
                            "LVA","LAO","LBN","LSO","LBR","LBY","LTU","MAC",
                            "MDG","MWI","MYS","MDV","MLI","MLT","MRT","MUS",
                            "MEX","MNG","MAR","MOZ","MDA","NAM","NPL","NLD",
                            "ANT","NCL","MKD","VUT","NZL","NIC","NER","NGA",
                            "NOR","PAK","PAN","CZE","PNG","PRY","PER","PHL",
                            "POL","PRT","GNB","TLS","PRI","ERI","QAT","ZWE",
                            "ROU","RWA","RUS","SCG","KNA","LCA","VCT","STP",
                            "SAU","SEN","SLE","SVN","SVK","SGP","SOM","ZAF",
                            "ESP","SUR","TJK","SWZ","SWE","CHE","SYR","TKM",
                            "TWN","TZA","THA","TGO","TTO","OMN","TUN","TUR",
                            "ARE","UGA","SUN","GBR","UKR","USA","BFA","URY",
                            "UZB","VEN","VNM","ETH","WSM","YUG","YEM","COD",
                            "ZMB","BEL","LUX","SRB","MNE","SDN","SSD","ROW"))

wb_pop_all <- wb(indicator = "SP.POP.TOTL", startdate = 1986, enddate = 2013)

com_pop_regions <- intersect(iso_fabio, wb_pop_all$iso3c)
setdiff(iso_fabio, wb_pop_all$iso3c)

# load arranged population data, RoW region is missing
pop_raw <- read.csv("C:/Users/Zoe/Desktop/Population_final.csv")

pop1 <- dplyr::select(pop_raw, 1:4)

# rearrange as list
split_tibble <- function(tibble, col = 'col') tibble %>% split(., .[,col])

pop2 <- split_tibble(pop1, 'Jahr')

pop <- map(pop2, dplyr::select, "Value")

# save as .RData file
save(pop, file = "Population.RData")
