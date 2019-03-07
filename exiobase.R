rm(list = ls()); gc()

#-------------------------------------------
# 
# READ EXIOBASE FILES
#
#-------------------------------------------

# 49 regions, 200 products, 7 final demand categories, 163 industries

exio_industries <- read.table("C:/Users/Zoe/Desktop/EXIOBASE3/IOT_2011_pxp/industries.txt",
                              header = TRUE, sep = "\t", stringsAsFactors = FALSE)
exio_units <- read.table("C:/Users/Zoe/Desktop/EXIOBASE3/IOT_2011_pxp/unit.txt",
                         header = TRUE, sep = "\t", stringsAsFactors = FALSE)
exio_products <- read.table("C:/Users/Zoe/Desktop/EXIOBASE3/IOT_2011_pxp/products.txt",
                            header = TRUE, sep = "\t", stringsAsFactors = FALSE)
exio_finaldemands <- read.table("C:/Users/Zoe/Desktop/EXIOBASE3/IOT_2011_pxp/finaldemands.txt",
                                header = TRUE, sep = "\t", stringsAsFactors = FALSE)
exio_Y <- read.table("C:/Users/Zoe/Desktop/EXIOBASE3/IOT_2011_pxp/Y.txt",
                     header = TRUE, sep = "\t", stringsAsFactors = FALSE)
exio_A <- read.table("C:/Users/Zoe/Desktop/EXIOBASE3/IOT_2011_pxp/A.txt",
                     header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# everything is in million EUR
test <- filter(exio_units, unit != "M.EUR")