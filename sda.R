library(tidyverse)

rm(list = ls()); gc()

#---------------------------------
# 
# SDA FUNCTION
#
#---------------------------------

load("U_list.RData")
load("L_list.RData")
load("Y_list.RData")

# average function
avg <- function(x, y){(0.5 * x) + (0.5 * y)}

# reference for what delta F should be
F_1986 <- U_list[[1]] %*% L_list1[[1]] %*% Y_list[[1]]
F_1987 <- U_list[[2]] %*% L_list1[[2]] %*% Y_list[[2]]
F_1988 <- U_list[[3]] %*% L_list1[[3]] %*% Y_list[[3]]
F_soll8 <- F_1988 - F_1987
F_soll7 <- F_1987 - F_1986
F_soll <- list(F_soll7, F_soll8)
save(F_soll, file = "F_soll.RData")

load("F_soll.RData")

# test function takes average of both polar decomposition forms and returns individual
# contribution to the change of F for each variable as a list
SDAt <- function(U1, U0, L1, L0, Y1, Y0){
  con_U <- avg(((U1 - U0) %*% L1 %*% Y1), 
               ((U1 - U0) %*% L0 %*% Y0))
  con_L <- avg((U0 %*% (L1 - L0) %*% Y1),   
               (U1 %*% (L1 - L0) %*% Y0))
  con_Y <- avg((U0 %*% L0 %*% (Y1 - Y0)),   
               (U1 %*% L1 %*% (Y1 - Y0)))
  delta_F <- con_U + con_L + con_Y
  return(list(delta_F = delta_F, con_U = con_U, con_L = con_L, con_Y = con_Y))
}

# check test function -> it works!
delta_Ft <- SDAt(U_list[[3]], U_list[[2]], 
                 L_list1[[3]], L_list1[[2]], 
                 Y_list[[3]], Y_list[[2]])

all.equal(F_soll[[2]], delta_Ft[["delta_F"]])

# test loop for SDA function with list inputs
loopt <- list()
for (i in 2:3){
  loopt[[i]] <- SDAt(U_list[[i]], U_list[[(i-1)]], 
                     L_list1[[i]], L_list1[[(i-1)]],
                     Y_list[[i]], Y_list[[(i-1)]])
}
all.equal(F_soll[[2]], loopt[[3]][["delta_F"]])

load("U_list.RData")
load("lpro_list.RData")
load("lsup_list.RData")
load("llev_list.RData")
load("ypro_list.RData")
load("ysup_list.RData")
load("ylev_list.RData")
load("G_list.RData")
load("P_list.RData")

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

#  function works, but too many NaNs...
test_dec <- SDA_dec(U_list[[3]], U_list[[2]], 
                    lpro[[3]], lpro[[2]], 
                    lsup[[3]], lsup[[2]],
                    llev[[3]], llev[[2]],
                    ypro[[3]], ypro[[2]],
                    ysup[[3]], ysup[[2]],
                    ylev[[3]], ylev[[2]], 
                    G[[3]], G[[2]],
                    P[[3]], P[[2]])

loop_dec1 <- list()
for (i in 2:3){
  loop_dec1[[i]] <- SDA_dec(U_list[[i]], U_list[[(i-1)]], 
                            lpro[[i]], lpro[[(i-1)]], 
                            lsup[[i]], lsup[[(i-1)]],
                            llev[[i]], llev[[(i-1)]],
                            ypro[[i]], ypro[[(i-1)]],
                            ysup[[i]], ysup[[(i-1)]],
                            ylev[[i]], ylev[[(i-1)]], 
                            G[[i]], G[[(i-1)]],
                            P[[i]], P[[(i-1)]])
}