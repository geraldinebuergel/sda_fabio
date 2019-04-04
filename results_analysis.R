library(tidyverse)
library(xtable)

rm(list = ls()); gc()

#---------------------------------------------------
#
# ANALYSE RESULTS
#
#---------------------------------------------------

# load("results_tbl.RData")
# # convert tbl into long format & replace NaN values
# results_long <- results %>%
#   gather(contribution, value, con_U:con_P) %>% 
#   mutate(share = value / delta_F)
# results_long$share[is.na(results_long$share)] <- 0

# bring results table into long format (=tidy)
load("results_tbl_inc.RData")
results_long <- results %>%
  gather(contribution, value, con_U:con_P) %>% 
  mutate(share = value / delta_F)
results_long$share[is.na(results_long$share)] <- 0
results_long$income <- factor(results_long$income, levels = c("High income", 
                                                              "Upper middle income",
                                                              "Lower middle income",
                                                              "Low income"))

#---------------------------------------------------------
# VISUAL ANALYSIS
#---------------------------------------------------------

# save as pdf to import into latex
pdf("total_landuse.pdf")
total_landuse
dev.off()

# total_absolute_con per year
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
    ylab(bquote(Delta ~ "in ha")) +
    theme(axis.text.x = element_text(angle = 45))

# total_relative_con per year
results_long %>%
  ggplot(aes(x = year, y = share, fill = contribution)) +
  geom_col(position = "fill") +
  scale_fill_brewer(palette = "RdYlGn",
                    name = "Variable",
                    labels = list(bquote(Delta ~ G), bquote(Delta ~ l^{lev}),
                                  bquote(Delta ~ l^{pro}), bquote(Delta ~ l^{sup}),
                                  bquote(Delta ~ P), bquote(Delta ~ u),
                                  bquote(Delta ~ y^{lev}), bquote(Delta ~ y^{pro}),
                                  bquote(Delta ~ y^{sup}))) +
  ylab("total relative contibution") +
  theme(axis.text.x = element_text(angle = 45))

# country level
results_long %>% 
  group_by(country, contribution) %>% 
  filter(ISO %in% c("USA", "CHN", "RUS", "DEU", "IND")) %>% 
  ggplot(aes(x=country, y=value, fill = contribution)) +
    geom_col() +
  coord_flip() +
  scale_fill_brewer(palette = "RdYlGn",
                    name = "Variable",
                    labels = list(bquote(Delta ~ G), bquote(Delta ~ l^{lev}),
                                  bquote(Delta ~ l^{pro}), bquote(Delta ~ l^{sup}),
                                  bquote(Delta ~ P), bquote(Delta ~ u),
                                  bquote(Delta ~ y^{lev}), bquote(Delta ~ y^{pro}),
                                  bquote(Delta ~ y^{sup}))) +
  ylab("total absolute contibution in ha")

# total contribution per income class -> fabio_inc
results_long %>% 
  drop_na() %>% 
  group_by(income, contribution) %>% 
  summarize(sum = sum(value)) %>% 
  ggplot(aes(x = income, y = sum, fill = contribution)) +
    geom_col() +
    scale_fill_brewer(palette = "RdYlGn",
                      name = "Variable",
                      labels = list(bquote(Delta ~ G), bquote(Delta ~ l^{lev}),
                                  bquote(Delta ~ l^{pro}), bquote(Delta ~ l^{sup}),
                                  bquote(Delta ~ P), bquote(Delta ~ u),
                                  bquote(Delta ~ y^{lev}), bquote(Delta ~ y^{pro}),
                                  bquote(Delta ~ y^{sup}))) +
    xlab("") +
    ylab("total contribution in ha")+
    coord_flip()

# country details per year
results_long %>% 
  filter(ISO %in% c("USA", "CHN", "RUS", "DEU", "IND")) %>% 
  ggplot(aes(year, value, fill = contribution)) +
  geom_col(position = "stack") +
  scale_fill_brewer(palette = "RdYlGn",
                    name = "Variable",
                    labels = list(bquote(Delta ~ G), bquote(Delta ~ l^{lev}),
                                  bquote(Delta ~ l^{pro}), bquote(Delta ~ l^{sup}),
                                  bquote(Delta ~ P), bquote(Delta ~ u),
                                  bquote(Delta ~ y^{lev}), bquote(Delta ~ y^{pro}),
                                  bquote(Delta ~ y^{sup}))) +
  ylab("total absolute contibution in ha") +
  theme(axis.text.x = element_text(angle = 45)) +
  facet_wrap(~ country)

# solve overplotting -> dist_value
results_long %>% 
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

# sum_delta_F
results_long %>% 
  group_by(country) %>% 
  summarize(sum_F = sum(delta_F)) %>% 
  ggplot(aes(country, sum_F)) +
    geom_col() +
    ylab(bquote(Delta ~ F)) +
    theme(axis.text.x = element_text(angle = 45)) +
  coord_flip()

# total landuse in ha -> total_landuse
load("total_Elanduse.RData")
qplot(year, landuse, data = t, geom = "line", ylab = "landuse in ha")
total_landuse <- ggplot(t, aes(year, landuse)) +
  geom_line() +
  ylab("landuse in ha") +
  theme(text = element_text(size=15))

#--------------------------------------------------------
# STATISTICAL ANALYSIS
#--------------------------------------------------------

# general summary per variabel in ha
a1 <- results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value),
            sum = sum(value)) %>% 
  mutate(share = sum*100/sum(results$delta_F))

# total_contribution -> fabio_driver
fabio_driver <- ggplot(a1, aes(contribution, share)) +
  geom_col() +
  ylab("contribution in %") +
  xlab("") +
  scale_x_discrete(labels = list(bquote(Delta ~ G), bquote(Delta ~ l^{lev}),
                                 bquote(Delta ~ l^{pro}), bquote(Delta ~ l^{sup}),
                                 bquote(Delta ~ P), bquote(Delta ~ u),
                                 bquote(Delta ~ y^{lev}), bquote(Delta ~ y^{pro}),
                                 bquote(Delta ~ y^{sup}))) +
  theme(text = element_text(size=15))

#print(xtable(a1), include.rownames=FALSE)

# summary per variable in %
b2 <- results_long %>% 
  group_by(contribution) %>% 
  summarize(mean = mean(share)*100,
            sd = sd(share)*100,
            sum = sum(share)) %>% 
  arrange(desc(mean))

#print(xtable(b2), include.rownames=FALSE)

# years
c1 <- results_long %>% 
  group_by(year) %>% 
  summarize(mean_F = mean(delta_F)) %>% 
  arrange(desc(mean_F))

c2 <- results_long %>% 
  group_by(year, contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value)) %>% 
  arrange(desc(mean))

c3 <- results_long %>% 
  group_by(year, contribution) %>% 
  summarize(mean = mean(share),
            sd = sd(share)) %>% 
  arrange(desc(mean))

# countries
e1 <- results_long %>% 
  group_by(country, ISO, contribution) %>% 
  summarize(mean = mean(value),
            sd = sd(value)) %>% 
  arrange(desc(mean))

e2 <- results_long %>% 
  group_by(country, ISO, contribution) %>% 
  summarize(mean = mean(share),
            sd = sd(share)) %>% 
  arrange(desc(mean))

e3 <- results_long %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(delta_F),
            sd = sd(delta_F)) %>% 
  arrange(desc(mean))

# expected driver
results_long %>% 
  filter(contribution == "con_G") %>% 
  group_by(country, ISO) %>% 
  summarize(mean = mean(value),
            sd = sd(value)) %>% 
  arrange(desc(mean))
