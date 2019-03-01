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
llev_expanded <- matrix(llev, nrow = 1300, ncol = length(llev), byrow = TRUE)

# distribution of supplier countries (Ljrs/Ljs)
L_list <- split.data.frame(L, rep(1:10, each = 130))
ljrs_list <- map(L_list, colSums) # map_dfr() should return data frame
ljrs <- do.call(rbind, ljrs_list) 
lsup <- divide(ljrs)
lsup[is.nan(lsup)] <- 0
lsup_expanded <-  lsup[rep(1:nrow(lsup), each = 130), ] 

# distribution of intermediate products (Lijrs/Ljrs)
lpro_list <- map(L_list, divide) # elements are matrices
lpro <- do.call(rbind, lpro_list)
lpro[is.nan(lpro)] <- 0

# combine lpro, lsup and llev back to L
L_dec <- lpro * lsup_expanded * llev_expanded
all.equal(L_dec, L)

#-------------------------------
# decompose Y
#-------------------------------
  
# select columns with final demand for food only
Y_df_Food <- as.data.frame(Y) %>% 
  dplyr::select(contains("Food"))
Y <- as.matrix(Y_df_Food)

ys <- as.matrix(colSums(Y))
ys_expanded <- matrix(ys, nrow = 1300, ncol = length(ys), byrow = TRUE)

yrs_list <- split.data.frame(Y_df_Food, rep(1:10, each = 130))
yrs_list_sum <- map(yrs_list, colSums)
yrs <- do.call(rbind, yrs_list_sum) %>% 
  as.matrix()
yrs_expanded <- yrs[rep(1:nrow(yrs), each = 130), ] 

# distribution of supplier countries (yrs/ys)
ysup <- divide(yrs)
ysup_expanded <- ysup[rep(1:nrow(ysup), each = 130), ] 

# distribution of products (yirs/yrs)
ypro <- Y / yrs_expanded

# check
Y_dec <- ypro * ysup_expanded * ys_expanded
all.equal(Y_dec, Y)

load("C:/Users/Zoe/Desktop/FABIO/GDP_deflated.RData")
load("C:/Users/Zoe/Desktop/FABIO/GDP_per_capita.RData")
load("C:/Users/Zoe/Desktop/FABIO/Population.RData")

gdp <- gdp[[28]][1:10, ]
gdp1 <- rep(gdp, each = 130)
gdp_expanded <- matrix(gdp1, nrow = length(gdp1), ncol = 10)

# level of final demand per GDP (ys/GDP)
ylev <- ys_expanded / gdp_expanded
  
# GDP per capita
G <- gdp_per_capita[[28]][1:10, ]
G1 <- rep(G, each = 130)
G_expanded <- matrix(G1, nrow = length(G1), ncol = 10)
  
# population
P <- pop[[28]][1:10, ]
P1 <- rep(P, each = 130)
P_expanded <- matrix(P1, nrow = length(P1), ncol = 10)

Y_dec2 <- ypro * ysup_expanded * ylev * G_expanded * P_expanded
all.equal(Y, Y_dec2)

#-------------------------------
# assemble to land footprint
#-------------------------------

F <- U %*% L %*% Y  
F_dec <- U %*% L_dec %*% Y_dec2
all.equal(F_dec, F)
