library(readxl)
library(xtable)

country_product_list <- read_xlsx("C:/Users/Zoe/Dropbox/Master Arbeit/excel/country_product_list.xlsx")

print(xtable(country_product_list), include.rownames = FALSE) 