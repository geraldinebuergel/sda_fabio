library(wbstats)

#rm(list = ls()); gc()

# 192 fabio regions
fabio_regions <- as.character(c("ARM","AFG","ALB","DZA","AGO","ATG","ARG","AUS",
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
fabio_regions <- fabio_regions[1:10]

# population data from world bank
wb_pop <- wb(indicator = "SP.POP.TOTL", startdate = 2013, enddate = 2013) %>% 
  subset(subset = iso3c %in% fabio_regions) %>% 
  dplyr::select(value) %>% 
  as.matrix()

# GDP data from world bank
wb_gdp <- wb(indicator = "NY.GDP.MKTP.CD", startdate = 2013, enddate = 2013) %>% 
  subset(subset = iso3c %in% fabio_regions) %>% 
  dplyr::select(value) %>% 
  as.matrix()

# GDP per capita
gdp_per_capita <- wb_gdp / wb_pop

# implement per capita function
source("per_capita.R")

gdp_per_capita_f <- per_capita(fabio_regions, wb_gdp, year = 2013) %>% 
  dplyr::select(value) %>% 
  as.matrix()

