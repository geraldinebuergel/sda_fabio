library(tidyverse)
library(Matrix)

rm(list = ls()); gc()

#----------------------------------------------------------------------------
#
# DECOMPOSITION OF L AND Y (HYBRID)
#
#----------------------------------------------------------------------------

#-------------------------------
# decompose L
#-------------------------------

#load("L_list_hybrid.RData")

# level of total input requirements (Ljs)
llev <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = 31600, ncol = 31600, byrow = TRUE)

# nr <- nc <- 31600
# llev2 <- lapply(llev, function(x){dimnames(x) <- list(1:nr, 1:nc)})
# llev3 <- lapply(llev2, function(x){as(x, "dgCMatrix")})

save(llev, file = "llev_list_hybrid.RData")

# distribution of supplier countries (Ljrs/Ljs)
ljrs1 <- map(L_list, ~ .x[1:22800, ]) %>% 
    map(split, rep(1:190, each = 120)) %>% 
    lapply(lapply, function(x) matrix(x, 120, 31600)) %>% 
    lapply(lapply, colSums) %>% 
    map(~ matrix(unlist(.x), nrow = 190, ncol = 31600, byrow = TRUE)) %>% 
    map(~ .x[rep(1:nrow(.x), each = 120), ])

ljrs2 <- map(L_list, ~ .x[22801:31600, ]) %>% 
  map(split, rep(1:44, each = 200)) %>% 
  lapply(lapply, function(x) matrix(x, 200, 31600)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 44, ncol = 31600, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 200), ])

ljrs <- map2(ljrs1, ljrs2, ~rbind(.x, .y))

rm(ljrs1, ljrs2); gc()

save(ljrs, file = "ljrs_list_hybrid.RData")

# distribution of supplier countries (Ljrs/Ljr)
lsup <- map2(ljrs, llev, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(lsup, file = "lsup_list_hybrid.RData")

# distribution of intermediate products (Lijrs/Ljrs)
lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(lpro, file = "lpro_list_hybrid.RData")

#-------------------------------
# decompose Y
#-------------------------------

load("Y_list_hybrid.RData")

# total final demand for food (Ys)
ys <- lapply(Y_list, colSums) %>% 
  lapply(function (x) rbind(matrix(0, 22800, 44), matrix(x, nrow = 8800, ncol = 44, byrow = TRUE)))

# distribution of supplier countries (Yrs/Ys)
yrs <- map(Y_list, ~.x[22801:31600, ]) %>% 
  lapply(split.data.frame, rep(1:44, each = 200)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 44, ncol = 44, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 200), ]) %>% 
  lapply(function (x) rbind(matrix(0, 22800, 44), x))

ysup <- map2(yrs, ys, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ysup, file = "ysup_list_hybrid.RData")

# distribution of products (Yirs/Yrs)
ypro <- map2(Y_list, yrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ypro, file = "ypro_list_hybrid.RData")

load("GDP_hybrid.RData")
load("Population_hybrid.RData")

gdp <- map(gdp, ~.x[rep(1:44, each = 200)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = 44)) %>% 
  lapply(function (x) rbind(matrix(0, 22800, 44), x))

# level of final demand per GDP (Ys/GDP)
ylev <- map2(ys, gdp, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(ylev, file = "ylev_list_hybrid.RData")

# Population (P)
P <- map(pop, ~.x[rep(1:44, each = 200)]) %>% 
  map(~ matrix(.x, nrow = length(.x), ncol = 44))%>% 
  lapply(function (x) rbind(matrix(0, 22800, 44), x))

save(P, file = "P_list_hybrid.RData")

# GDP per capita (G)
G <- map2(gdp, P, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

save(G, file = "G_list_hybrid.RData")

Y_dec <- pmap(list(ypro, ysup, ylev, G, P), ~..1 * ..2 * ..3 * ..4 * ..5)
rapply(Y_dec, function(x) ifelse(!is.finite(x), 0, x), how = "list")
all.equal(Y_list, Y_dec)
