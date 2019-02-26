library(tidyverse)
memory.limit(16000)

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
names(E_list_df) <- c(2011:2013)
E_landuse <- map(E_list_df, dplyr::select, contains("E.Landuse"))
E_landuse_sample <- map(E_landuse, slice, 1:1300)

# load X files
X_names <-  list.files(pattern = "*_X.RData")
X_list <-  map(X_names, function(x) mget(load(x)))
X_list_df <- map(X_list, as.data.frame)
names(X_list_df) <- c(2011:2013)
X_sample <- map(X_list_df, slice, 1:1300)

# calculate U and replace NaN values with zero
U_sample <- list()
for(i in seq_along(2011:2013)){
  U_sample[[i]] <- E_landuse_sample[[i]] / X_sample[[i]]
}
rapply(U_sample, function(x) ifelse(is.nan(x),0,x), how="unlist")
names(U_sample) <- c(2011:2013)

# load L files
L_names <-  list.files(pattern = "*_L.RData")
L_list <-  map(L_names, function(x) mget(load(x)))
L_list_df <- map(L_list, as.data.frame)
names(L_list_df) <- c(2011:2013)
L_sample <- map(L_list_df, slice, 1:1300)
L_sample <- map(L_sample, dplyr::select, 1:1300)

# load Y files and subset food columns
Y_names <-  list.files(pattern = "*_Y.RData")
Y_list <-  map(Y_names, function(x) mget(load(x)))
Y_list_df <- map(Y_list, as.data.frame)
names(Y_list_df) <- c(2011:2013)
Y_sample <- map(Y_list_df, slice, 1:1300)
Y_sample <- map(Y_sample, dplyr::select, contains("Food"))
Y_sample <- map(Y_sample, dplyr::select, 1:40)

setwd("C:/Users/Zoe/Desktop/sda_fabio/")

#------------------------------------------------
#
# load data individually
#
#------------------------------------------------

# function to calculate U
fun_u <- function(E, X){
  u <- E$E.Landuse / X
  u[is.nan(u)] <- 0
  diag(u)
}

# calculate sample size of U
U_2013 <- fun_u(E[1:1300,], X[1:1300])

# reduce L to sample size
L_2013 <- L[1:1300, 1:1300]

# function to get Y with food columns only
food <- function(Y){
  Y_df <- as.data.frame(Y)
  Y_df_Food <- dplyr::select(Y_df, contains("Food"))
  as.matrix(Y_df_Food)
}

# reduce Y to sample size with food columns only
Y_2013 <- food(Y[1:1300, 1:40])

# repeat data conversion
U_2012 <- fun_u(E[1:1300,], X[1:1300])

L_2012 <- L[1:1300, 1:1300]

Y_2012 <- food(Y[1:1300, 1:40])