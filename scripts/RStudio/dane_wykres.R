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

png(file="C:/Users/kjlis/Desktop/dane_linie.png", width=1000, height=900, res=250)
ggplot() +
  geom_bar(
    data = dane,
    aes(x = heterotic.group, fill = heterotic.group),
    width = 0.7,
    position = "identity",
    color = "black",
    linewidth = 0.55
  ) +
  geom_bar(
    data = dane_split,
    aes(x = heterotic.group, y = n, fill = heterotic.group),
    stat = "identity",
    position = "stack",
    width = 0.7,
    color = "black",
    linewidth = 0.55
  ) +
  geom_text(
    data = dane_split,
    aes(x = heterotic.group, y = n, label = paste0(n, "\n", "era ", era)),
    position = position_stack(vjust = 0.5),
    size = 4
  ) +
  geom_text(
    data = dane_total,
    aes(x = heterotic.group, y = n, label = n),
    vjust = -0.5,
    size = 4
  ) +
  scale_fill_manual(values = c(
    "Iodent"      = "green3",
    "SS"          = "blue",
    "NSS"         = "red3",
    "Tropical"    = "purple",
    "Mix"         = "gold",
    "Parviglumis" = "cyan3",
    "Mexicana"    = "darkorange"
  )) +
  labs(x = "subpopulation", y = "number of lines") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.position = "none",
    axis.title.x = element_text(size = 13, face = "bold", margin = margin(t = 13.5)),
    axis.title.y = element_text(size = 13, face = "bold", margin = margin(r = 13.5)),
    axis.text = element_text(size = 12)
  )
dev.off()