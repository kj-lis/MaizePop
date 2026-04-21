library(ggplot2)
library(dplyr)

dane <- read.csv("C:/Users/kjlis/Desktop/metadane_all.csv", stringsAsFactors = FALSE, sep = ";")

dane$heterotic.group <- factor(dane$heterotic.group, 
                        levels = c("Iodent", "NSS", "Tropical", "SS", "Mix", "Mexicana", "Parviglumis"))

selected_groups <- c("Iodent", "SS")

dane_split <- dane %>%
  filter(heterotic.group %in% selected_groups) %>%
  count(heterotic.group, era)

dane_total <- dane %>%
  count(heterotic.group)

dane_split <- dane %>%
  filter(heterotic.group %in% selected_groups) %>%
  mutate(era = factor(era, levels = c("II", "I"))) %>%
  count(heterotic.group, era)

png(file="C:/Users/kjlis/Desktop/dane_linie.png", width=2000, height=2000, res=250)
ggplot() +
  geom_bar(
    data = dane,
    aes(x = heterotic.group, fill = heterotic.group),
    width = 0.7,
    position = "identity",
    color = "black",
    linewidth = 0.65
  ) +
  geom_bar(
    data = dane_split,
    aes(x = heterotic.group, y = n, fill = heterotic.group),
    stat = "identity",
    position = "stack",
    width = 0.7,
    color = "black",
    linewidth = 0.65
  ) +
  geom_text(
    data = dane_split,
    aes(x = heterotic.group, y = n, label = paste0(n, "\n", "era ", era)),
    position = position_stack(vjust = 0.5),
    size = 5
  ) +
  geom_text(
    data = dane_total,
    aes(x = heterotic.group, y = n, label = n),
    vjust = -0.5,
    size = 5
  ) +
  scale_fill_manual(values = c(
    "Iodent"      = "limegreen",
    "SS"          = "royalblue3",
    "NSS"         = "firebrick2",
    "Tropical"    = "mediumorchid2",
    "Mix"         = "gold",
    "Parviglumis" = "deepskyblue",
    "Mexicana"    = "orange2"
  )) +
  labs(x = "subpopulation", y = "number of lines") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.position = "none",
    
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 14), color = "black"),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 14), color = "black"),
    
    axis.text.x = element_text(size = 13, color = "black"),
    axis.text.y = element_text(size = 13, color = "black")
  )
dev.off()