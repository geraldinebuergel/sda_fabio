library(tidyverse)

rm(list = ls()); gc()

#-------------------------------------------
# 
# CONVERT EXIOBASE FILES (1995 - 2013)
#
#-------------------------------------------

# 49 regions, 200 products, 7 final demand categories, 163 industries, M.EUR

#-------------------------------
# list files
#-------------------------------

exiobase <- "/mnt/nfs_fineprint/tmp/exiobase/pxp/"

# Y
eY_list <- list.files(path = exiobase, pattern = "*_Y.RData")

# select 1995 - 1999
eY_list1 <- eY_list[1:5] %>% 
  map(~ mget(load(paste0(exiobase, .x))))
# select 2000 - 2013
eY_list2 <- eY_list[6:19] %>% 
  map(~ mget(load(paste0(exiobase, .x))))

# L
eL_list <- list.files(path = exiobase, pattern = "*_L.RData")
eL_list1 <- eL_list[1:5] %>% 
  map(~ mget(load(paste0(exiobase, .x))))
eL_list2 <- eL_list[6:19] %>% 
  map(~ mget(load(paste0(exiobase, .x))))

# x
ex_list <- list.files(path = exiobase, pattern = "*_x.RData")
ex_list <- ex_list[1:19] %>% 
  map(~ mget(load(paste0(exiobase, .x))))

# land use???

#--------------------------------
# convert EUR to USD
#--------------------------------

# exchange rates 1995 - 1999???

# WIOD exchange rates, 2000 - 2013, USD/EUR
wiod_exr <- c(0.92360, 0.89560, 0.94560, 1.13120, 1.24390, 1.24410, 1.25560, 
              1.37050, 1.47080, 1.39480, 1.32570, 1.39200, 1.28480, 1.32810)

eY_USD2 <- list()
for(i in 1:14){
  eY_USD2[[i]] <- wiod_exr[i] * eY_list2[[i]][["Y"]]
}

# deflate USD