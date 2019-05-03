library(tidyverse)

rm(list = ls()); gc()

#----------------------------------------------------------------------------
#
# LOAD AND CONVERT DATA FILES (1986-2013, 190 countries, 120 products/130 for _p)
#
#----------------------------------------------------------------------------

mount_wu_share()

fabio <- "/mnt/nfs_fineprint/tmp/fabio/"

# number of desired rows depending on number of products
norow <- 24700

# load E files and subset landuse columns
E_list <-  list.files(path = fabio, pattern = "*_E.rds") %>% 
  map(~ readRDS(paste0(fabio,.x)))
E_landuse <- list()
for (i in seq_along(1:length(E_list))){
  E_landuse[[i]] <- E_list[[i]][["Landuse"]]
}

save(E_landuse, file = "landuse.RData")

# load X files
X_list <-  list.files(path = fabio, pattern = "*_X.rds") %>% 
  map(~ readRDS(paste0(fabio,.x)))

# calculate U and replace NaN and Inf values with zero
U_list <- map2(E_landuse, X_list, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list") %>% 
  map(~.x[1:norow])

# save U 
save(U_list, file = "U_list_p.RData")

# load L files
L_list <- list.files(path = fabio, pattern = "*_L_mass.rds")

# subset L for 3 years at a time
L_list <- L_list[c(1,28)] %>% 
  map(~ readRDS(paste0(fabio,.x))) %>%
  lapply(as.data.frame) %>% 
  map(~.x[1:norow, 1:norow]) %>% 
  lapply(as.matrix)

# save L
save(L_list, file = "L_list_p.RData")

# load Y files and subset food columns
Y_list <-  list.files(path = fabio, pattern = "*_Y.rds") %>% 
  map(~ readRDS(paste0(fabio,.x))) %>% 
  lapply(as.data.frame) %>% 
  lapply(dplyr::select, contains("Food")) %>% 
  lapply(as.matrix) %>% 
  map(~.x[1:norow, 1:190])
  
# save Y
save(Y_list, file = "Y_list_p.RData")