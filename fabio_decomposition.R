library(tidyverse)

rm(list = ls()); gc()

#----------------------------------------------------------------------------
#
# DECOMPOSITION OF L AND Y
#
#----------------------------------------------------------------------------

nocol <- 190
nopro <- 130
norow <- nocol * nopro

#-------------------------------
# decompose L
#-------------------------------

load("L_list.RData")

# distribution of supplier countries (Ljrs/Ljs)
ljrs <- lapply(L_list, as.data.frame) %>% 
  lapply(split.data.frame, rep(1:nocol, each = nopro)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = nocol, ncol = norow, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = nopro), ])

save(ljrs, file = "ljrs.RData")

# distribution of intermediate products (Lijrs/Ljrs)
lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(lpro, file = "lpro_list.RData")

# level of total input requirements (Ljs)
llev <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = norow, ncol = norow, byrow = TRUE)

save(llev, file = "llev_list.RData")

rm(L_list); gc()

lsup <- map2(ljrs, llev, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(lsup, file = "lsup_list.RData")

rm(ljrs); gc()

#-------------------------------
# decompose Y
#-------------------------------

load("Y_list.RData")

# total final demand for food (Ys)
ys <- lapply(Y_list, colSums) %>% 
  lapply(matrix, nrow = norow, ncol = nocol, byrow = TRUE)

# distribution of supplier countries (Yrs/Ys)
yrs <- lapply(Y_list, split.data.frame, rep(1:nocol, each = nopro)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = nocol, ncol = nocol, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = nopro), ])

ysup <- map2(yrs, ys, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ysup, file = "ysup_list.RData")

# distribution of products (Yirs/Yrs)
ypro <- map2(Y_list, yrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ypro, file = "ypro_list.RData")

load("Population.RData")

# Population (P)
P <- map(pop, ~.x[rep(1:nocol, each = nopro)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = nocol))

save(P, file = "P_list.RData")

# level of final demand per capita (Ys/GDP)
ylev <- map2(ys, P, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ylev, file = "ylev_list.RData")

Y_dec <- pmap(list(ypro, ysup, ylev, P), ~..1 * ..2 * ..3 * ..4) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
all.equal(Y_list, Y_dec)
