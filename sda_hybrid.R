library(tidyverse)

rm(list = ls()); gc()

#-----------------------------------------
#
# HYBRID MODEL
#
#-----------------------------------------

load(paste0("/mnt/nfs_fineprint/tmp/exiobase/pxp/",year,"_Y.RData"))
E <- readRDS(paste0("/mnt/nfs_fineprint/tmp/fabio/",year,"_E.rds"))
X <- readRDS(paste0("/mnt/nfs_fineprint/tmp/fabio/",year,"_X.rds"))
L <- readRDS(paste0("/mnt/nfs_fineprint/tmp/fabio/hybrid/",year,"_L_120.rds"))

# add zeros to landuse vector for non-food exiobase
X[X<0] <- 0
e <- c(as.vector(E$Landuse) / X, rep(0,nrow(Y)))
e[!is.finite(e)] <- 0
MP <- e * L

# aggregate countries in Y & add zeros for food demand
colnames(Y) <- rep(1:49, each = 7)
Y <- agg(Y)
Y <- rbind(matrix(0,nrow(E),44),Y[,1:44])