library(tidyverse)

rm(list = ls()); gc()

#-----------------------------------
# assemble results in list
#-----------------------------------

loop_list <- list.files(pattern = "loop") %>% 
  map(~ mget(load(paste0(.x))))

results <- list()
for(i in 1:14){
  results[[i]] <- list(loop_list[[i]][[1]][[2]], loop_list[[i]][[1]][[3]])
}
results[[14]] <- loop_list[[14]]

results <- lapply(results, unlist, recursive = FALSE) %>% 
  unlist(recursive = FALSE) %>% 
  split(rep(1:27, each = 10))

names(results) <- c(1987:2013)
names(results[[27]]) <- c("delta_F", "con_U", "con_lpro", "con_lsup", "con_llev",
                          "con_ypro", "con_ysup", "con_ylev", "con_G", "con_P")
save(results, file = "results_list.RData")

#----------------------------------------
# turn list into appropriate tibble
#----------------------------------------

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

# function isolates variables and converts them into a vector
vec_list <- function(x){
  map(results, x) %>% 
    unlist() %>%
    matrix(nrow = 27, ncol = 190, byrow = TRUE) %>% 
    as.vector()
}

results_tbl <- tibble(country = rep(country_codes, each = 27),
                      year = rep(names(results), times = 190),
                      delta_F = vec_list("delta_F"),
                      con_U = vec_list("con_U"),
                      con_lpro = vec_list("con_lpro"),
                      con_lsup = vec_list("con_lsup"),
                      con_llev = vec_list("con_llev"),
                      con_ypro = vec_list("con_ypro"),
                      con_ysup = vec_list("con_ysup"),
                      con_ylev = vec_list("con_ylev"),
                      con_G = vec_list("con_G"),
                      con_P = vec_list("con_P")
)
save(results_tbl, file = "results_tbl.RData")