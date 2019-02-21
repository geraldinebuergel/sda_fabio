library(tidyverse)

rm(list = ls()); gc()

source("data_sample.R")

#---------------------------------
# SDA
#---------------------------------

# delta function 
delta <- function(x, y){x - y}

# this is what delta F should be for 2012 and 2013
F_2012 <- U_2012 %*% L_2012 %*% Y_2012
F_2013 <- U_2013 %*% L_2013 %*% Y_2013
delta_F <- delta(F_2013, F_2012)

# function takes mean of both polar decomposition forms and returns individual
# contribution to the change of F
SDA <- function(U_0, U_1, L_0, L_1, Y_0, Y_1){
  delta_U <- mean(delta(U_1, U_0) %*% L_1 %*% Y_1,   
                  delta(U_1, U_0) %*% L_0 %*% Y_0, trim = 0.2)
  delta_L <- mean(U_0 %*% delta(L_1, L_0) %*% Y_1,   
                  U_1 %*% delta(L_1, L_0) %*% Y_0)
  delta_Y <- mean(U_0 %*% L_0 %*% delta(Y_1, Y_0),   
                  U_1 %*% L_1 %*% delta(Y_1, Y_0))
  delta_F <- delta_U + delta_L + delta_Y 
  return(delta_F, delta_U, delta_L, delta_Y)
}
test <- SDA(U_2012, U_2013, L_2012, L_2013, Y_2012, Y_2013)
str(test)
# write a data prep function that returns each variable
# loop/rep for 1986-2013
# while loop
t <- 2013
while(t - 1 >= 1986){
  SDA
  t <- t - 1
}

# for loop
# put all variables in a sequence 
for(var in 1:length(seq)){
  delta(i)
}