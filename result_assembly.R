library(tidyverse)

rm(list = ls()); gc()

loop_list <- list.files(pattern = "loop") %>% 
  map(~ mget(load(paste0(.x))))

results <- list()
for(i in 1:length(loop_list)){
  results[[i]] <- list(loop_list[[i]][[1]][[2]], loop_list[[i]][[1]][[3]])
}

results <- lapply(results, unlist, recursive = FALSE) %>% 
  unlist(recursive = FALSE) %>% 
  split(rep(1:27, each = 10))

names(results) <- c(1987:2013)
