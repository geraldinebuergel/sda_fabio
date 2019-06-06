library(tidyverse)
library(Matrix)

rm(list = ls()); gc()

#-------------------------------------------------------------
#
# LOAD AND CONVERT HYBRID DATA (1995-2013, EX: 44 countries, 200 products 
#                                        + FA: 190 countries, 130 products)
#
#-------------------------------------------------------------

fabio <- "/mnt/nfs_fineprint/tmp/fabio/"
exiobase <- "/mnt/nfs_fineprint/tmp/exiobase/pxp/"
hybrid <- "/mnt/nfs_fineprint/tmp/fabio/hybrid/"

# load L files
L_list <- list.files(path = hybrid, pattern = "*_B.rds")
L_list <- L_list[10:28]

# subset L for 3 years at a time
L_list <- L_list[1:2] %>% 
  map(~ readRDS(paste0(hybrid,.x))) %>%
  map(~.x[-c(24701:24960), -c(8801:9800)])

# save L
save(L_list, file = "L_list_hybrid.RData")

# load E files and subset landuse columns
E_list <- list.files(path = fabio, pattern = "*_E.rds")
E_list <- E_list[10:28] %>% 
  map(~ readRDS(paste0(fabio,.x)))
E_landuse <- list()
for (i in seq_along(1:length(E_list))){
  E_landuse[[i]] <- E_list[[i]][["Landuse"]]
}

# load X files
X_list <- list.files(path = fabio, pattern = "*_X.rds") 
X_list <- X_list[10:28] %>% 
  map(~ readRDS(paste0(fabio,.x))) %>% 
  rapply(function(x) ifelse(x < 0, 0, x), how = "list")

# calculate U and replace NaN and Inf values with zero
U_list <- map2(E_landuse, X_list, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list") %>% 
  map(~c(.x[1:24700], rep(0, 8800)))

# save U 
save(U_list, file = "U_list_hybrid.RData")

# load Y files, aggregate final demand categories & add zeros for food demand
Y_list <-  list.files(path = exiobase, pattern = "*_Y.RData")
Y_list <- Y_list[1:19] %>% 
  map(~ mget(load(paste0(exiobase,.x)))) %>% 
  lapply(as.data.frame) %>% 
  map(~.x[1:8800, 1:308]) %>% 
  lapply(as.matrix) %>% 
  lapply(function(x) {
  colnames(x) <- rep(1:44, each = 7)
  return(x)}) %>% 
  lapply(function(x){
  x <- as.matrix(x) %*% sapply(unique(colnames(x)),"==",colnames(x))
  return(x)}) %>% 
  lapply(function (x) rbind(matrix(0, 24700, 44), x))

# save Y
save(Y_list, file = "Y_list_hybrid.RData")
