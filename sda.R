library(tidyverse)
library(MASS)
require(MASS)
require(dplyr)
memory.limit()
memory.limit(8000)

rm(list = ls()); gc()

#------------------------------------
# Built F = ULY
#------------------------------------

load("C:/Users/Zoe/Desktop/FABIO/1986_E.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_X.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_L.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_Y.RData")

#--------------------------------------------------
# reduce data to sample size of 10 countries
#--------------------------------------------------
str(E)
str(X)
str(L)
str(Y)
E <- E[1:1300,]
X <- X[1:1300]
L <- L[1:1300, 1:1300]
Y <- Y[1:1300, 1:40]

#-------------------------------
# built U in ha/1000t
#-------------------------------
  
u <- E$Landuse / X
u[is.nan(u)] <- 0
U <- diag(u)

#-------------------------------
# built L variables
#-------------------------------

# level of total input requirements (Ljs)
str(L)
llev <- colSums(L)

# distribution of supplier countries (Ljrs/Ljs)
ljrs_list <- split.data.frame(as.data.frame(L), rep(1:10, each = 130))
ljrs_list_sum <- lapply(ljrs_list, FUN = colSums)
ljrs <- do.call(rbind, ljrs_list_sum)
as.matrix(ljrs)
lsup <- ljrs %*% t(ginv(llev))
lsup[is.nan(lsup)] <- 0

# distribution of intermediate products (Lijrs/Ljrs)
lpro <- L %*% ginv(ljrs)

L_1986 <- lpro %*% lsup %*% llev

#-------------------------------
# built Y variables
#-------------------------------
  
# select columns with final demand for food only
str(Y)
Y_df_Food <- as.data.frame(Y) %>% 
  dplyr::select(contains("Food"))
Y_Food <- as.matrix(Y_df_Food)

# create column sums
ys <- colSums(Y_Food)

# split Y into list of 10 data frames with 130 rows each
yrs_list <- split.data.frame(Y_df_Food, rep(1:10, each = 130))

# sum up columns of each data frame
yrs_list_sum <- lapply(yrs_list, FUN = colSums)

# merge list of column sums into matrix
yrs <- do.call(rbind, yrs_list_sum) %>% 
  as.matrix()

# get distribution of supplier countries (yrs/ys)
ysup <- yrs %*% t(ginv(ys))

# get distribution of products (yirs/yrs)
ypro <- Y_Food %*% ginv(yrs)

# implement world bank data including per capita function
source("wb_data.R")

# level of final demand per GDP (ys/GDP)
ylev <- ys %*% ginv(wb_gdp_data)
  
# GDP per capita
G <- 
  
# population
P <- 

Y_1986 <- ypro %*% ysup #%*% ylev %*% G %*% P
    
#-------------------------------
# finished land footprint
#-------------------------------
  
F <- U %*% L_1986 #%*% Y_1986
# * = elementwise multiplication
# %*% = matrix multiplication
