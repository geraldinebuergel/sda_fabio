library(tidyverse)
library(xtable)
library(tikzDevice)

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

# results_long %>% 
#   ggplot(aes(x = value)) +
#   geom_density() +
#   facet_wrap(~ contribution)

results_long %>% 
  ggplot(aes(x = contribution, y = value)) +
  geom_boxplot()

# results_long %>% 
#   ggplot(aes(x = share)) +
#     geom_density() +
#     facet_wrap(~ contribution)

results_long %>% 
  ggplot(aes(x = contribution, y = share)) +
  geom_boxplot()

# tikz('plot1.tex',width=3.5, height=3)
# 
# plot1
# 
# dev.off()
# tikzTest()
# tikzTest("con_G")

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

# general summary per variabel
a1 <- results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value),
            min = min(value),
            max = max(value)) %>% 
  arrange(desc(mean))

# export for latex
print(xtable(a1), include.rownames=FALSE)

# arrange for different indicators
a2 <- arrange(a1, desc(sd))
a3 <- arrange(a1, desc(min))
a4 <- arrange(a1, desc(max))

b1 <- results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(share),
            sd = sd(share),
            min = min(share),
            max = max(share)) %>% 
  arrange(desc(mean))
b2 <- arrange(b1, desc(sd))
b3 <- arrange(b1, desc(min))
b4 <- arrange(b1, desc(max))

# years
c1 <- results_long %>% 
  group_by(year) %>% 
  summarize(mean_F = mean(delta_F)) %>% 
  arrange(desc(mean_F))

c2 <- results_long %>% 
  group_by(year, contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value),
            min = min(value),
            max = max(value)) %>% 
  arrange(desc(mean))

c3 <- results_long %>% 
  group_by(year, contribution) %>% 
  summarize(mean = mean(share),
            sd = sd(share),
            min = min(share),
            max = max(share)) %>% 
  arrange(desc(mean))

# separate pos & neg values
d1 <- results_long %>% 
  filter(value > 0) %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value),
            min = min(value),
            max = max(value)) %>% 
  arrange(desc(mean))
d2 <- arrange(d1, desc(sd))

d3 <- results_long %>% 
  filter(value < 0) %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value),
            min = min(value),
            max = max(value)) %>% 
  arrange(mean)
d4 <- arrange(d3, sd)

# countries
e1 <- results_long %>% 
  group_by(country, ISO, contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value),
            min = min(value),
            max = max(value)) %>% 
  arrange(desc(mean))

e2 <- results_long %>% 
  group_by(country, ISO, contribution) %>% 
  summarize(mean = mean(share),
            sd = sd(share),
            max = max(share),
            min = min(share)) %>% 
  arrange(desc(mean))

e3 <- results_long %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(delta_F),
            sd = sd(delta_F),
            max = max(delta_F),
            min = min(delta_F)) %>% 
  arrange(sd)

# finde large outliers
f1 <- results_long %>% 
  group_by(contribution, country, ISO) %>% 
  filter (contribution == "con_ypro") %>% 
  summarize(max = max(value)) %>% 
  arrange(desc(max))

f2 <- results_long %>% 
  group_by(contribution, country, ISO) %>% 
  filter (contribution == "con_ypro") %>% 
  summarize(min = min(value)) %>% 
  arrange(desc(min))

# solve overplotting
library(hexbin)
results_long %>% 
  ggplot(aes(x = contribution, y = share)) +
  stat_bin_hex(colour="white", na.rm=TRUE) +
  scale_fill_gradientn(colours=c("blue","orange"), 
                       name = "Frequency", 
                       na.value=NA)

results_long %>% 
  ggplot(aes(x = contribution, y = share)) +
  geom_boxplot(col = "blue") +
  geom_jitter()

results_long %>% 
  filter(contribution == "con_U") %>% 
  ggplot(aes(x = contribution, y = share)) +
  geom_boxplot(col = "red") +
  geom_jitter()
