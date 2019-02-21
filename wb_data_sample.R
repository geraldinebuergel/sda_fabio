library(tidyverse)
library(wbstats)

rm(list = ls()); gc()

# 192 fabio regions
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
# subset sample of first 10 countries
# iso_fabio <- iso_fabio[1:10]

# get information on world bank database
str(wb_cachelist, max.level = 1)

# check for common countries between fabio and world bank
iso_wb <- wb_cachelist[["countries"]][["iso3c"]]
iso_match <- intersect(iso_fabio, iso_wb)
setdiff(iso_fabio, iso_match)

# retrieves population data for all relevant years
wb_pop_all <- wb(indicator = "SP.POP.TOTL", startdate = 1986, enddate = 2013)
  
# retrieves population data for 1986 and selects matching countries
wb_pop_1986 <- wb(indicator = "SP.POP.TOTL", startdate = 1986, enddate = 1986) %>% 
  subset(subset = iso3c %in% iso_fabio) %>% 
  dplyr::select(value, iso3c)

setdiff(iso_fabio, wb_pop_1986$iso3c)

# retrieves population data for 2013 and selects matching countries
wb_pop_2013 <- wb(indicator = "SP.POP.TOTL", startdate = 2013, enddate = 2013) %>% 
  subset(subset = iso3c %in% iso_fabio) %>% 
  dplyr::select(value) %>% 
  as.matrix()

# GDP data from world bank
wb_gdp_2013 <- wb(indicator = "NY.GDP.MKTP.CD", startdate = 2013, enddate = 2013) %>% 
  subset(subset = iso3c %in% iso_fabio) %>% 
  dplyr::select(value) %>% 
  as.matrix()

# GDP per capita (geht nicht weil vektoren unterschiedlich lang sind)
gdp_per_capita <- wb_gdp_2013 / wb_pop_2013

# implement per capita function
source("per_capita.R")

# geht auch nicht, weil vektoren unterschiedlich lang sind
gdp_per_capita_f <- per_capita(iso_fabio, wb_gdp_2013, year = 2013) %>% 
  dplyr::select(value) %>% 
  as.matrix()

