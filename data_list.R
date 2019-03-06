library(tidyverse)
memory.limit()
memory.limit(100000)

rm(list = ls()); gc()

#----------------------------------------------------------------------------
#
# LOAD AND CONVERT DATA FILES (191 countries)
#
#----------------------------------------------------------------------------

# replace path with fabio data folder
#setwd("C:/Users/Zoe/Desktop/temp/")

# load E files and subset landuse columns
E_list <-  list.files(pattern = "*_E.RData") %>% 
  map(~ mget(load(.x)))
E_landuse <- list()
for (i in seq_along(1:length(E_list))){
  E_landuse[[i]] <- E_list[[i]][["E"]][["Landuse"]]
}

# load X files
X_list <-  list.files(pattern = "*_X.RData") %>% 
  map(~ mget(load(.x)))
X_list2 <- list()
for (i in seq_along(1:length(X_list))){
  X_list2[[i]] <- X_list[[i]][["X"]]
}

# calculate U and replace NaN values with zero
U_diag <- map2(X_list2, E_landuse, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list") %>% 
  map(~.x[-c(24831:24960)]) %>% 
  lapply(diag)

# save U 
#save(U_diag, file = "U_diag.RData")

# load L files
L_list <- list.files(pattern = "*_L.RData") %>% 
  map(~ mget(load(.x))) %>% 
  lapply(as.data.frame) %>% 
  map(~.x[-c(24831:24960), -c(24831:24960)]) %>% 
  lapply(as.matrix)

# save L
#save(L_list, file = "L_list.RData")

# load Y files and subset food columns
Y_list <-  list.files(pattern = "*_Y.RData") %>% 
  map(~ mget(load(.x))) %>% 
  lapply(as.data.frame) %>% 
  lapply(dplyr::select, contains("Food")) %>% 
  lapply(as.matrix) %>% 
  map(~.x[-c(24831:24960), -192])

# save Y
#save(Y_list, file = "Y_list.RData")

#setwd("C:/Users/Zoe/Desktop/sda_fabio/")