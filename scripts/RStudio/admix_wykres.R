library(ggplot2)
library(dplyr)
library(tidyr)

admix <- read.csv("C:/Users/kjlis/Desktop/admix_K9.csv", stringsAsFactors = FALSE)

Q_cols <- grep("^K", names(admix))

cluster_order <- c(1, 2, 5, 8, 3, 7, 4, 9, 6)

admix$assigned_cluster <- factor(admix$assigned_cluster,
                                 levels = cluster_order)

admix <- admix[order(admix$assigned_cluster,
                     -apply(admix[, Q_cols], 1, max)), ]

Q_long <- admix %>%
  pivot_longer(cols = starts_with("K"),
               names_to = "Cluster",
               values_to = "Ancestry")

Q_long$Cluster <- factor(Q_long$Cluster,
                         levels = c("K1","K2","K5","K8","K3","K7","K4","K9","K6"))

Q_long$ID <- factor(Q_long$ID, levels = admix$ID)

boundaries <- which(diff(as.numeric(admix$assigned_cluster)) != 0)

custom_colors <- c(
  K1 = "sienna2",
  K2 = "mediumorchid",
  K5 = "springgreen",
  K8 = "springgreen",
  K3 = "steelblue1",
  K7 = "steelblue1",
  K4 = "firebrick1",
  K9 = "firebrick1",
  K6 = "palevioletred1"
)

custom_labels <- c(
  K1 = "subspecies",
  K2 = "Tropical",
  K5 = "Iodent",
  K8 = "Iodent",
  K3 = "SS",
  K7 = "SS",
  K4 = "NSS (US)",
  K9 = "NSS (US) + Mix",
  K6 = "NSS (Poland)"
)

png(file="C:/Users/kjlis/Desktop/admix.png", width=3000, height=1800, res=250)
ggplot(Q_long, aes(x = ID, y = Ancestry, fill = Cluster)) +
  geom_bar(stat = "identity", width = 1) +
  scale_fill_manual(
    values = custom_colors,
    breaks = c("K1","K2","K5","K3","K4","K6"),
    labels = custom_labels[c("K1","K2","K5","K3","K4","K6")],
    name = NULL) +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_cartesian(ylim = c(0, 1)) +
  labs(x = NULL, y = "ancestry proportion") +
  theme_classic(base_size = 14) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 13)),
    axis.text.y  = element_text(size = 14),
    legend.title = element_text(size = 14, face = "bold"),
    legend.text  = element_text(size = 14),
    axis.title.x = element_text(margin = margin(t = 13)),
    plot.margin = margin(11, 11, 11, 11),
    panel.grid = element_blank(),
    axis.line = element_line(linewidth = 0.7),
    legend.position = "bottom")
dev.off()

