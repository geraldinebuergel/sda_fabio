<<<<<<< HEAD
library(tidyverse)

rm(list = ls()); gc()

#---------------------------------
# 
# SDA FUNCTION
#
#---------------------------------

load("C:/Users/Zoe/Desktop/temp/U_sample_diag.RData")
load("C:/Users/Zoe/Desktop/temp/L_sample.RData")
load("C:/Users/Zoe/Desktop/temp/Y_sample.RData")

# average function
avg <- function(x, y){(0.5 * x) + (0.5 * y)}

# reference for what delta F should be
F_2011 <- U_sample_diag[[1]] %*% L_sample[[1]] %*% Y_sample[[1]]
F_2012 <- U_sample_diag[[2]] %*% L_sample[[2]] %*% Y_sample[[2]]
F_2013 <- U_sample_diag[[3]] %*% L_sample[[3]] %*% Y_sample[[3]]
F_soll3 <- F_2013 - F_2012
F_soll2 <- F_2012 - F_2011

# function takes average of both polar decomposition forms and returns individual
# contribution to the change of F for each variable as a list
SDA <- function(U_1, U_0, L_1, L_0, Y_1, Y_0){
  con_U <- avg(((U_1 - U_0) %*% L_1 %*% Y_1), 
              ((U_1 - U_0) %*% L_0 %*% Y_0))
  con_L <- avg((U_0 %*% (L_1 - L_0) %*% Y_1),   
               (U_1 %*% (L_1 - L_0) %*% Y_0))
  con_Y <- avg((U_0 %*% L_0 %*% (Y_1 - Y_0)),   
               (U_1 %*% L_1 %*% (Y_1 - Y_0)))
  delta_F <- con_U + con_L + con_Y 
  return(list(delta_F = delta_F, con_U = con_U, con_L = con_L, con_Y = con_Y))
}

# check function -> it works!
F_fun <- SDA(U_sample_diag[[3]], U_sample_diag[[2]], 
             L_sample[[3]], L_sample[[2]], 
             Y_sample[[3]], Y_sample[[2]])
all.equal(F_soll3, F_fun[["delta_F"]])

# loop SDA function with list inputs
loop <- list()
for (i in 2:3){
    loop[[i]] <- SDA(U_sample_diag[[i]], U_sample_diag[[(i-1)]], 
                     L_sample[[i]], L_sample[[(i-1)]],
                     Y_sample[[i]], Y_sample[[(i-1)]])
}
all.equal(F_soll3, loop[[3]][["delta_F"]])

# SDA function with decomposed inputs
SDA_dec <- function(U1, U0, lpro1, lpro0, lsup1, lsup0, llev1, llev0, ypro1, ypro0, 
                    ysup1, ysup0, ylev1, ylev0, G1, G0, P1, P0){
  con_U <- avg((U1 - U0) %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * ysup1 * ylev1 * G1 * P1), 
               (U1 - U0) %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * ysup0 * ylev0 * G0 * P0))
  con_lpro <- avg(U0 %*% ((lpro1 - lpro0) * lsup1 * llev1) %*% (ypro1 * ysup1 * ylev1 * G1 * P1), 
                  U1 %*% ((lpro1 - lpro0) * lsup0 * llev0) %*% (ypro0 * ysup0 * ylev0 * G0 * P0))
  con_lsup <- avg(U0 %*% (lpro0 * (lsup1 - lsup0) * llev1) %*% (ypro1 * ysup1 * ylev1 * G1 * P1), 
                  U1 %*% (lpro1 * (lsup1 - lsup0) * llev0) %*% (ypro0 * ysup0 * ylev0 * G0 * P0))
  con_llev <- avg(U0 %*% (lpro0 * lsup0 * (llev1 - llev0)) %*% (ypro1 * ysup1 * ylev1 * G1 * P1), 
                  U1 %*% (lpro1 * lsup1 * (llev1 - llev0)) %*% (ypro0 * ysup0 * ylev0 * G0 * P0))
  con_ypro <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% ((ypro1 - ypro0) * ysup1 * ylev1 * G1 * P1), 
                  U1 %*% (lpro1 * lsup1 * llev1) %*% ((ypro1 - ypro0) * ysup0 * ylev0 * G0 * P0))
  con_ysup <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * (ysup1 - ysup0) * ylev1 * G1 * P1), 
                  U1 %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * (ysup1 - ysup0) * ylev0 * G0 * P0))
  con_ylev <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * ysup0 * (ylev1 - ylev0) * G1 * P1), 
                  U1 %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * ysup1 * (ylev1 - ylev0) * G0 * P0))
  con_G <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * ysup0 * ylev0 * (G1 - G0) * P1), 
               U1 %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * ysup1 * ylev1 * (G1 - G0) * P0))
  con_P <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * ysup0 * ylev0 * G0 * (P1- P0)), 
               U1 %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * ysup1 * ylev1 * G1 * (P1 - P0)))
  delta_F <- con_U + con_lpro + con_lsup + con_llev + con_ypro + con_ysup + 
             con_ylev + con_G + con_P
  return(list(delta_F, con_U, con_lpro, con_lsup, con_llev, con_ypro, con_ysup, 
              con_ylev, con_G, con_P))
}

loop_dec <- list()
for (i in 2:28){
    loop_dec[[i]] <- SDA_dec(U_list[[i]], U_list[[i-1]], 
                             lpro[[i]], lpro[[i-1]], 
                             lsup[[i]], lsup[[i-1]],
                             llev[[i]], llev[[i-1]],
                             ypro[[i]], ypro[[i-1]],
                             ysup[[i]], ysup[[i-1]],
                             ylev[[i]], ylev[[i-1]], 
                             G[[i]], G[[i-1]],
                             P[[i]], P[[i-1]])
}