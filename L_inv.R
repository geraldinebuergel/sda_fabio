library(tidyverse)
library(MASS)
memory.limit(16000)

load("C:/Users/Zoe/Desktop/FABIO/2013_A.RData")
A <- A[1:1300, 1:1300]

I <- diag(ncol(A))
det(I - A)
L_inv <- ginv(I - A)

# level of total input requirements (Ljs)
llev_inv <- colSums(L_inv) # numeric

# distribution of supplier countries (Ljrs/Ljs)
L_list <- split.data.frame(as.data.frame(L_inv), rep(1:10, each = 130))
ljrs_list <- map(L_list, colSums)
ljrs <- do.call(rbind, ljrs_list) # matrix
lsup_inv <- divide(ljrs)
lsup_inv[is.nan(lsup_inv)] <- 0
head(colSums(lsup_inv))

# distribution of intermediate products (Lijrs/Ljrs)
lpro_inv_list <- map(L_list, divide) # elements are matrices
lpro_inv <- do.call(rbind, lpro_inv_list)
lpro_inv[is.nan(lpro_inv)] <- 0
head(colSums(lpro_inv))

# L and L_inv are not even similar