Pv_Tr <- read.table("C:/Users/kjlis/Desktop/Spline/Pv_Tr_all_windows.csv", sep = ",", header=TRUE)
Tr_Idt_1 <- read.table("C:/Users/kjlis/Desktop/Spline/Tr_Idt_1_all_windows.csv", sep = ",", header=TRUE)
Tr_SS_1 <- read.table("C:/Users/kjlis/Desktop/Spline/Tr_SS_1_all_windows.csv", sep = ",", header=TRUE)
Idt_1vs2 <- read.table("C:/Users/kjlis/Desktop/Spline/Idt_1vs2_all_windows.csv", sep = ",", header=TRUE)
SS_1vs2 <- read.table("C:/Users/kjlis/Desktop/Spline/SS_1vs2_all_windows.csv", sep = ",", header=TRUE)

library(dplyr)
library(ggplot2)


################################


Pv_Tr <- Pv_Tr %>% filter(Wstat > 0)

Pv_Tr <- Pv_Tr %>%
  filter(!is.na(Wstat))

Pv_Tr <- Pv_Tr %>%
  mutate(chromosome = gsub("chr", "", chromosome))

Pv_Tr <- Pv_Tr %>%
  mutate(chromosome = as.numeric(chromosome))

Pv_Tr <- Pv_Tr %>%
  arrange(chromosome, WindowStart) %>%
  group_by(chromosome) %>%
  mutate(chr_len = max(as.numeric(WindowStop))) %>%
  ungroup() %>%
  distinct(chromosome, chr_len) %>%
  arrange(chromosome) %>%
  mutate(offset = cumsum(chr_len) - chr_len) %>%
  right_join(Pv_Tr, by = "chromosome") %>%
  mutate(pos = WindowStart + offset)

axis_df <- Pv_Tr %>%
  group_by(chromosome) %>%
  summarise(center = mean(pos), .groups = "drop")

threshold <- quantile(Pv_Tr$Wstat, 0.9, na.rm = TRUE)


plot_title <- "Parviglumis vs. Tropical"

title_size <- 12
axis_title_size <- 11
axis_text_size <- 10

threshold_linewidth <- 1.2


png(file="C:/Users/kjlis/Desktop/FST_Pv_Tr.png", width=2200, height=1500, res=300)
ggplot(Pv_Tr, aes(x = pos, y = Wstat, color = factor(chromosome))) +
  geom_point(size = 0.6, alpha = 0.7) +
  geom_hline(yintercept = threshold,
             color = "red",
             linetype = "dashed",
             linewidth = threshold_linewidth) +
  scale_color_viridis_d(option = "turbo") +
  scale_x_continuous(
    breaks = axis_df$center,
    labels = axis_df$chromosome
  ) +
  scale_y_continuous(breaks = seq(0, 60, by = 10)) +
  coord_cartesian(ylim = c(0, 60)) +
  labs(
    title = plot_title,
    x = "Chromosome",
    y = "Wstat"
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = title_size, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = axis_title_size, face = "bold", margin = margin(t = 12)),
    axis.title.y = element_text(size = axis_title_size, face = "bold", margin = margin(r = 12)),
    axis.text.x = element_text(size = axis_text_size),
    axis.text.y = element_text(size = axis_text_size)
  )
dev.off()


################################


Tr_Idt_1 <- Tr_Idt_1 %>% filter(Wstat > 0)

Tr_Idt_1 <- Tr_Idt_1 %>%
  filter(!is.na(Wstat))

Tr_Idt_1 <- Tr_Idt_1 %>%
  mutate(chromosome = gsub("chr", "", chromosome))

Tr_Idt_1 <- Tr_Idt_1 %>%
  mutate(chromosome = as.numeric(chromosome))

Tr_Idt_1 <- Tr_Idt_1 %>%
  arrange(chromosome, WindowStart) %>%
  group_by(chromosome) %>%
  mutate(chr_len = max(as.numeric(WindowStop))) %>%
  ungroup() %>%
  distinct(chromosome, chr_len) %>%
  arrange(chromosome) %>%
  mutate(offset = cumsum(chr_len) - chr_len) %>%
  right_join(Tr_Idt_1, by = "chromosome") %>%
  mutate(pos = WindowStart + offset)

axis_df <- Tr_Idt_1 %>%
  group_by(chromosome) %>%
  summarise(center = mean(pos), .groups = "drop")

threshold <- quantile(Tr_Idt_1$Wstat, 0.9, na.rm = TRUE)


plot_title <- "Tropical vs. Iodent I"

title_size <- 12
axis_title_size <- 11
axis_text_size <- 10

threshold_linewidth <- 1.2


png(file="C:/Users/kjlis/Desktop/FST_Tr_Idt_1.png", width=2200, height=1500, res=300)
ggplot(Tr_Idt_1, aes(x = pos, y = Wstat, color = factor(chromosome))) +
  geom_point(size = 0.6, alpha = 0.7) +
  geom_hline(yintercept = threshold,
             color = "red",
             linetype = "dashed",
             linewidth = threshold_linewidth) +
  scale_color_viridis_d(option = "turbo") +
  scale_x_continuous(
    breaks = axis_df$center,
    labels = axis_df$chromosome
  ) +
  scale_y_continuous(breaks = seq(0, 60, by = 10)) +
  coord_cartesian(ylim = c(0, 60)) +
  labs(
    title = plot_title,
    x = "Chromosome",
    y = "Wstat"
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = title_size, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = axis_title_size, face = "bold", margin = margin(t = 12)),
    axis.title.y = element_text(size = axis_title_size, face = "bold", margin = margin(r = 12)),
    axis.text.x = element_text(size = axis_text_size),
    axis.text.y = element_text(size = axis_text_size)
  )
dev.off()


################################


Tr_SS_1 <- Tr_SS_1 %>% filter(Wstat > 0)

Tr_SS_1 <- Tr_SS_1 %>%
  filter(!is.na(Wstat))

Tr_SS_1 <- Tr_SS_1 %>%
  mutate(chromosome = gsub("chr", "", chromosome))

Tr_SS_1 <- Tr_SS_1 %>%
  mutate(chromosome = as.numeric(chromosome))

Tr_SS_1 <- Tr_SS_1 %>%
  arrange(chromosome, WindowStart) %>%
  group_by(chromosome) %>%
  mutate(chr_len = max(as.numeric(WindowStop))) %>%
  ungroup() %>%
  distinct(chromosome, chr_len) %>%
  arrange(chromosome) %>%
  mutate(offset = cumsum(chr_len) - chr_len) %>%
  right_join(Tr_SS_1, by = "chromosome") %>%
  mutate(pos = WindowStart + offset)

axis_df <- Tr_SS_1 %>%
  group_by(chromosome) %>%
  summarise(center = mean(pos), .groups = "drop")

threshold <- quantile(Tr_SS_1$Wstat, 0.9, na.rm = TRUE)


plot_title <- "Tropical vs. SS I"

title_size <- 12
axis_title_size <- 11
axis_text_size <- 10

threshold_linewidth <- 1.2


png(file="C:/Users/kjlis/Desktop/FST_Tr_SS_1.png", width=2200, height=1500, res=300)
ggplot(Tr_SS_1, aes(x = pos, y = Wstat, color = factor(chromosome))) +
  geom_point(size = 0.6, alpha = 0.7) +
  geom_hline(yintercept = threshold,
             color = "red",
             linetype = "dashed",
             linewidth = threshold_linewidth) +
  scale_color_viridis_d(option = "turbo") +
  scale_x_continuous(
    breaks = axis_df$center,
    labels = axis_df$chromosome
  ) +
  scale_y_continuous(breaks = seq(0, 60, by = 10)) +
  coord_cartesian(ylim = c(0, 60)) +
  labs(
    title = plot_title,
    x = "Chromosome",
    y = "Wstat"
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = title_size, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = axis_title_size, face = "bold", margin = margin(t = 12)),
    axis.title.y = element_text(size = axis_title_size, face = "bold", margin = margin(r = 12)),
    axis.text.x = element_text(size = axis_text_size),
    axis.text.y = element_text(size = axis_text_size)
  )
dev.off()


################################


Idt_1vs2 <- Idt_1vs2 %>% filter(Wstat > 0)

Idt_1vs2 <- Idt_1vs2 %>%
  filter(!is.na(Wstat))

Idt_1vs2 <- Idt_1vs2 %>%
  mutate(chromosome = gsub("chr", "", chromosome))

Idt_1vs2 <- Idt_1vs2 %>%
  mutate(chromosome = as.numeric(chromosome))

Idt_1vs2 <- Idt_1vs2 %>%
  arrange(chromosome, WindowStart) %>%
  group_by(chromosome) %>%
  mutate(chr_len = max(as.numeric(WindowStop))) %>%
  ungroup() %>%
  distinct(chromosome, chr_len) %>%
  arrange(chromosome) %>%
  mutate(offset = cumsum(chr_len) - chr_len) %>%
  right_join(Idt_1vs2, by = "chromosome") %>%
  mutate(pos = WindowStart + offset)

axis_df <- Idt_1vs2 %>%
  group_by(chromosome) %>%
  summarise(center = mean(pos), .groups = "drop")

threshold <- quantile(Idt_1vs2$Wstat, 0.9, na.rm = TRUE)


plot_title <- "Iodent I vs. Iodent II"

title_size <- 12
axis_title_size <- 11
axis_text_size <- 10

threshold_linewidth <- 1.2


png(file="C:/Users/kjlis/Desktop/FST_Idt_1vs2.png", width=2200, height=1500, res=300)
ggplot(Idt_1vs2, aes(x = pos, y = Wstat, color = factor(chromosome))) +
  geom_point(size = 0.6, alpha = 0.7) +
  geom_hline(yintercept = threshold,
             color = "red",
             linetype = "dashed",
             linewidth = threshold_linewidth) +
  scale_color_viridis_d(option = "turbo") +
  scale_x_continuous(
    breaks = axis_df$center,
    labels = axis_df$chromosome
  ) +
  scale_y_continuous(breaks = seq(0, 60, by = 10)) +
  coord_cartesian(ylim = c(0, 60)) +
  labs(
    title = plot_title,
    x = "Chromosome",
    y = "Wstat"
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = title_size, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = axis_title_size, face = "bold", margin = margin(t = 12)),
    axis.title.y = element_text(size = axis_title_size, face = "bold", margin = margin(r = 12)),
    axis.text.x = element_text(size = axis_text_size),
    axis.text.y = element_text(size = axis_text_size)
  )
dev.off()


################################


SS_1vs2 <- SS_1vs2 %>% filter(Wstat > 0)

SS_1vs2 <- SS_1vs2 %>%
  filter(!is.na(Wstat))

SS_1vs2 <- SS_1vs2 %>%
  mutate(chromosome = gsub("chr", "", chromosome))

SS_1vs2 <- SS_1vs2 %>%
  mutate(chromosome = as.numeric(chromosome))

SS_1vs2 <- SS_1vs2 %>%
  arrange(chromosome, WindowStart) %>%
  group_by(chromosome) %>%
  mutate(chr_len = max(as.numeric(WindowStop))) %>%
  ungroup() %>%
  distinct(chromosome, chr_len) %>%
  arrange(chromosome) %>%
  mutate(offset = cumsum(chr_len) - chr_len) %>%
  right_join(SS_1vs2, by = "chromosome") %>%
  mutate(pos = WindowStart + offset)

axis_df <- SS_1vs2 %>%
  group_by(chromosome) %>%
  summarise(center = mean(pos), .groups = "drop")

threshold <- quantile(SS_1vs2$Wstat, 0.9, na.rm = TRUE)


plot_title <- "SS I vs. SS II"

title_size <- 12
axis_title_size <- 11
axis_text_size <- 10

threshold_linewidth <- 1.2


png(file="C:/Users/kjlis/Desktop/FST_SS_1vs2.png", width=2200, height=1500, res=300)
ggplot(SS_1vs2, aes(x = pos, y = Wstat, color = factor(chromosome))) +
  geom_point(size = 0.6, alpha = 0.7) +
  geom_hline(yintercept = threshold,
             color = "red",
             linetype = "dashed",
             linewidth = threshold_linewidth) +
  scale_color_viridis_d(option = "turbo") +
  scale_x_continuous(
    breaks = axis_df$center,
    labels = axis_df$chromosome
  ) +
  scale_y_continuous(breaks = seq(0, 60, by = 10)) +
  coord_cartesian(ylim = c(0, 60)) +
  labs(
    title = plot_title,
    x = "Chromosome",
    y = "Wstat"
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = title_size, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = axis_title_size, face = "bold", margin = margin(t = 12)),
    axis.title.y = element_text(size = axis_title_size, face = "bold", margin = margin(r = 12)),
    axis.text.x = element_text(size = axis_text_size),
    axis.text.y = element_text(size = axis_text_size)
  )
dev.off()

