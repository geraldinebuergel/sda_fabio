library(wbstats)

#rm(list = ls()); gc()

#population data from 260 world bank regions
wb_pop_data <- wb(indicator = "SP.POP.TOTL", startdate = 1986, enddate = 1986)

#192 fabio regions
fabio_regions <- as.character(c("ARM","AFG","ALB","DZA","AGO","ATG","ARG","AUS","AUT","BHS","BHR","BRB","BLX","BGD","BOL","BWA","BRA","BLZ","SLB","BRN","BGR","MMR","BDI","CMR","CAN","CPV","CAF","LKA","TCD","CHL","CHN","COL","COG","CRI","CUB","CYP","CSK","AZE","BEN","DNK","DMA","DOM","BLR","ECU","EGY","SLV","EST","FJI","FIN","FRA","PYF","DJI","GEO","GAB","GMB","DEU","BIH","GHA","KIR","GRC","GRD","GTM","GIN","GUY","HTI","HND","HKG","HUN","HRV","ISL","IND","IDN","IRN","IRQ","IRL","ISR","ITA","CIV","KAZ","JAM","JPN","JOR","KGZ","KEN","KHM","PRK","KOR","KWT","LVA","LAO","LBN","LSO","LBR","LBY","LTU","MAC","MDG","MWI","MYS","MDV","MLI","MLT","MRT","MUS","MEX","MNG","MAR","MOZ","MDA","NAM","NPL","NLD","ANT","NCL","MKD","VUT","NZL","NIC","NER","NGA","NOR","PAK","PAN","CZE","PNG","PRY","PER","PHL","POL","PRT","GNB","TLS","PRI","ERI","QAT","ZWE","ROU","RWA","RUS","SCG","KNA","LCA","VCT","STP","SAU","SEN","SLE","SVN","SVK","SGP","SOM","ZAF","ESP","SUR","TJK","SWZ","SWE","CHE","SYR","TKM","TWN","TZA","THA","TGO","TTO","OMN","TUN","TUR","ARE","UGA","SUN","GBR","UKR","USA","BFA","URY","UZB","VEN","VNM","ETH","WSM","YUG","YEM","COD","ZMB",
                                "BEL","LUX","SRB","MNE","SDN","SSD","ROW"))

#find 183 common regions
com_pop_regions <- intersect(fabio_regions, wb_pop_data$iso3c)
setdiff(fabio_regions, wb_pop_data$iso3c)

#9 fabio regions do not match with world bank regions
#fabio = WB equivalent
#BLX = BEL+LUX
#SCG = serbia+MNE
#TWN = CHN+taiwan
#SUN(until 1991) = RUS+EST+LTU+LVA+ARM+AZE+BLR+GEO+KAZ+KGZ+MDA+TKM+UKR+UZB

#get GDP data from world bank for 197 regions
wb_gdp_data <- wb(indicator = "NY.GDP.MKTP.CD", startdate = 1986, enddate = 1986)

#only 143 common regions with fabio -> 49 regions do not match
com_gdp_regions <- intersect(fabio_regions, wb_gdp_data$iso3c)
setdiff(fabio_regions, wb_gdp_data$iso3c)

#implement per capita function
source("per_capita.R")

#get GDP per capita
per_capita(wb_gdp_data)
