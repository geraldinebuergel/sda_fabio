library(tidyverse)

rm(list = ls()); gc()

#----------------------------------------------------------------------------
#
# DECOMPOSITION OF L AND Y
#
#----------------------------------------------------------------------------

norow <- 22800
nocol <- 190

#-------------------------------
# decompose L
#-------------------------------

load("L_list.RData")

# level of total input requirements (Ljs)
llev <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = norow, ncol = norow, byrow = TRUE)

save(llev, file = "llev_list_c.RData")

# distribution of supplier countries (Ljrs/Ljs)
ljrs <- lapply(L_list, as.data.frame) %>% 
  lapply(split.data.frame, rep(1:nocol, each = 120)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = nocol, ncol = norow, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 120), ])

#save(ljrs, file = "ljrs.RData")

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
  lapply(matrix, nrow = norow, ncol = nocol, byrow = TRUE)

# distribution of supplier countries (Yrs/Ys)
yrs <- lapply(Y_list, split.data.frame, rep(1:nocol, each = 120)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = nocol, ncol = nocol, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 120), ])

ysup <- map2(yrs, ys, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ysup, file = "ysup_list.RData")

# distribution of products (Yirs/Yrs)
ypro <- map2(Y_list, yrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ypro, file = "ypro_list.RData")

load("GDP.RData")
load("Population.RData")

gdp <- map(gdp, ~.x[rep(1:nocol, each = 120)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = nocol))

# level of final demand per GDP (Ys/GDP)
ylev <- map2(ys, gdp, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ylev, file = "ylev_list.RData")

# Population (P)
P <- map(pop, ~.x[rep(1:nocol, each = 120)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = nocol))

save(P, file = "P_list.RData")

# GDP per capita (G)
G <- map2(gdp, P, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(G, file = "G_list.RData")

Y_dec <- pmap(list(ypro, ysup, ylev, G, P), ~..1 * ..2 * ..3 * ..4 * ..5) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
all.equal(Y_list, Y_dec)
