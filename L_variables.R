fabio <- "/mnt/nfs_fineprint/tmp/fabio/"

L_list <- list.files(path = fabio, pattern = "*_L.RData")

L_list <- L_list[a] %>% 
  map(~ mget(load(paste0(fabio,.x)))) %>%
  lapply(as.data.frame) %>% 
  map(~.x[1:24700, 1:24700]) %>% 
  lapply(as.matrix)

#save(L_list, file = "L_list.RData")

# level of total input requirements (Ljs)
llev <- lapply(L_list, colSums) %>% 
  lapply(matrix, nrow = 24700, ncol = 24700, byrow = TRUE)

#save(llev, file = "llev_list.RData")
#rm(llev); gc()

# distribution of supplier countries (Ljrs/Ljs)
ljrs <- lapply(L_list, as.data.frame) %>% 
  lapply(split.data.frame, rep(1:190, each = 130)) %>% 
  lapply(lapply, colSums) %>% 
  map(~ matrix(unlist(.x), nrow = 190, ncol = 24700, byrow = TRUE)) %>% 
  map(~ .x[rep(1:nrow(.x), each = 130), ])

#save(ljrs, file = "ljrs.RData")

# distribution of intermediate products (Lijrs/Ljrs)
lpro <- map2(L_list, ljrs, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

#save(lpro, file = "lpro_list.RData")
#rm(lpro); gc()

#load("llev_list.RData")

lsup <- map2(ljrs, llev, ~.x / .y) %>% 
  rapply(function(x) ifelse(!is.finite(x), 0, x), how = "list")

#save(lsup, file = "lsup_list.RData")
