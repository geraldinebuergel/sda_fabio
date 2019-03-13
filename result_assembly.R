library(tidyverse)

rm(list = ls()); gc()

# assemble results in list
loop_list <- list.files(pattern = "loop") %>% 
  map(~ mget(load(paste0(.x))))

results <- list()
for(i in 1:14){
  results[[i]] <- list(loop_list[[i]][[1]][[2]], loop_list[[i]][[1]][[3]])
}
results[[14]] <- loop_list[[14]]

results2 <- lapply(results, unlist, recursive = FALSE) %>% 
  unlist(recursive = FALSE) %>% 
  split(rep(1:27, each = 10))

names(results) <- c(1987:2013)
names(results2[[27]]) <- c("delta_F", "con_U", "con_lpro", "con_lsup", "con_llev",
                     "con_ypro", "con_ysup", "con_ylev", "con_G", "con_P")

# split list into individual variables
result_F <- list()
result_U <- list()
result_lpro <- list()
result_lsup <- list()
result_llev <- list()
result_ypro <- list()
result_ysup <- list()
result_ylev <- list()
result_G <- list()
result_P <- list()

for (i in 1:length(results)){
  result_F[[i]] <- results[[i]][["delta_F"]]
  result_U[[i]] <- results[[i]][["con_U"]]
  result_lpro[[i]] <- results[[i]][["con_lpro"]]
  result_lsup[[i]] <- results[[i]][["con_lsup"]]
  result_llev[[i]] <- results[[i]][["con_llev"]]
  result_ypro[[i]] <- results[[i]][["con_ypro"]]
  result_ysup[[i]] <- results[[i]][["con_ysup"]]
  result_ylev[[i]] <- results[[i]][["con_ylev"]]
  result_G[[i]] <- results[[i]][["con_G"]]
  result_P[[i]] <- results[[i]][["con_P"]]
}

country_codes <- c("ARM","AFG","ALB","DZA","AGO","ATG","ARG","AUS","AUT","BHS",
                   "BHR","BRB","BLX","BGD","BOL","BWA","BRA","BLZ","SLB","BRN",
                   "BGR","MMR","BDI","CMR","CAN","CPV","CAF","LKA","TCD","CHL",
                   "CHN","COL","COG","CRI","CUB","CYP","CSK","AZE","BEN","DNK",
                   "DMA","DOM","BLR","ECU","EGY","SLV","EST","FJI","FIN","FRA",
                   "PYF","DJI","GEO","GAB","GMB","DEU","BIH","GHA","KIR","GRC",
                   "GRD","GTM","GIN","GUY","HTI","HND","HKG","HUN","HRV","ISL",
                   "IND","IDN","IRN","IRQ","IRL","ISR","ITA","CIV","KAZ","JAM",
                   "JPN","JOR","KGZ","KEN","KHM","PRK","KOR","KWT","LVA","LAO",
                   "LBN","LSO","LBR","LBY","LTU","MAC","MDG","MWI","MYS","MDV",
                   "MLI","MLT","MRT","MUS","MEX","MNG","MAR","MOZ","MDA","NAM",
                   "NPL","NLD","ANT","NCL","MKD","VUT","NZL","NIC","NER","NGA",
                   "NOR","PAK","PAN","CZE","PNG","PRY","PER","PHL","POL","PRT",
                   "GNB","TLS","PRI","ERI","QAT","ZWE","ROU","RWA","RUS","SCG",
                   "KNA","LCA","VCT","STP","SAU","SEN","SLE","SVN","SVK","SGP",
                   "SOM","ZAF","ESP","SUR","TJK","SWZ","SWE","CHE","SYR","TKM",
                   "TWN","TZA","THA","TGO","TTO","OMN","TUN","TUR","ARE","UGA",
                   "SUN","GBR","UKR","USA","BFA","URY","UZB","VEN","VNM","ETH",
                   "WSM","YUG","YEM","COD","ZMB","BEL","LUX","SRB","MNE","SDN"
)

test <- tibble(country = ,
        year = names(results),
        delta_F = map(results, "delta_F"))
t1 <- rep(country_codes, each = 27)
t2 <- rep(names(results), times = 190)
t3 <- map(results, contains("delta_F"))
