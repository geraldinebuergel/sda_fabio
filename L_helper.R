hybrid <- "/mnt/nfs_fineprint/tmp/fabio/hybrid/"

# load L files
L_list <- list.files(path = hybrid, pattern = "*_L_120.rds")
L_list <- L_list[10:28]

# subset L for 1 or 2 years at a time
L_list <- L_list[a] %>% 
  map(~ readRDS(paste0(hybrid,.x))) %>%
  map(~.x[-c(22801:23040, 31601:32600), -c(22801:23040, 31601:32600)])

#save(L_list, file = "L_list_hybrid.RData")

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

#save(ljrs, file = "ljrs_list_hybrid.RData")
#load("ljrs_list_hybrid.RData")
gc()

# distribution of intermediate products (Lijrs/Ljrs)
lproa <- map2(L_list, ljrs, ~.x / .y) %>% 
  lapply(as, "matrix") %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
lpro[[2]] <- lproa[[1]]

rm(lproa); gc()
#save(lpro, file = "lpro_list_hybrid.RData")

# level of total input requirements (Ljs)
lleva <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = 31600, ncol = 31600, byrow = TRUE)

rm(L_list); gc()
#save(llev, file = "llev_list_hybrid.RData")

# distribution of supplier countries (Ljrs/Ljr)
lsupa <- map2(ljrs, lleva, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")
lsup[[2]] <- lsupa[[1]]
llev[[2]] <- lleva[[1]]

rm(ljrs, lsupa, lleva); gc()
#save(lsup, file = "lsup_list_hybrid.RData")