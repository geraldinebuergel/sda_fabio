library(tidyverse)
memory.limit()
memory.limit(64000)

rm(list = ls()); gc()

#----------------------------------------------------------------------------
#
# LOAD AND CONVERT DATA FILES AS LISTS
#
#----------------------------------------------------------------------------

# create sample dataset of the first 10 countries (2011-2013)

setwd("C:/Users/Zoe/Desktop/temp/")

# load E files and subset landuse columns
E_names <-  list.files(pattern = "*_E.RData")
E_list <-  map(E_names, function(x) mget(load(x)))
E_list_df <- map(E_list, as.data.frame)
E_landuse <- map(E_list_df, dplyr::select, contains("E.Landuse"))
E_landuse_sample <- map(E_landuse, slice, 1:1300)

# load X files
X_names <-  list.files(pattern = "*_X.RData")
X_list <-  map(X_names, function(x) mget(load(x)))
X_list_df <- map(X_list, as.data.frame)
X_sample <- map(X_list_df, slice, 1:1300)

# calculate U and replace NaN values with zero
U_sample <- list()
for(i in seq_along(1:3)){
  U_sample[[i]] <- E_landuse_sample[[i]] / X_sample[[i]]
}
U_sample0 <- rapply(U_sample, function(x) ifelse(is.nan(x),0,x), how="list")
U_sample_unlist <- list()
for (i in 1:3){
  U_sample_unlist[[i]] <- U_sample0[[i]][["E.Landuse"]]
}
U_sample_diag <- map(U_sample_unlist, diag)

# save U
save(U_sample0, file = "U_vector_sample.RData")
save(U_sample_diag, file = "U_diag_sample.RData")

# load L files
L_names <-  list.files(pattern = "*_L.RData")
L_sample <-  lapply(L_names, function(x) mget(load(x)))
L_sample <- lapply(L_list, as.data.frame)
L_sample <- lapply(L_list_df, slice, 1:1300)
L_sample <- lapply(L_sample, dplyr::select, 1:1300)
L_sample <- lapply(L_sample, as.matrix)

# save L file
save(L_sample, file = "L_sample.RData")

# load Y files and subset food columns
Y_names <-  list.files(pattern = "*_Y.RData")
Y_list <-  map(Y_names, function(x) mget(load(x)))
Y_list_df <- map(Y_list, as.data.frame)
Y_sample <- map(Y_list_df, slice, 1:1300)
Y_sample <- map(Y_sample, dplyr::select, contains("Food"))
Y_sample <- map(Y_sample, dplyr::select, 1:10)
Y_sample <- map(Y_sample, as.matrix)

# save Y
save(Y_sample, file = "Y_sample.RData")

setwd("C:/Users/Zoe/Desktop/sda_fabio/")