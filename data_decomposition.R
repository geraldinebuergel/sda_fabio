library(tidyverse)

rm(list = ls()); gc()

#----------------------------------------------------------------------------
#
# DECOMPOSITION OF L AND Y
#
#----------------------------------------------------------------------------

#-------------------------------
# decompose L
#-------------------------------

#load("L_list.RData")

# level of total input requirements (Ljs)
llev <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = 24700, ncol = 24700, byrow = TRUE)

save(llev, file = "llev_list.RData")

# distribution of supplier countries (Ljrs/Ljs)
ljrs <- lapply(L_list, as.data.frame) %>% 
  lapply(split.data.frame, rep(1:190, each = 130)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 190, ncol = 24700, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 130), ])

save(ljrs, file = "ljrs.RData")

lsup <- map2(ljrs, llev, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(lsup, file = "lsup_list.RData")

# distribution of intermediate products (Lijrs/Ljrs)
lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(lpro, file = "lpro_list.RData")

#-------------------------------
# decompose Y
#-------------------------------

load("Y_list.RData")

# total final demand for food (Ys)
ys <- lapply(Y_list, colSums) %>% 
  lapply(matrix, nrow = 24700, ncol = 190, byrow = TRUE)

# distribution of supplier countries (Yrs/Ys)
yrs <- lapply(Y_list, split.data.frame, rep(1:190, each = 130)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 190, ncol = 190, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 130), ])

ysup <- map2(yrs, ys, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ysup, file = "ysup_list.RData")

# distribution of products (Yirs/Yrs)
ypro <- map2(Y_list, yrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ypro, file = "ypro_list.RData")

load("GDP.RData")
load("Population.RData")

gdp <- map(gdp, ~.x[rep(1:190, each = 130)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = 190))

# level of final demand per GDP (Ys/GDP)
ylev <- map2(ys, gdp, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ylev, file = "ylev_list.RData")

# Population (P)
P <- map(pop, ~.x[rep(1:190, each = 130)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = 190))

save(P, file = "P_list.RData")

# GDP per capita (G)
G <- map2(gdp, P, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(G, file = "G_list.RData")

Y_dec <- pmap(list(ypro, ysup, ylev, G, P), ~..1 * ..2 * ..3 * ..4 * ..5)
rapply(Y_dec, function(x) ifelse(!is.finite(x), 0, x), how = "list")
all.equal(Y_list, Y_dec)
