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

df_YFood <- as.data.frame(Y) %>%
  select(contains("Food"))
YFood <- as.matrix(df_YFood)

#create column sums
ys <- colSums(YFood)

#distribution of supplier countries yrs/ys
yrs <- 
ysup <- yrs / ys

#distribution of products yirs/yrs
ypro <- YFood / yrs

#level of final demand per GDP ys/GDP
ylev <- ys / gdp_data

#GDP per capita
G <- per_capita(gdp_data)

#population
P <- wb_pop_data$value

-------------------------------
# finished equation
-------------------------------

f <- û*L*Y
