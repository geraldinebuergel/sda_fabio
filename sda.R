library(tidyverse)

rm(list = ls()); gc()

###########################
#Built F = ûLY
###########################

load("C:/Users/Zoe/Desktop/FABIO/1986_E.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_X.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_L.RData")
load("C:/Users/Zoe/Desktop/FABIO/1986_Y.RData")

# built u in ha/1000t

u <- E$Landuse / X
u[is.nan(u)] <- 0
û <- diag(u)

-------------------------------
# built L variables
-------------------------------

-------------------------------
# built Y variables
-------------------------------

#select columns with final demand for food only
str(Y)
Y_df_Food <- as.data.frame(Y) %>% 
  select(contains("Food"))
Y_Food <- as.matrix(Y_df_Food)

#create column sums
ys <- colSums(Y_Food)

#distribution of supplier countries (yrs/ys)
head(yrs)
yrs <- aggregate(Y_Food, by = list(???), FUN = colSums) #try split?
ysup <- yrs / ys

#distribution of products (yirs/yrs)
ypro <- Y_Food / yrs

#implement world bank data including per capita function
source("wb_data.R")

#level of final demand per GDP (ys/GDP)
ylev <- ys / 

#GDP per capita
G <- 

#population
P <- 

-------------------------------
# finished equation
-------------------------------

f <- û*L*Y
