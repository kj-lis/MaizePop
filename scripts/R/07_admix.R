library(dplyr)
library(tidyr)
library(ggplot2)

# przygotowanie danych
merged$maxQ <- apply(merged[, paste0("K",1:5)], 1, max)
merged_sorted <- merged %>%
  arrange(Assigned_cluster, desc(maxQ))
merged_sorted$Order <- 1:nrow(merged_sorted)

adm_long <- merged_sorted %>%
  pivot_longer(
    cols = starts_with("K"),
    names_to = "Cluster",
    values_to = "Ancestry"
  )

# granice klastrów
boundaries <- cumsum(table(merged_sorted$Assigned_cluster))
boundaries <- boundaries[-length(boundaries)]

# etykiety legendy
cluster_labels <- c(
  "K1 - Iodent",
  "K2 - SS",
  "K3 - NSS, Tropical, Mix",
  "K4 - NSS",
  "K5 - Zea mays subsp."
)
legend_title_text <- "Subpopulations"

# ustawienia czcionek i marginesów
legend_text_size  <- 12
legend_title_size <- 14
axis_text_size    <- 12
axis_title_size   <- 14
x_title_margin    <- 15
y_title_margin    <- 15
cluster_line_offset <- 0.0

# offset dla słupków w prawo, aby był odstęp od osi Y
x_offset <- 0.5

# rysowanie wykresu
ggplot(adm_long, aes(x = Order + x_offset, y = Ancestry, fill = Cluster)) +
  
  geom_bar(stat = "identity", width = 1) +
  
  # linie graniczne
  geom_segment(
    data = data.frame(x = boundaries + x_offset),
    aes(x = x, xend = x, y = cluster_line_offset, yend = 1),
    inherit.aes = FALSE,
    color = "black",
    linewidth = 0.8
  ) +
  
  scale_fill_manual(
    values = c("#00BF7D", "#00B0F6", "#E76BF3", "#F8766D", "#f09a4a"),
    labels = cluster_labels,
    name = legend_title_text
  ) +
  
  scale_y_continuous(breaks = seq(0,1,0.2)) +
  coord_cartesian(ylim = c(0,1), expand = FALSE) +
  
  theme_classic() +
  theme(
    axis.line.x  = element_blank(),
    axis.text.x  = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y  = element_text(size = axis_text_size),
    
    axis.title.x = element_text(size = axis_title_size, margin = margin(t = x_title_margin)),
    axis.title.y = element_text(size = axis_title_size, margin = margin(r = y_title_margin)),
    
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text  = element_text(size = legend_text_size),
    
    panel.grid = element_blank()
  ) +
  
  labs(
    x = "Lines",
    y = "Ancestry"
  )

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