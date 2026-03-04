library(dplyr)
library(tidyr)
library(ggplot2)

# jeśli jeszcze nie masz maxQ
merged$maxQ <- apply(merged[,paste0("K",1:5)], 1, max)

# sortowanie: najpierw klaster, potem czystość malejąco
merged_sorted <- merged %>%
  arrange(Assigned_cluster, desc(maxQ))

# nadajemy kolejność na osi X
merged_sorted$Order <- 1:nrow(merged_sorted)

adm_long <- merged_sorted %>%
  pivot_longer(cols = starts_with("K"),
               names_to = "Cluster",
               values_to = "Ancestry")

boundaries <- cumsum(table(merged_sorted$Assigned_cluster))

ggplot(adm_long, aes(x = Order, y = Ancestry, fill = Cluster)) +
  geom_bar(stat = "identity", width = 1) +
  
  geom_segment(
    data = data.frame(x = boundaries),
    aes(x = x, xend = x, y = 0.00, yend = 1),  # <-- tu kontrolujesz odstęp
    inherit.aes = FALSE,
    color = "black",
    linewidth = 0.8
  ) +
  
  scale_fill_manual(values = c(
    "#1b9e77",
    "#d95f02",
    "#7570b3",
    "#e7298a",
    "#66a61e"
  )) +
  
  coord_cartesian(ylim = c(0, 1)) +
  
  theme_classic() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid = element_blank(),
    legend.title = element_blank()
  ) +
  labs(x = "Lines",
       y = "Ancestry")


################################################

merged_sorted$Poland <- merged_sorted$origin == "Poland"

ggplot(adm_long, aes(x = Order, y = Ancestry, fill = Cluster)) +
  geom_bar(stat = "identity", width = 1) +
  geom_point(data = merged_sorted %>% filter(Poland),
             aes(x = Order, y = 1.02),
             inherit.aes = FALSE,
             size = 0.8) +
  coord_cartesian(ylim = c(0,1.05)) +
  theme_classic()