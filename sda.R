library(tidyverse)

rm(list = ls()); gc()

source("data_sample.R")

#---------------------------------
# SDA
#---------------------------------

# delta function 
delta <- function(x, y){x - y}

# average function
avg <- function(x, y){(0.5 * x) + (0.5 * y)}

# this is what delta F should be for 2012 and 2013
F_2012 <- U_2012 %*% L_2012 %*% Y_2012
F_2013 <- U_2013 %*% L_2013 %*% Y_2013
delta_F_c <- delta(F_2013, F_2012)

# function takes average of both polar decomposition forms and returns individual
# contribution to the change of F of each variable as a list
SDA <- function(U_0, U_1, L_0, L_1, Y_0, Y_1){
  delta_U <- avg((delta(U_1, U_0) %*% L_1 %*% Y_1), 
                 (delta(U_1, U_0) %*% L_0 %*% Y_0))
  delta_L <- avg((U_0 %*% delta(L_1, L_0) %*% Y_1),   
                 (U_1 %*% delta(L_1, L_0) %*% Y_0))
  delta_Y <- avg((U_0 %*% L_0 %*% delta(Y_1, Y_0)),   
                 (U_1 %*% L_1 %*% delta(Y_1, Y_0)))
  delta_F <- delta_U + delta_L + delta_Y 
  return(list(delta_F, delta_U, delta_L, delta_Y))
}
sda <- SDA(U_2012, U_2013, L_2012, L_2013, Y_2012, Y_2013)
names(sda) <- c("delta F", "delta U", "delta L", "delta Y")

all.equal(sda[["delta F"]], delta_F_c)

# polar decomposition forms are equal
polar1 <- function(U_0, U_1, L_0, L_1, Y_0, Y_1){
  (delta(U_1, U_0) %*% L_1 %*% Y_1) +
  (U_0 %*% delta(L_1, L_0) %*% Y_1) +
  (U_0 %*% L_0 %*% delta(Y_1, Y_0))
}
t_polar1 <- polar1(U_2012, U_2013, L_2012, L_2013, Y_2012, Y_2013)

polar2 <- function(U_0, U_1, L_0, L_1, Y_0, Y_1){
  (delta(U_1, U_0) %*% L_0 %*% Y_0) +
  (U_1 %*% delta(L_1, L_0) %*% Y_0) +
  (U_1 %*% L_1 %*% delta(Y_1, Y_0))
}
t_polar2 <- polar2(U_2012, U_2013, L_2012, L_2013, Y_2012, Y_2013)

all.equal(t_polar1, t_polar2)

# while loop
t <- 2013
while(t - 1 >= 1986){
  SDA
  t <- t - 1
}

# for loop
# put all variables in a sequence or use seq.along(x)
output <- data.frame()
for(var in 1:length(seq)){
  output[[i]] <- do SDA stuff that gets added to output
  return(output)
}