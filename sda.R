library(tidyverse)
memory.limit()
memory.limit(8000)

rm(list = ls()); gc()

###########################
# Built F = ULY
###########################

load("C:/Users/Zoe/Desktop/FABIO/1986_E.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_X.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_L.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_Y.RData")

# built u in ha/1000t

u <- E$Landuse / X
u[is.nan(u)] <- 0
U <- diag(u)

-------------------------------
# built L variables
-------------------------------

# level of total input requirements (Ljs)
str(L)
llev <- colSums(L)

# distribution of supplier countries (Ljrs/Ljs)


# distribution of intermediate products (Lijrs/Ljrs)

-------------------------------
# built Y variables
-------------------------------

# select columns with final demand for food only
str(Y)
Y_df_Food <- as.data.frame(Y) %>% 
  select(contains("Food"))
Y_Food <- as.matrix(Y_df_Food)

# create column sums
ys <- colSums(Y_Food)

# split Y into list of 192 data frames with 130 rows each
yrs_list <- split.data.frame(Y_df_Food, rep(1:192, each = 130))

# sum up columns of each data frame
yrs_list_sum <- lapply(yrs_list, FUN = colSums)

# merge list of column sums into matrix
yrs <- do.call(rbind, yrs_list_sum) %>% 
  as.matrix()

# get distribution of supplier countries (yrs/ys)
# by dividing each element of a column in yrs by the corresponding element in ys
ysup <- sweep(yrs, 2, ys, FUN = '/')
ysup[is.nan(ysup)] <- 0

# get distribution of products (yirs/yrs)
# by dividing each element in Y_Food by the corresponding element in yrs
ypro_list <- lapply(yrs_list, function(x){ x / colSums(x) })
ypro <- do.call(rbind, ypro_list) %>% 
  as.matrix()
ypro[is.nan(ypro)] <- 0

# implement world bank data including per capita function
source("wb_data.R")

# level of final demand per GDP (ys/GDP)
ylev <- 

# GDP per capita
G <- 

# population
P <- 

-------------------------------
# finished equation
-------------------------------

f <- U %*% L %*% ysup %*% ypro %*% ylev %*% G %*% P
# * = elementwise multiplication
# %*% = matrix multiplication
