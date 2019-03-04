library(tidyverse)
memory.limit()
memory.limit(64000)

rm(list = ls()); gc()


#------------------------------------------
#
# DECOMPOSITION OF L AND Y
#
#------------------------------------------

# divide each element of a matrix by its column sum
divide <- function(x) { t(t(x) / rowSums(t(x))) }

#-------------------------------
# decompose L
#-------------------------------

load("C:/Users/Zoe/Desktop/temp/L_sample.RData")

llev <- lapply(L_sample, colSums)
llev_expanded <- lapply(llev, matrix, nrow = 1300, ncol = 1300, byrow = TRUE)

# # level of total input requirements (Ljs)
# llev <- colSums(L)
# llev_expanded <- matrix(llev, nrow = 1300, ncol = length(llev), byrow = TRUE)

ljrs1 <- lapply(L_sample, as.data.frame)
ljrs2 <- lapply(ljrs1, split.data.frame, rep(1:10, each = 130))
ljrs3 <- lapply(ljrs2, lapply, colSums)
ljrs <- list()
for (i in seq_along(1:length(ljrs3))) {
  ljrs[[i]] <- matrix(unlist(ljrs3[[i]]), nrow = 10, ncol = 1300, byrow = TRUE)
}
ljrs_expanded <- list()
for (i in seq_along(1:length(ljrs))){
  ljrs_expanded[[i]] <- ljrs[[i]][rep(1:nrow(ljrs[[i]]), each = 130), ]
}
lsup1_expanded <- map2(ljrs_expanded, llev_expanded, ~.x / .y)
lsup_expanded <- rapply(lsup1_expanded, function(x) ifelse(is.nan(x),0,x), how="list")

# # distribution of supplier countries (Ljrs/Ljs)
# L_list <- split.data.frame(L, rep(1:10, each = 130))
# ljrs_list <- map(L_list, colSums) # map_dfr() should return data frame
# ljrs <- do.call(rbind, ljrs_list) 
# lsup <- divide(ljrs)
# lsup[is.nan(lsup)] <- 0
# lsup_expanded <-  lsup[rep(1:nrow(lsup), each = 130), ] 

lpro1 <- map2(L_sample, ljrs_expanded, ~.x / .y)
lpro <- rapply(lpro1_expanded, function(x) ifelse(is.nan(x),0,x), how="list")

# # distribution of intermediate products (Lijrs/Ljrs)
# lpro_list <- map(L_list, divide) # elements are matrices
# lpro <- do.call(rbind, lpro_list)
# lpro[is.nan(lpro)] <- 0

# combine lpro, lsup and llev back to L
L_dec <- pmap(list(lpro, lsup_expanded, llev_expanded), ~ ..1 * ..2 * ..3)
all.equal(L_dec, L_sample)

save(lpro, file = "lpro_sample.RData")
save(lsup_expanded, file = "lsup_sample.RData")
save(llev_expanded, file = "llev_sample.RData")

#-------------------------------
# decompose Y
#-------------------------------

load("C:/Users/Zoe/Desktop/temp/Y_sample.RData")
  
# select columns with final demand for food only
# Y_df_Food <- as.data.frame(Y) %>% 
#  dplyr::select(contains("Food"))
# Y <- as.matrix(Y_df_Food)

ys <- lapply(Y_sample, colSums)
ys_expanded <- lapply(ys, matrix, nrow = 1300, ncol = 10, byrow = TRUE)

# ys <- as.matrix(colSums(Y))
# ys_expanded <- matrix(ys, nrow = 1300, ncol = length(ys), byrow = TRUE)

yrs1 <- lapply(Y_sample, split.data.frame, rep(1:10, each = 130))
yrs2 <- lapply(yrs1, lapply, colSums)
yrs <- list()
for (i in seq_along(1:length(yrs2))){
  yrs[[i]] <- matrix(unlist(yrs2[[i]]), nrow = 10, ncol = 10, byrow = TRUE)
}
yrs_expanded <- list()
for (i in seq_along(1:length(yrs))){
  yrs_expanded[[i]] <- yrs[[i]][rep(1:nrow(yrs[[i]]), each = 130), ]
}

# yrs_list <- split.data.frame(Y_df_Food, rep(1:10, each = 130))
# yrs_list_sum <- map(yrs_list, colSums)
# yrs <- do.call(rbind, yrs_list_sum) %>% 
#   as.matrix()
# yrs_expanded <- yrs[rep(1:nrow(yrs), each = 130), ] 

ysup <- lapply(yrs, divide)
ysup_expanded <- list()
for (i in seq_along(1:length(ysup))){
  ysup_expanded[[i]] <- ysup[[i]][rep(1:nrow(ysup[[i]]), each = 130), ]
}

# # distribution of supplier countries (yrs/ys)
# ysup <- divide(yrs)
# ysup_expanded <- ysup[rep(1:nrow(ysup), each = 130), ] 

ypro <- map2(Y_sample, yrs_expanded, ~ .x / .y)

# distribution of products (yirs/yrs)
# ypro <- Y / yrs_expanded

Y_dec <- pmap(list(ypro, ysup_expanded, ys_expanded), ~ ..1 * ..2 * ..3)
all.equal(Y_dec, Y_sample)

# # check
# Y_dec <- ypro * ysup_expanded * ys_expanded
# all.equal(Y_dec, Y)

load("C:/Users/Zoe/Desktop/FABIO/GDP_deflated.RData")
load("C:/Users/Zoe/Desktop/FABIO/GDP_per_capita.RData")
load("C:/Users/Zoe/Desktop/FABIO/Population.RData")

gdp1 <- list(gdp[[26]], gdp[[27]], gdp[[28]])
gdp2 <- map(gdp1, ~.[1:10, ])
gdp3 <- lapply(gdp2, rep, each = 130)
gdp_expanded <- list()
for (i in seq_along(1:length(gdp3))){
  gdp_expanded[[i]] <- matrix(gdp3[[i]], nrow = length(gdp3[[i]]), ncol = 10)
}

# gdp <- gdp[[28]][1:10, ]
# gdp1 <- rep(gdp, each = 130)
# gdp_expanded <- matrix(gdp1, nrow = length(gdp1), ncol = 10)

ylev <- map2(ys_expanded, gdp_expanded, ~.x / .y)

# level of final demand per GDP (ys/GDP)
# ylev <- ys_expanded / gdp_expanded

G <- list(gdp_per_capita[[26]], gdp_per_capita[[27]], gdp_per_capita[[28]])
G1 <- map(G, ~.[1:10, ])
G2 <- lapply(G1, rep, each = 130)
G_expanded <- list()
for (i in seq_along(1:length(G2))){
  G_expanded[[i]] <- matrix(G2[[i]], nrow = length(G2[[i]]), ncol = 10)
}

# GDP per capita
# G <- gdp_per_capita[[28]][1:10, ]
# G1 <- rep(G, each = 130)
# G_expanded <- matrix(G1, nrow = length(G1), ncol = 10)

P <- list(pop[[26]], pop[[27]], pop[[28]])
P1 <- map(P, ~.[1:10, ])
P2 <- lapply(P1, rep, each = 130)
P_expanded <- list()
for (i in seq_along(1:3)){
  P_expanded[[i]] <- matrix(P2[[i]], nrow = length(P2[[i]]), ncol = 10)
}

# population
# P <- pop[[28]][1:10, ]
# P1 <- rep(P, each = 130)
# P_expanded <- matrix(P1, nrow = length(P1), ncol = 10)

Y_dec2 <- pmap(list(ypro, ysup_expanded, ylev, G_expanded, P_expanded), 
               ~..1 * ..2 * ..3 * ..4 * ..5)
all.equal(Y_dec2, Y_sample)

# Y_dec2 <- ypro * ysup_expanded * ylev * G_expanded * P_expanded
# all.equal(Y, Y_dec2)

save(gdp_expanded, file = "gdp_sample.RData")
save(P_expanded, file = "P_sample.RData")
save(G_expanded, file = "G_sample.RData")
save(ypro, file = "ypro_sample.RData")
save(ysup_expanded, file = "ysup_sample.RData")
save(ylev, file = "ylev_sample.RData")