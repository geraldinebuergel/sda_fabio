library(tidyverse)
library(MASS)
require(MASS)
require(dplyr)
memory.limit()
memory.limit(16000)

rm(list = ls()); gc()


#------------------------------------------
#
# Decomposition of F = ULY
#
#------------------------------------------

# load data files
load("C:/Users/Zoe/Desktop/FABIO/2013_E.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_X.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_L.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_Y.RData")

# reduce data to sample size of 10 countries
E <- E[1:1300,]
X <- X[1:1300]
L <- L[1:1300, 1:1300]
Y <- Y[1:1300, 1:40]

# divide each element of a matrix by its column sum
divide <- function(x) { t(t(x) / rowSums(t(x))) }

#-------------------------------
# built U (ha/1000t)
#-------------------------------
  
U <- E$Landuse / X
U[is.nan(U)] <- 0 
U <- diag(U)

#-------------------------------
# decompose L
#-------------------------------

# level of total input requirements (Ljs)
llev <- colSums(L)

# distribution of supplier countries (Ljrs/Ljs)
L_list <- split.data.frame(L, rep(1:10, each = 130))
ljrs_list <- map(L_list, colSums) # map_dfr() should return data frame
ljrs <- do.call(rbind, ljrs_list) 
lsup <- divide(ljrs)
lsup[is.nan(lsup)] <- 0
head(colSums(lsup))

# distribution of intermediate products (Lijrs/Ljrs)
lpro_list <- map(L_list, divide) # elements are matrices
lpro <- do.call(rbind, lpro_list)
lpro[is.nan(lpro)] <- 0
head(colSums(lpro))

# check lsup (lsup * llev = ljrs)
L_test <- sweep(lsup, 2, llev, '*')
all.equal(L_test, ljrs)

# check lpro (lpro * ljrs = L)
lpro_list_n <- split.data.frame(lpro, rep(1:10, each = 130)) # elements are matrices
out <- list()
for (i in seq_along(lpro_list_n)) {
  out[[i]] <- lpro_list_n[[i]] %*% diag(ljrs_list[[i]])
}
L_test2 <- do.call(rbind, out) 
all.equal(L_test2, L)

# combine lpro, lsup and llev back to L
L_dec <- t(lpro %*% t(lsup)) %*% diag(llev)
all.equal(L_dec, ljrs)

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
yrs_list_sum <- map(yrs_list, colSums)

# merge list of column sums into matrix
yrs <- do.call(rbind, yrs_list_sum) %>% 
  as.matrix()

# get distribution of supplier countries (yrs/ys)
ysup <- yrs %*% t(ginv(ys))

# get distribution of products (yirs/yrs)
ypro <- Y %*% ginv(yrs)

load("C:/Users/Zoe/Desktop/FABIO/GDP_deflated.RData")
load("C:/Users/Zoe/Desktop/FABIO/GDP_per_capita.RData")
load("C:/Users/Zoe/Desktop/FABIO/Population.RData")

# level of final demand per GDP (ys/GDP)
#ylev <- ys / gdp
  
# GDP per capita
G <- gdp_per_capita
  
# population
P <- pop

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
