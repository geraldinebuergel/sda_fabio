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

load("L_list.RData")

# level of total input requirements (Ljs)
llev <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = 24830, ncol = 24830, byrow = TRUE)

#save(llev, file = "llev_list.RData")

# distribution of supplier countries (Ljrs/Ljs)
ljrs <- lapply(L_list, as.data.frame) %>% 
  lapply(split.data.frame, rep(1:191, each = 130)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 191, ncol = 24830, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 130), ])

lsup <- map2(ljrs, llev, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

#save(lsup, file = "lsup_list.RData")

# distribution of intermediate products (Lijrs/Ljrs)
lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

#save(lpro, file = "lpro_list.RData")

#-------------------------------
# decompose Y
#-------------------------------

load("Y_list.RData")

# total final demand for food (Ys)
ys <- lapply(Y_list, colSums) %>% 
  lapply(matrix, nrow = 24830, ncol = 191, byrow = TRUE)

# distribution of supplier countries (Yrs/Ys)
yrs <- lapply(Y_list, split.data.frame, rep(1:191, each = 130)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 191, ncol = 191, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 130), ])

ysup <- map2(yrs, ys, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

#save(ysup, file = "ysup_list.RData")

# distribution of products (Yirs/Yrs)
ypro <- map2(Y_list, yrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

#save(ypro, file = "ypro_list.RData")

load("GDP.RData")
load("Population.RData")

gdp <- map(gdp, ~.x[rep(1:191, each = 130)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = 191))
#gdp <- list(gdp[[26]], gdp[[27]], gdp[[28]])

# level of final demand per GDP (Ys/GDP)
ylev <- map2(ys, gdp, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

#save(ylev, file = "ylev_list.RData")

# Population (P)
P <- map(pop, ~.x[rep(1:191, each = 130)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = 191))
#P <- list(P[["2011"]], P[["2012"]], P[["2013"]])

# GDP per capita (G)
G <- map2(gdp, P, ~.x / .y) %>% 
  rapply(function(x) ifelse(is.nan(x), 0, x), how = "list")

Y_dec <- pmap(list(ypro, ysup, ylev, G, P), ~..1 * ..2 * ..3 * ..4 * ..5)
all.equal(Y_dec, Y_list) # Y_dec has NA values somewhere