library(tidyverse)

rm(list = ls()); gc()

source("data_sample.R")

#---------------------------------
# SDA
#---------------------------------

delta <- function(x_2012, x_2013){x_2013 - x_2012} # use diff?

SDA <- function(U(t-1), U(t), L(t-1), L(t), Y(t-1), Y(t)){
  delta_U <- mean(delta(U) %*% L(t) %*% Y(t),   
                  delta(U) %*% L(t-1) %*% Y(t-1))
  delta_L <- mean(U(t-1) %*% delta(L) %*% Y(t),   
                  U(t) %*% delta(L) %*% Y(t-1))
  delta_Y <- mean(U(t-1) %*% L(t-1) %*% delta(Y),   
                  U(t) %*% L(t) %*% delta(Y))
  delta_F <- delta_U + delta_L + delta_Y
}

# write a data prep function that returns each variable
# write two polar SDA functions and take mean
# loop/rep for 1986-2013