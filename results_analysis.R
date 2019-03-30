library(tidyverse)
library(xtable)

rm(list = ls()); gc()

#---------------------------------------------------
#
# ANALYSE RESULTS
#
#---------------------------------------------------

load("results_tbl_hybrid.RData")

# convert tbl into long format & replace NaN values
results_long <- results %>%
  gather(contribution, value, con_U:con_P) %>% 
  mutate(share = value / delta_F)
results_long$share[is.na(results_long$share)] <- 0

#---------------------------------------------------------
# VISUAL ANALYSIS
#---------------------------------------------------------

results_long %>%
  ggplot(aes(x = value)) +
  geom_density() +
  facet_wrap(~ contribution)

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

# save as pdf to import into latex
#tikz('plot1.tex',width=3.5, height=3)
pdf("total_absolute_con_hyb.pdf", height = 6, width = 6)
total_absolute_con
dev.off()

# delta F according to contributions of variables -> total_absolute_con
results_long %>%
  ggplot(aes(x = year, y = value, fill = contribution)) +
    geom_col() +
    scale_fill_brewer(palette = "RdYlGn",
                      name = "Variable",
                      labels = list(bquote(Delta ~ G), bquote(Delta ~ l^{lev}),
                                    bquote(Delta ~ l^{pro}), bquote(Delta ~ l^{sup}),
                                    bquote(Delta ~ P), bquote(Delta ~ u),
                                    bquote(Delta ~ y^{lev}), bquote(Delta ~ y^{pro}),
                                    bquote(Delta ~ y^{sup}))) +
    ylab(bquote(Delta ~ "in ha"))

results_long %>% 
  filter(ISO == c("USA", "CHN", "DEU")) %>% 
  ggplot(aes(year, share, fill = contribution)) +
    geom_col(position = "stack") +
    facet_grid(~ ISO)

results_long %>% 
  filter(ISO == "CHN") %>% 
  ggplot(aes(year, share, fill = contribution)) +
  geom_col(position = "fill")

# solve overplotting -> dist_value
dist_value <- results_long %>% 
  ggplot(aes(x = contribution, y = value)) +
  geom_boxplot(col = "red3") +
  geom_jitter() +
  xlab("Variable") +
  ylab(bquote(Delta ~ "in ha")) +
  scale_x_discrete(labels = list(bquote(Delta ~ G), bquote(Delta ~ l^{lev}),
                                  bquote(Delta ~ l^{pro}), bquote(Delta ~ l^{sup}),
                                  bquote(Delta ~ P), bquote(Delta ~ u),
                                  bquote(Delta ~ y^{lev}), bquote(Delta ~ y^{pro}),
                                  bquote(Delta ~ y^{sup})))

results_long %>% 
  filter(contribution == "con_lsup") %>% 
  ggplot(aes(x = contribution, y = value)) +
  geom_boxplot(col = "red") +
  geom_jitter()

results_long %>% 
  group_by(year) %>% 
  summarize(sum_F = sum(delta_F),
            mean_F = mean(delta_F)) %>% 
  ggplot(aes(year, sum_F)) +
    geom_col()

# total landuse in ha -> total_landuse
load("total_Elanduse.RData")
total_landuse <- qplot(year, landuse, data = t, geom = "line", ylab = "landuse in ha")
# change in total landuse in ha
load("compare_delta_F.RData")
qplot(year, delta_landuse, data = compare_delta_F, geom = "col")

#--------------------------------------------------------
# STATISTICAL ANALYSIS
#--------------------------------------------------------

# general summary per variabel, absolute
a1 <- results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value),
            min = min(value),
            max = max(value)) %>% 
  arrange(desc(mean))

print(xtable(a1), include.rownames=FALSE)

# summary per variable, relative
b1 <- results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(share),
            sd = sd(share),
            min = min(share),
            max = max(share)) %>% 
  arrange(desc(mean))
b2 <- results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(share)*100,
            sd = sd(share)*100,
            min = min(share)*100,
            max = max(share)*100) %>% 
  arrange(desc(mean))

print(xtable(b2), include.rownames=FALSE)

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
  arrange(desc(mean))

# find large outliers
results_long %>% 
  group_by(contribution, country, ISO) %>% 
  filter (contribution == "con_lsup") %>% 
  summarize(max = max(value)) %>% 
  arrange(desc(max))

results_long %>% 
  group_by(contribution, country, ISO) %>% 
  filter (contribution == "con_lpro") %>% 
  summarize(min = min(value)) %>% 
  arrange(desc(min))

results_long %>% 
  group_by(country, ISO, year, contribution) %>% 
  summarize(max = max(value)) %>% 
  arrange(desc(max))

# expected driver
results_long %>% 
  filter(contribution == "con_G") %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(value),
            sd = sd(value)) %>% 
  arrange(desc(mean))

#------------------------------------
# check if results make sense
#------------------------------------

F_sum <- results %>%
  group_by(year) %>% 
  summarize(sum = sum(delta_F))

load("landuse.RData")
E1 <- map(E_landuse, ~.x[1:22800])
E2 <- lapply(E1, sum)
E3 <- list()
for (i in 2:length(E2)){
  E3[[i]] <- E2[[i]] - E2[[i-1]]
}

load("results_tbl_old.RData")
F_sum_old <- results_old %>% 
  group_by(year) %>% 
  summarize(sum_old = sum(delta_F))

compare_delta_F <- tibble(year = c(1987:2013),
             delta_landuse = unlist(E3[2:28]),
             delta_F = F_sum["sum"],
             delta_F_old = F_sum_old["sum_old"])
save(compare_delta_F, file = "compare_delta_F.RData")