library(tidyverse)
memory.limit()
memory.limit(100000)

rm(list = ls()); gc()


#----------------------------------------------------------------------------
#
# DECOMPOSITION OF L AND Y
#
#----------------------------------------------------------------------------

#-------------------------------
# decompose L
#-------------------------------

load("C:/Users/Zoe/Desktop/temp/L_list.RData")

# level of total input requirements (Ljs)
llev <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = 24830, ncol = 24830, byrow = TRUE)

save(llev_exp, file = "llev_list.RData")

# distribution of supplier countries (Ljrs/Ljs)
ljrs <- lapply(L_list, as.data.frame) %>% 
  lapply(split.data.frame, rep(1:191, each = 130)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 191, ncol = 24830, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 130), ])

lsup <- map2(ljrs, llev, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

save(lsup, file = "lsup_list.RData")

# distribution of intermediate products (Lijrs/Ljrs)
lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

save(lpro, file = "lpro_list.RData")

#-------------------------------
# decompose Y
#-------------------------------

load("C:/Users/Zoe/Desktop/temp/Y_list.RData")

# total final demand for food (Ys)
ys <- lapply(Y_list, colSums) %>% 
  lapply(matrix, nrow = 24830, ncol = 191, byrow = TRUE)

# distribution of supplier countries (Yrs/Ys)
yrs <- lapply(Y_list, split.data.frame, rep(1:191, each = 130)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 191, ncol = 191, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 130), ])

ysup <- map2(yrs, ys, ~.x / .y)

# distribution of products (Yirs/Yrs)
ypro <- map2(Y_list, yrs, ~.x / .y)

load("C:/Users/Zoe/Desktop/temp/GDP_deflated.RData")
load("C:/Users/Zoe/Desktop/temp/GDP_per_capita.RData")
load("C:/Users/Zoe/Desktop/temp/Population.RData")

gdp <- map(gdp_all, ~.x[rep(1:191, each = 130)])
  map(~ matrix(.x, nrow = length(.x), ncol = 191))


# gdp <- gdp[[28]][1:10, ]
# gdp1 <- rep(gdp, each = 130)
# gdp_exp <- matrix(gdp1, nrow = length(gdp1), ncol = 10)

ylev <- map2(ys_exp, gdp_exp, ~.x / .y)

# level of final demand per GDP (ys/GDP)
# ylev <- ys_exp / gdp_exp

G <- list(gdp_per_capita[[26]], gdp_per_capita[[27]], gdp_per_capita[[28]])
G1 <- map(G, ~.[1:10, ])
G2 <- lapply(G1, rep, each = 130)
G_exp <- list()
for (i in seq_along(1:length(G2))){
  G_exp[[i]] <- matrix(G2[[i]], nrow = length(G2[[i]]), ncol = 10)
}

# GDP per capita
# G <- gdp_per_capita[[28]][1:10, ]
# G1 <- rep(G, each = 130)
# G_exp <- matrix(G1, nrow = length(G1), ncol = 10)

P <- list(pop[[26]], pop[[27]], pop[[28]])
P1 <- map(P, ~.[1:10, ])
P2 <- lapply(P1, rep, each = 130)
P_exp <- list()
for (i in seq_along(1:3)){
  P_exp[[i]] <- matrix(P2[[i]], nrow = length(P2[[i]]), ncol = 10)
}

# population
# P <- pop[[28]][1:10, ]
# P1 <- rep(P, each = 130)
# P_exp <- matrix(P1, nrow = length(P1), ncol = 10)

Y_dec2 <- pmap(list(ypro, ysup_exp, ylev, G_exp, P_exp), 
               ~..1 * ..2 * ..3 * ..4 * ..5)
all.equal(Y_dec2, Y_sample)

# Y_dec2 <- ypro * ysup_exp * ylev * G_exp * P_exp
# all.equal(Y, Y_dec2)

save(gdp_exp, file = "gdp_sample.RData")
save(P_exp, file = "P_sample.RData")
save(G_exp, file = "G_sample.RData")
save(ypro, file = "ypro_sample.RData")
save(ysup_exp, file = "ysup_sample.RData")
save(ylev, file = "ylev_sample.RData")