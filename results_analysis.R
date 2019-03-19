library(tidyverse)

rm(list = ls()); gc()

#---------------------------------------------------
#
# ANALYSE RESULTS
#
#---------------------------------------------------

load("results_tbl.RData")
str(results)

results_long <- results %>%
  gather(contribution, value, con_U:con_P) %>% 
  mutate(share = value / delta_F)
results_long$share[is.na(results_long$share)] <- 0

str(results_long)
sum(is.na(results_long))
sum(!is.finite(results_long$share))

# delta F according to contributions of variables
results_long %>%
  filter(ISO == "USA") %>%
  ggplot(aes(x = year, y = share, fill = contribution)) +
    geom_col()

AUT <- results_long %>%
  filter(ISO == "AUT") #%>%
  
qplot(year, delta_F, data = AUT)

results_long %>% 
  filter(ISO == c("USA", "DEU", "CHN", "RUS")) %>% 
  ggplot(aes(year, share, fill = contribution)) +
    geom_col() +
    facet_grid(~ ISO)

results_long %>%
  ggplot(aes(x = year, y = delta_F, fill = share)) +
  geom_col() +
  facet_wrap(~ ISO)

indicators <- function(x, y){
  x %>% 
    group_by(country, ISO) %>% 
    summarize(mean = mean(y), 
              max = max(y),
              min = min(y),
              sd = sd(y),
              var = var(y)) %>% 
    arrange(desc(mean))
}
indicators(results, "con_P")

results %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(delta_F), 
            max = max(delta_F),
            min = min(delta_F),
            sd = sd(delta_F),
            var = var(delta_F)) %>% 
  arrange(desc(mean))

results %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(con_P), 
            max = max(con_P),
            min = min(con_P),
            sd = sd(con_P),
            var = var(con_P)) %>% 
  arrange(desc(mean))

results %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(con_G), 
            max = max(con_G),
            min = min(con_G),
            sd = sd(con_G),
            var = var(con_G)) %>% 
  arrange(desc(mean))
