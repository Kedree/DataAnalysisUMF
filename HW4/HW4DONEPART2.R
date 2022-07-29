install.packages("ggpubr")
install.packages("ymd")

library(ggpubr)
library(lubridate)
library(dplyr)
library(tidyverse)

# 3

cars93 <- MASS::Cars93
ggplot(cars93, aes(x = Price, y = Fuel.tank.capacity)) +
  geom_point(color = "grey60") +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x, color = "#0072B2") +
  scale_x_continuous(
    name = "price (USD)",
    breaks = c(20, 40, 60),
    labels = c("$20,000", "$40,000", "$60,000")
  ) +
  scale_y_continuous(name = "fuel-tank capacity\n(US gallons)")

plotLM <- ggplot(cars93, aes(x = Price, y = Fuel.tank.capacity)) +
  geom_point(color = "grey60") +
  geom_smooth(se = TRUE, method = "lm", formula = y ~ x, color = "#8fe388") +
  scale_x_continuous(
    name = "price (USD)",
    breaks = c(20, 40, 60),
    labels = c("$20,000", "$40,000", "$60,000")
  ) +
  scale_y_continuous(name = "fuel-tank capacity\n(US gallons)") +
  ggtitle("LM") +
  theme(plot.title = element_text(size=14, color="#8fe388"))

plotGLM <- ggplot(cars93, aes(x = Price, y = Fuel.tank.capacity)) +
  geom_point(color = "grey60") +
  geom_smooth(se = TRUE, method = "glm", formula = y ~ x, color = "#fe8d6d") +
  scale_x_continuous(
    name = "price (USD)",
    breaks = c(20, 40, 60),
    labels = c("$20,000", "$40,000", "$60,000")
  ) +
  scale_y_continuous(name = "fuel-tank capacity\n(US gallons)") +
  ggtitle("GLM") +
  theme(plot.title = element_text(size=14, color="#fe8d6d"))

plotGAM <- ggplot(cars93, aes(x = Price, y = Fuel.tank.capacity)) +
  geom_point(color = "grey60") +
  geom_smooth(se = TRUE, method = "gam", formula = y ~ x, color = "#7c6bea") +
  scale_x_continuous(
    name = "price (USD)",
    breaks = c(20, 40, 60),
    labels = c("$20,000", "$40,000", "$60,000")
  ) +
  scale_y_continuous(name = "fuel-tank capacity\n(US gallons)") +
  ggtitle("GAM") +
  theme(plot.title = element_text(size=14, color="#7c6bea"))

ggarrange(plotLM, plotGLM, plotGAM + rremove("x.text"), 
          ncol = 2, nrow = 2)
# 4

load("./preprint_growth.rda") #please change the path if needed

head(preprint_growth)
preprint_growth %>% filter(archive == "bioRxiv") %>%
  filter(count > 0) -> biorxiv_growth
preprints<-preprint_growth %>% filter(archive %in%
                                        c("bioRxiv", "arXiv q-bio", "PeerJ Preprints")) %>%filter(count > 0) %>%
  mutate(archive = factor(archive, levels = c("bioRxiv", "arXiv q-bio", "PeerJ Preprints")))
1
preprints_final <- filter(preprints, date == ymd("2017-01-01"))
ggplot(preprints) +
  aes(date, count, color = archive, fill = archive) +
  geom_line(size = 1) +
  scale_y_continuous(
    limits = c(0, 600), expand = c(0, 0),
    name = "preprints / month",
    sec.axis = dup_axis( #this part is for the second y axis
      breaks = preprints_final$count, #and we use the counts to position our labels
      labels = c("arXivq-bio", "PeerJPreprints", "bioRxiv"),
      name = NULL)
  ) +
  scale_x_date(name = "year",
               limits = c(min(biorxiv_growth$date), ymd("2017-01-01"))) +
  scale_color_manual(values = c("#0072b2", "#D55E00", "#009e73"),
                     name = NULL) +
  theme(legend.position = "none")

newPrePrint = drop_na(preprint_growth)
newPrePrint = newPrePrint %>% filter(year(newPrePrint$date) > 2004) %>% filter(newPrePrint$count > 0)

newPrePrint = newPrePrint %>% filter(newPrePrint$archive == "bioRxiv" | newPrePrint$archive == "F1000Research")

preprints_final <- filter(newPrePrint, date == ymd("2018-03-01"))

ggplot(newPrePrint) +
  ggtitle("Preprint Counts", "F1000 lags significantly compared to bioRxiv") +
  aes(date, count, color = archive, fill = archive) +
  geom_line(size = 1) +
  scale_x_date(limits = as.Date(c('2014-01-01','2018-03-01'))) +
  scale_y_continuous(
    limits = c(0, 1600), expand = c(0, 0),
    name = "preprints / month",
    sec.axis = dup_axis( #this part is for the second y axis
      breaks = preprints_final$count, #and we use the counts to position our labels
      labels = c("F1000Research", "bioRxiv"),
      name = NULL)
  ) +
  scale_color_manual(values = c("#7c6bea", "#fe8d6d"),
                     name = NULL) +
  theme(legend.position = "none")
