memory.limit(16000)

#rm(list = ls()); gc()

# load data files for 2013
load("C:/Users/Zoe/Desktop/FABIO/2013_E.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_X.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_L.RData")
load("C:/Users/Zoe/Desktop/FABIO/2013_Y.RData")

# function to calculate U
fun_u <- function(E, X){
  u <- E$Landuse / X
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

# load data files for 2012
load("C:/Users/Zoe/Desktop/FABIO/2012_E.RData")
load("C:/Users/Zoe/Desktop/FABIO/2012_X.RData")
load("C:/Users/Zoe/Desktop/FABIO/2012_L.RData")
load("C:/Users/Zoe/Desktop/FABIO/2012_Y.RData")

# repeat data conversion
U_2012 <- fun_u(E[1:1300,], X[1:1300])

L_2012 <- L[1:1300, 1:1300]

Y_2012 <- food(Y[1:1300, 1:40])

# write loop/ function to automate this process