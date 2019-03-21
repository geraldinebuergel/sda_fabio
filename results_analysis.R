library(tidyverse)
library(xtable)

rm(list = ls()); gc()

#---------------------------------------------------
#
# ANALYSE RESULTS
#
#---------------------------------------------------

load("results_tbl.RData")

# convert tbl into long format & replace NaN values
results_long <- results %>%
  gather(contribution, value, con_U:con_P) %>% 
  mutate(share = value / delta_F)
results_long$share[is.na(results_long$share)] <- 0

#---------------------------------------------------------
# VISUAL ANALYSIS
#---------------------------------------------------------

# delta F according to contributions of variables
results_long %>%
  filter(ISO == "USA") %>%
  ggplot(aes(x = year, y = share, fill = contribution)) +
    geom_col()

AUT <- results_long %>%
  filter(ISO == "AUT") #%>%
  qplot(year, delta_F, data = AUT, geom = "col")

results_long %>% 
  filter(ISO == c("USA", "DEU", "CHN", "RUS")) %>% 
  ggplot(aes(year, share, fill = contribution)) +
    geom_col() +
    facet_grid(~ ISO)

results_long %>%
  ggplot(aes(x = year, y = delta_F, fill = share)) +
  geom_col() +
  facet_wrap(~ ISO)

#--------------------------------------------------------
# STATISTICAL ANALYSIS
#--------------------------------------------------------

# function to determine indicators
indi <- function(x){
    list(mean = mean(x), 
         max = max(x),
         min = min(x),
         sd = sd(x))
}

# select columns with result values
results_values <- results %>%
  select(delta_F:con_P)

# function isolates variables and converts them into a vector
vec_list <- function(x){
  map(res_indi_list, x) %>% 
    unlist() %>%
    matrix() %>% 
    as.vector()
}

# create summary tibble
res_indi_list <- map(results_values, indi)
res_indi_tbl <- tibble(mean = vec_list("mean"),
                       sd = vec_list("sd"),
                       min = vec_list("min"),
                       max = vec_list("max"))
rownames(res_indi_tbl) <- c("delta_F", "con_U", "con_lpro", "con_lsup", "con_llev",
                            "con_ypro", "con_ysup", "con_ylev", "con_G", "con_P")
                       
# make latex table
xtable(res_indi_tbl)

results %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(delta_F), 
            max = max(delta_F),
            min = min(delta_F),
            sd = sd(delta_F)) %>%
  arrange(mean)

results %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(con_P), 
            max = max(con_P),
            min = min(con_P),
            sd = sd(con_P)) %>% 
  arrange(desc(mean))

results %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(con_G), 
            max = max(con_G),
            min = min(con_G),
            sd = sd(con_G)) %>% 
  arrange(desc(mean))

results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(share),
            sd = sd(share),
            max = max(share),
            min = min(share)) %>% 
  arrange(desc(mean))
