library(tidyverse)
library(MASS)
require(MASS)
require(dplyr)
memory.limit()
memory.limit(8000)

rm(list = ls()); gc()

#####################################
#
# Decomposition of F = ULY
#
#####################################

# load data files
load("C:/Users/Zoe/Desktop/FABIO/2013_E.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_X.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_L.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_Y.RData")

# reduce data to sample size of 10 countries
str(E)
str(X)
str(L)
str(Y)
E <- E[1:1300,]
X <- X[1:1300]
L <- L[1:1300, 1:1300]
Y <- Y[1:1300, 1:40]

#-------------------------------
# built U (ha/1000t)
#-------------------------------
  
u <- E$Landuse / X
u[is.nan(u)] <- 0
U <- diag(u)

#-------------------------------
# decompose L
#-------------------------------

# level of total input requirements (Ljs)
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

L_dec <- lpro %*% lsup %*% llev
all.equal(L, L_dec)

#-------------------------------
# decompose Y
#-------------------------------
  
# select columns with final demand for food only
Y_df_Food <- as.data.frame(Y) %>% 
  dplyr::select(contains("Food"))
Y <- as.matrix(Y_df_Food)

# create column sums
ys <- as.matrix(colSums(Y))

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
ypro <- Y %*% ginv(yrs)

# implement world bank data including per capita function
source("wb_data_sample.R")

# level of final demand per GDP (ys/GDP)
ylev <- ys / wb_gdp
  
# GDP per capita
G <- gdp_per_capita_f
  
# population
P <- wb_pop

Y_dec <- ypro %*% ysup %*% t(ylev) %*% G %*% t(P)
all.equal(Y, Y_dec)

all.equal(as.matrix(ys), t(ylev) %*% G %*% t(P))
near(Y, ypro %*% ysup %*% t(ys))

#-------------------------------
# finished land footprint
#-------------------------------

F <- U %*% L %*% Y  
F_dec <- U %*% L_dec %*% Y_dec
F_dec_all <- U %*% lpro %*% lsup %*% llev %*% ypro %*% ysup %*% ys
sum(is.nan(F))
sum(is.nan(F_dec))
near(F, F_dec)
