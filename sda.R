library(tidyverse)
library(Matrix)

rm(list = ls()); gc()

avg <- function(x, y){(0.5 * x) + (0.5 * y)}

#---------------------------------
# 
# SDA FUNCTION
#
#---------------------------------

# rm(loop01)
# llev[[1]] <- NULL
# lpro[[1]] <- NULL
# lsup[[1]] <- NULL
# gc()
# a <- 3
b <- 26:28
# source("L_helper.R")
load("U_list.RData")
U_list <- U_list[b]
load("Y_list.RData")
Y_list <- Y_list[b]
load("ypro_list_p.RData")
ypro <- ypro[b]
load("ysup_list_p.RData")
ysup <- ysup[b]
load("ylev_list_p.RData")
ylev <- ylev[b]
load("G_list.RData")
G <- G[b]
load("P_list.RData")
P <- P[b]

# loop SDA with decomposed variables
loop15 <- list()
for (i in 2:3){
  loop15[[i]] <- SDA_dec_p(U_list[[i]], U_list[[(i-1)]],
                        lpro[[i]], lpro[[(i-1)]],
                        lsup[[i]], lsup[[(i-1)]],
                        llev[[i]], llev[[(i-1)]],
                        ypro[[i]], ypro[[(i-1)]],
                        ysup[[i]], ysup[[(i-1)]],
                        ylev[[i]], ylev[[(i-1)]],
                        G[[i]], G[[(i-1)]],
                        P[[i]], P[[(i-1)]])
}
save(loop15, file = "loop15_p.RData")

# SDA function with decomposed inputs
SDA_dec <- function(U1, U0, lpro1, lpro0, lsup1, lsup0, llev1, llev0, 
                    ypro1, ypro0, ysup1, ysup0, ylev1, ylev0, G1, G0, P1, P0){
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
  return(list(delta_F = delta_F, con_U = con_U, con_lpro = con_lpro, 
              con_lsup = con_lsup, con_llev = con_llev, con_ypro = con_ypro, 
              con_ysup = con_ysup, con_ylev = con_ylev, con_G = con_G, con_P = con_P))
}

#---------------------------------------------------------------
# TESTS
#---------------------------------------------------------------

# test with 3 variables
load("U_list.RData")
load("L_list.RData")
load("Y_list.RData")

# reference for what delta F should be
F_2011 <- U_list[[1]] %*% L_list[[1]] %*% Y_list[[1]]
F_2012 <- U_list[[2]] %*% L_list[[2]] %*% Y_list[[2]]
F_2013 <- U_list[[3]] %*% L_list[[3]] %*% Y_list[[3]]
F_soll2 <- sum(F_2012) - sum(F_2011)
F_soll3 <- sum(F_2013) - sum(F_2012)
F_soll <- list(F_soll2, F_soll3)

#------------------------------------------------------------
# test with 3 variables -> f=uLY
#------------------------------------------------------------

SDA <- function(U1, U0, L1, L0, Y1, Y0){
  con_U <- avg(((U1 - U0) %*% L1 %*% Y1),
               ((U1 - U0) %*% L0 %*% Y0))
  con_L <- avg((U0 %*% (L1 - L0) %*% Y1),
               (U1 %*% (L1 - L0) %*% Y0))
  con_Y <- avg((U0 %*% L0 %*% (Y1 - Y0)),
               (U1 %*% L1 %*% (Y1 - Y0)))
  delta_F <- con_U + con_L + con_Y
  return(list(delta_F = delta_F, con_U = con_U, con_L = con_L, con_Y = con_Y))
}

fabio <- "/mnt/nfs_fineprint/tmp/fabio/"

nocol <- 190
nopro <- 130
norow <- nocol * nopro

avg <- function(x, y){(0.5 * x) + (0.5 * y)}

fabio_sda <- function(i){
  
  print(i-1)
  
  b <- c(i-1, i)
  
  L_list <- list.files(path = fabio, pattern = "*_L_price.rds")
  L_list <- L_list[b] %>% 
    map(~ readRDS(paste0(fabio,.x))) %>%
    lapply(as.data.frame) %>% 
    map(~.x[1:norow, 1:norow]) %>% 
    lapply(as.matrix)
  
  load("U_list.RData")
  U_list <- U_list[b]
  load("Y_list.RData")
  Y_list <- Y_list[b]

  loop <- SDA(U_list[[2]], U_list[[1]],
              L_list[[2]], L_list[[1]],
              Y_list[[2]], Y_list[[1]])
  
  save(loop, file = paste0("loop_", i-1,".RData"))
}

for (i in 2:28){
  
  fabio_sda(i = i)
  
}

#----------------------------------------------------------
# test with 4 variables -> f=uLYP
#----------------------------------------------------------

Y_list_P <- map2(Y_list, P, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(Y_list_P, file = "Y_List_P.RData")

SDA_P <- function(U1, U0, L1, L0, Y1, Y0, P1, P0){
  con_U <- avg(((U1 - U0) %*% L1 %*% (Y1 * P1)),
               ((U1 - U0) %*% L0 %*% (Y0 * P0)))
  con_L <- avg((U0 %*% (L1 - L0) %*% (Y1 * P1)),
               (U1 %*% (L1 - L0) %*% (Y0 * P0)))
  con_Y <- avg((U0 %*% L0 %*% ((Y1 - Y0) * P1)),
               (U1 %*% L1 %*% ((Y1 - Y0) * P0)))
  con_P <- avg((U0 %*% L0 %*% (Y0 * (P1 - P0))),
               (U1 %*% L1 %*% (Y1 * (P1 - P0))))
  delta_F <- con_U + con_L + con_Y + con_P
  return(list(delta_F = delta_F, con_U = con_U, con_L = con_L, con_Y = con_Y, 
              con_P = con_P))
}

fabio <- "/mnt/nfs_fineprint/tmp/fabio/"

nocol <- 190
nopro <- 130
norow <- nocol * nopro

avg <- function(x, y){(0.5 * x) + (0.5 * y)}

fabio_sda <- function(i){
  
  print(i-1)
  
  b <- c(i-1, i)
  
  L_list <- list.files(path = fabio, pattern = "*_L_price.rds")
  L_list <- L_list[b] %>% 
    map(~ readRDS(paste0(fabio,.x))) %>%
    lapply(as.data.frame) %>% 
    map(~.x[1:norow, 1:norow]) %>% 
    lapply(as.matrix)
  
  load("U_list.RData")
  U_list <- U_list[b]
  load("Y_list_P.RData")
  Y_list_P <- Y_list_P[b]
  load("P_list.RData")
  P <- P[b]
  
  loop_P <- SDA_P(U_list[[2]], U_list[[1]],
                  L_list[[2]], L_list[[1]],
                  Y_list_P[[2]], Y_list_P[[1]],
                  P[[2]], P[[1]])
  
  save(loop_P, file = paste0("loop_P_", i-1,".RData"))
}

for (i in 2:28){
  
  fabio_sda(i = i)
  
}

# test with 5 variables

Y_list <- map2(Y_list, gdp, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

SDAt <- function(U1, U0, L1, L0, Y1, Y0, G1, G0, P1, P0){
  con_U <- avg(((U1 - U0) %*% L1 %*% (Y1 * G1 * P1)),
               ((U1 - U0) %*% L0 %*% (Y0 * G0 * P0)))
  con_L <- avg((U0 %*% (L1 - L0) %*% (Y1 * G1 * P1)),
               (U1 %*% (L1 - L0) %*% (Y0 * G0 * P0)))
  con_Y <- avg((U0 %*% L0 %*% ((Y1 - Y0) * G1 * P1)),
               (U1 %*% L1 %*% ((Y1 - Y0) * G0 * P0)))
  con_G <- avg((U0 %*% L0 %*% (Y0 * (G1 - G0) * P1)),
               (U1 %*% L1 %*% (Y1 * (G1 - G0) * P0)))
  con_P <- avg((U0 %*% L0 %*% (Y0 * G0 * (P1 - P0))),
               (U1 %*% L1 %*% (Y1 * G1 * (P1 - P0))))
  delta_F <- con_U + con_L + con_Y + con_G + con_P
  return(list(delta_F = delta_F, con_U = con_U, con_L = con_L, con_Y = con_Y, con_G = con_G, con_P = con_P))
}

loopt <- list()
for (i in 2:3){
  loopt[[i]] <- SDAt(U_list[[i]], U_list[[(i-1)]],
                     L_list[[i]], L_list[[(i-1)]],
                     Y_list[[i]], Y_list[[(i-1)]],
                     G[[i]], G[[(i-1)]],
                     P[[i]], P[[(i-1)]])
}
all.equal(F_soll[[2]], sum(loopt[[3]][["delta_F"]])) # -> "Mean relative difference: 7.830697e-05" -> same as before

save(loopt, file = "loop_uLYGP.RData")

#-------------------------------------------------------------
# SDA WITHOUT GDP (8 VARIABLES)
#-------------------------------------------------------------

# SDA function without GDP
SDA_dec <- function(U1, U0, lpro1, lpro0, lsup1, lsup0, llev1, llev0,
                   ypro1, ypro0, ysup1, ysup0, ylev1, ylev0, P1, P0){
 con_U <- avg((U1 - U0) %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * ysup1 * ylev1 * P1),
              (U1 - U0) %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * ysup0 * ylev0 * P0))
 con_lpro <- avg(U0 %*% ((lpro1 - lpro0) * lsup1 * llev1) %*% (ypro1 * ysup1 * ylev1 * P1),
                 U1 %*% ((lpro1 - lpro0) * lsup0 * llev0) %*% (ypro0 * ysup0 * ylev0 * P0))
 con_lsup <- avg(U0 %*% (lpro0 * (lsup1 - lsup0) * llev1) %*% (ypro1 * ysup1 * ylev1 * P1),
                 U1 %*% (lpro1 * (lsup1 - lsup0) * llev0) %*% (ypro0 * ysup0 * ylev0 * P0))
 con_llev <- avg(U0 %*% (lpro0 * lsup0 * (llev1 - llev0)) %*% (ypro1 * ysup1 * ylev1 * P1),
                 U1 %*% (lpro1 * lsup1 * (llev1 - llev0)) %*% (ypro0 * ysup0 * ylev0 * P0))
 con_ypro <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% ((ypro1 - ypro0) * ysup1 * ylev1 * P1),
                 U1 %*% (lpro1 * lsup1 * llev1) %*% ((ypro1 - ypro0) * ysup0 * ylev0 * P0))
 con_ysup <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * (ysup1 - ysup0) * ylev1 * P1),
                 U1 %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * (ysup1 - ysup0) * ylev0 * P0))
 con_ylev <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * ysup0 * (ylev1 - ylev0) * P1),
                 U1 %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * ysup1 * (ylev1 - ylev0) * P0))
 con_P <- avg(U0 %*% (lpro0 * lsup0 * llev0) %*% (ypro0 * ysup0 * ylev0 * (P1 - P0)),
              U1 %*% (lpro1 * lsup1 * llev1) %*% (ypro1 * ysup1 * ylev1 * (P1 - P0)))
 delta_F <- con_U + con_lpro + con_lsup + con_llev + con_ypro + con_ysup +
            con_ylev + con_P
 return(list(delta_F = delta_F, con_U = con_U, con_lpro = con_lpro,
             con_lsup = con_lsup, con_llev = con_llev, con_ypro = con_ypro,
             con_ysup = con_ysup, con_ylev = con_ylev, con_P = con_P))
}

fabio <- "/mnt/nfs_fineprint/tmp/fabio/"

nocol <- 190
nopro <- 130
norow <- nocol * nopro

avg <- function(x, y){(0.5 * x) + (0.5 * y)}

fabio_sda <- function(i){
  
  print(i-1)
  
  b <- c(i-1, i)
  
  L_list <- list.files(path = fabio, pattern = "*_L_price.rds")
  L_list <- L_list[b] %>% 
    map(~ readRDS(paste0(fabio,.x))) %>%
    lapply(as.data.frame) %>% 
    map(~.x[1:norow, 1:norow]) %>% 
    lapply(as.matrix)
  
  ljrs <- lapply(L_list, as.data.frame) %>% 
    lapply(split.data.frame, rep(1:nocol, each = nopro)) %>% 
    lapply(lapply, colSums) %>% 
    map(~ matrix(unlist(.x), nrow = nocol, ncol = norow, byrow = TRUE)) %>% 
    map(~ .x[rep(1:nrow(.x), each = nopro), ])
  
  lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
    rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
  
  llev <- lapply(L_list, colSums) %>% 
    lapply(matrix, nrow = norow, ncol = norow, byrow = TRUE)
  
  lsup <- map2(ljrs, llev, ~.x / .y) %>% 
    rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
  
  load("U_list.RData")
  U_list <- U_list[b]
  load("ypro_list.RData")
  ypro <- ypro[b]
  load("ysup_list.RData")
  ysup <- ysup[b]
  load("ylev_list.RData")
  ylev <- ylev[b]
  load("P_list.RData")
  P <- P[b]
  
  loop_n <- SDA_dec(U_list[[2]], U_list[[1]],
                    lpro[[2]], lpro[[1]],
                    lsup[[2]], lsup[[1]],
                    llev[[2]], llev[[1]],
                    ypro[[2]], ypro[[1]],
                    ysup[[2]], ysup[[1]],
                    ylev[[2]], ylev[[1]],
                    P[[2]], P[[1]])
  
  save(loop_n, file = paste0("loop_n_", i-1,".RData"))
}

for (i in 27:28){
  
  fabio_sda(i = i)
  
}
  
#   print(i-1)
#   
#   b <- c(i-1, i)
# 
#   L_list <- list.files(path = fabio, pattern = "*_L_price.rds")
#   L_list <- L_list[b] %>% 
#     map(~ readRDS(paste0(fabio,.x))) %>%
#     lapply(as.data.frame) %>% 
#     map(~.x[1:norow, 1:norow]) %>% 
#     lapply(as.matrix)
#   
#   ljrs <- lapply(L_list, as.data.frame) %>% 
#     lapply(split.data.frame, rep(1:nocol, each = nopro)) %>% 
#     lapply(lapply, colSums) %>% 
#     map(~ matrix(unlist(.x), nrow = nocol, ncol = norow, byrow = TRUE)) %>% 
#     map(~ .x[rep(1:nrow(.x), each = nopro), ])
#   
#   lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
#     rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
#   
#   llev <- lapply(L_list, colSums) %>% 
#     lapply(matrix, nrow = norow, ncol = norow, byrow = TRUE)
#   
#   lsup <- map2(ljrs, llev, ~.x / .y) %>% 
#     rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
#   
#   load("U_list.RData")
#   U_list <- U_list[b]
#   load("ypro_list.RData")
#   ypro <- ypro[b]
#   load("ysup_list.RData")
#   ysup <- ysup[b]
#   load("ylev_list.RData")
#   ylev <- ylev[b]
#   load("P_list.RData")
#   P <- P[b]
#   
#   loop_n <- SDA_dec(U_list[[2]], U_list[[1]],
#                           lpro[[2]], lpro[[1]],
#                           lsup[[2]], lsup[[1]],
#                           llev[[2]], llev[[1]],
#                           ypro[[2]], ypro[[1]],
#                           ysup[[2]], ysup[[1]],
#                           ylev[[2]], ylev[[1]],
#                           P[[2]], P[[1]])
#   
#   save(loop_n, file = paste0("loop_n_", i-1,".RData"))
#   
# }
