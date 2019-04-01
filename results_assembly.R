library(tidyverse)

rm(list = ls()); gc()

#-----------------------------------
# assemble results in list
#-----------------------------------

load("loop_c.RData")
results <- loop_c[2:28]

loop_list <- list.files(pattern = "loop") %>% 
  map(~ mget(load(paste0(.x))))

results <- list()
for(i in 1:length(loop_list)){
  results[[i]] <- loop_list[[i]][[1]][[2]]
}

results <- lapply(results, unlist, recursive = FALSE)
results[[14]] <- loop_list[[14]][[1]][[2]]
results <- unlist(results, recursive = FALSE)
results <- split(results, rep(1:27, each = 10))

names(results) <- c(1996:2013)
#names(results[[27]]) <- c("delta_F", "con_U", "con_lpro", "con_lsup", "con_llev",
                          #"con_ypro", "con_ysup", "con_ylev", "con_G", "con_P")
save(results, file = "results_list_hybrid.RData")

#----------------------------------------
# turn list into appropriate tibble
#----------------------------------------

# ISO codes----------------------------
ISO <- c("ARM","AFG","ALB","DZA","AGO","ATG","ARG","AUS","AUT","BHS",
                   "BHR","BRB","BLX","BGD","BOL","BWA","BRA","BLZ","SLB","BRN",
                   "BGR","MMR","BDI","CMR","CAN","CPV","CAF","LKA","TCD","CHL",
                   "CHN","COL","COG","CRI","CUB","CYP","CSK","AZE","BEN","DNK",
                   "DMA","DOM","BLR","ECU","EGY","SLV","EST","FJI","FIN","FRA",
                   "PYF","DJI","GEO","GAB","GMB","DEU","BIH","GHA","KIR","GRC",
                   "GRD","GTM","GIN","GUY","HTI","HND","HKG","HUN","HRV","ISL",
                   "IND","IDN","IRN","IRQ","IRL","ISR","ITA","CIV","KAZ","JAM",
                   "JPN","JOR","KGZ","KEN","KHM","PRK","KOR","KWT","LVA","LAO",
                   "LBN","LSO","LBR","LBY","LTU","MAC","MDG","MWI","MYS","MDV",
                   "MLI","MLT","MRT","MUS","MEX","MNG","MAR","MOZ","MDA","NAM",
                   "NPL","NLD","ANT","NCL","MKD","VUT","NZL","NIC","NER","NGA",
                   "NOR","PAK","PAN","CZE","PNG","PRY","PER","PHL","POL","PRT",
                   "GNB","TLS","PRI","ERI","QAT","ZWE","ROU","RWA","RUS","SCG",
                   "KNA","LCA","VCT","STP","SAU","SEN","SLE","SVN","SVK","SGP",
                   "SOM","ZAF","ESP","SUR","TJK","SWZ","SWE","CHE","SYR","TKM",
                   "TWN","TZA","THA","TGO","TTO","OMN","TUN","TUR","ARE","UGA",
                   "SUN","GBR","UKR","USA","BFA","URY","UZB","VEN","VNM","ETH",
                   "WSM","YUG","YEM","COD","ZMB","BEL","LUX","SRB","MNE","SDN"
)
save(ISO, file = "ISO_fabio.RData")

ISO <- c("AUT", "BEL", "BGR", "CYP", "CZE", "DEU", "DNK", "EST", "ESP", 
                "FIN", "FRA", "GRC", "HRV", "HUN", "IRL", "ITA", "LTU", "LUX", 
                "LVA", "MLT", "NLD", "POL", "PRT", "ROU", "SWE", "SVN", "SVK", 
                "GBR", "USA", "JPN", "CHN", "CAN", "KOR", "BRA", "IND", "MEX", 
                "RUS", "AUS", "CHE", "TUR", "TWN", "NOR", "IDN", "ZAF")
save(ISO, file = "hybrid_ISO.RData")

ISO <- c("CHN", "DEU", "RUS", "USA")
save(ISO, file = "ISO_c.RData")

#country codes ----------------------------------------
country <- c("Armenia","Afghanistan","Albania","Algeria","Angola","Antigua and Barbuda",
             "Argentina","Australia","Austria","Bahamas","Bahrain","Barbados","Belgium-Luxembourg",
             "Bangladesh","Bolivia (Plurinational State of)","Botswana","Brazil","Belize",
             "Solomon Islands","Brunei Darussalam","Bulgaria","Myanmar","Burundi","Cameroon",
             "Canada","Cabo Verde","Central African Republic","Sri Lanka","Chad","Chile",
             "China, mainland","Colombia","Congo","Costa Rica","Cuba","Cyprus","Czechoslovakia",
             "Azerbaijan","Benin","Denmark","Dominica","Dominican Republic","Belarus","Ecuador",
             "Egypt","El Salvador","Estonia","Fiji","Finland","France","French Polynesia","Djibouti",
             "Georgia","Gabon","Gambia","Germany","Bosnia and Herzegovina","Ghana","Kiribati","Greece",
             "Grenada","Guatemala","Guinea","Guyana","Haiti","Honduras","China, Hong Kong SAR",
             "Hungary","Croatia","Iceland","India","Indonesia","Iran (Islamic Republic of)","Iraq",
             "Ireland","Israel","Italy","Côte d'Ivoire","Kazakhstan","Jamaica","Japan","Jordan",
             "Kyrgyzstan","Kenya","Cambodia","Democratic People's Republic of Korea","Republic of Korea",
             "Kuwait","Latvia","Lao People's Democratic Republic","Lebanon","Lesotho","Liberia",
             "Libya","Lithuania","China, Macao SAR","Madagascar","Malawi","Malaysia","Maldives",
             "Mali","Malta","Mauritania","Mauritius","Mexico","Mongolia","Morocco","Mozambique",
             "Republic of Moldova","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia",
             "The former Yugoslav Republic of Macedonia","Vanuatu","New Zealand","Nicaragua","Niger",
             "Nigeria","Norway","Pakistan","Panama","Czech Republic","Papua New Guinea","Paraguay",
             "Peru","Philippines","Poland","Portugal","Guinea-Bissau","Timor-Leste","Puerto Rico",
             "Eritrea","Qatar","Zimbabwe","Romania","Rwanda","Russian Federation","Serbia and Montenegro",
             "Saint Kitts and Nevis","Saint Lucia","Saint Vincent and the Grenadines","Sao Tome and Principe",
             "Saudi Arabia","Senegal","Sierra Leone","Slovenia","Slovakia","Singapore","Somalia","South Africa",
             "Spain","Suriname","Tajikistan","Swaziland","Sweden","Switzerland","Syrian Arab Republic",
             "Turkmenistan","China, Taiwan Province of","United Republic of Tanzania","Thailand","Togo",
             "Trinidad and Tobago","Oman","Tunisia","Turkey","United Arab Emirates","Uganda","USSR",
             "United Kingdom","Ukraine","United States of America","Burkina Faso","Uruguay","Uzbekistan",
             "Venezuela (Bolivarian Republic of)","Viet Nam","Ethiopia","Samoa","Yugoslav SFR","Yemen",
             "Democratic Republic of the Congo","Zambia","Belgium","Luxembourg","Serbia","Montenegro","Sudan"
)
save(country, file = "country_fabio.RData")

country <- c("Austria"                   ,"Belgium"    ,"Bulgaria"        ,"Cyprus"         ,          
                    "Czech Republic"            ,"Germany"    ,"Denmark"         ,"Estonia"        ,          
                    "Spain"                     ,"Finland"    ,"France"          ,"Greece"         ,          
                     "Croatia"                  , "Hungary"   , "Ireland"        , "Italy"         ,           
                     "Lithuania"                , "Luxembourg", "Latvia"         , "Malta"         ,           
                     "Netherlands"              , "Poland"    , "Portugal"       , "Romania"       ,           
                     "Sweden"                   , "Slovenia"  , "Slovakia"       , "United Kingdom",           
                     "United States of America" , "Japan"     , "China, mainland", "Canada"        ,           
                     "Republic of Korea"        , "Brazil"    , "India"          , "Mexico"        ,           
                     "Russian Federation"       , "Australia" , "Switzerland"    , "Turkey"        ,           
                     "China, Taiwan Province of", "Norway"    , "Indonesia"      , "South Africa"  
                    )
save(country, file = "hybrid_country.RData")

country <- c("China, mainland", "Germany", "Russian Federation", "United States of America")
save(country, file = "country_c.RData")

# assemble tibble--------------------------

# function isolates variables and converts them into a vector
vec_list <- function(x){
  map(results, x) %>% 
    unlist() %>%
    matrix(nrow = length(results), ncol = length(results[[1]][[1]]), byrow = TRUE) %>% 
    as.vector()
}

# makes tibble from ISO, country, results (with year names)
results <- tibble(country = as.factor(rep(country, each = length(results))),
                      ISO = as.factor(rep(ISO, each = length(results))),
                      year = as.factor(rep(names(results), times = length(results[[1]][[1]]))),
                      delta_F = vec_list("delta_F"),
                      con_U = vec_list("con_U"),
                      con_lpro = vec_list("con_lpro"),
                      con_lsup = vec_list("con_lsup"),
                      con_llev = vec_list("con_llev"),
                      con_ypro = vec_list("con_ypro"),
                      con_ysup = vec_list("con_ysup"),
                      con_ylev = vec_list("con_ylev"),
                      con_G = vec_list("con_G"),
                      con_P = vec_list("con_P")
)
save(results, file = "results_tbl_hybrid.RData")

class <- read_xlsx("C:/Users/Zoe/Dropbox/Master Arbeit/excel/income_class.xlsx")

i1 <- intersect(ISO, income$ISO)
i2 <- setdiff(ISO, i1)
i3 <- match(ISO, income$ISO)
i4 <- income[c(i3), ]

income <- i4
save(income, file = "income_class_hybrid.RData")

results <- add_column(results, income = as.factor(rep(income$income, each = 27)))

save(results, file = "results_tbl_inc.RData")
