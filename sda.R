library(tidyverse)

rm(list = ls()); gc()

#source("data_sample.R")

#---------------------------------
# 
# SDA FUNCTION
#
#---------------------------------

# average function
avg <- function(x, y){(0.5 * x) + (0.5 * y)}

# function takes average of both polar decomposition forms and returns individual
# contribution to the change of F for each variable as a list
SDA <- function(U_0, U_1, L_0, L_1, Y_0, Y_1){
  con_U <- avg(((U_1 - U_0) %*% L_1 %*% Y_1), 
              ((U_1 - U_0) %*% L_0 %*% Y_0))
  con_L <- avg((U_0 %*% (L_1 - L_0) %*% Y_1),   
               (U_1 %*% (L_1 - L_0) %*% Y_0))
  con_Y <- avg((U_0 %*% L_0 %*% (Y_1 - Y_0)),   
               (U_1 %*% L_1 %*% (Y_1 - Y_0)))
  delta_F <- con_U + con_L + con_Y 
  return(list(delta_F = delta_F, con_U = con_U, con_L = con_L, con_Y = con_Y))
}

# test SDA without L
SDA_t <- function(U_1, U_0, Y_1, Y_0){
  con_U <- avg(((U_1 - U_0) %*% Y_1), 
               ((U_1 - U_0) %*% Y_0))
  con_Y <- avg((U_0 %*% (Y_1 - Y_0)),   
               (U_1 %*% (Y_1 - Y_0)))
  delta_F <- con_U + con_Y 
  return(list(delta_F = delta_F, con_U = con_U,con_Y = con_Y))
}

# loop SDA function with list inputs
sda_loop <- list()
for (i in seq_along(3:2)){
  for (j in 2:1){
    sda_loop[[i]] <- SDA_t(U_sample_diag[[i]], U_sample_diag[[j]], 
                           Y_sample[[i]], Y_sample[[j]])
  }
}