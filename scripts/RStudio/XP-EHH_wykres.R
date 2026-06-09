library(data.table)

Pv_Tr <- fread("C:/Users/kjlis/Desktop/Projekt ZEMR/Wyniki/05_XP_EHH/raw_data/Pv_Tr.norm")
Tr_Idt_1 <- fread("C:/Users/kjlis/Desktop/Projekt ZEMR/Wyniki/05_XP_EHH/raw_data/Tr_Idt_1.norm")
Tr_SS_1 <- fread("C:/Users/kjlis/Desktop/Projekt ZEMR/Wyniki/05_XP_EHH/raw_data/Tr_SS_1.norm")
Idt_1vs2 <- fread("C:/Users/kjlis/Desktop/Projekt ZEMR/Wyniki/05_XP_EHH/raw_data/Idt_1vs2.norm")
SS_1vs2 <- fread("C:/Users/kjlis/Desktop/Projekt ZEMR/Wyniki/05_XP_EHH/raw_data/SS_1vs2.norm")


################################


library(ggrastr)
library(data.table)
library(ggplot2)

Pv_Tr$norm_xpehh[
  Pv_Tr$norm_xpehh %in% c("nan","-nan","inf","-inf","NA","")
] <- NA

Pv_Tr$norm_xpehh <- as.numeric(Pv_Tr$norm_xpehh)
Pv_Tr$pos <- as.numeric(Pv_Tr$pos)

Pv_Tr <- Pv_Tr[
  !is.na(norm_xpehh) &
    !is.na(pos)
]

Pv_Tr$CHR <- gsub("chr","",Pv_Tr$chr)
Pv_Tr$CHR <- as.numeric(Pv_Tr$CHR)

setorder(Pv_Tr, CHR, pos)

Pv_Tr$window <- floor(Pv_Tr$pos / 20000)

window_df <- Pv_Tr[
  ,
  .(
    median_xpehh = median(norm_xpehh, na.rm=TRUE),
    pos = mean(pos)
  ),
  by=.(CHR, window)
]

upper_thr <- quantile(window_df$median_xpehh, 0.95, na.rm=TRUE)
lower_thr <- quantile(window_df$median_xpehh, 0.05, na.rm=TRUE)

chr_sizes <- window_df[, .(chr_len=max(pos)), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR, cumlen)],
  by="CHR"
)

window_df$cumpos <- window_df$pos + window_df$cumlen

axisdf <- window_df[, .(
  center=(max(cumpos)+min(cumpos))/2
), by=CHR]

title_size <- 14
axis_title_size <- 13
axis_text_size <- 12

threshold_linewidth <- 1.2

png(file="C:/Users/kjlis/Desktop/XP_EHH_Pv_Tr.png", width=3000, height=1000, res=300)
ggplot(window_df, aes(x=cumpos, y=median_xpehh, color=as.factor(CHR))) +
  geom_point(size=1, alpha=1) +
  scale_color_viridis_d(option="viridis") +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center) +
  scale_y_continuous(
    breaks = c(-4, -2, 0, 2, 4)) +
  coord_cartesian(
    ylim=c(-4,4)) +
  geom_hline(
    yintercept=c(lower_thr, upper_thr),
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(
      size = title_size,
      face = "bold",
      hjust = 0.5,
      color = "black"),
    axis.title.x = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(t = 13),
      color = "black"),
    axis.title.y = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(r = 13),
      color = "black"),
    axis.text = element_text(
      size = axis_text_size,
      color = "black"),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(
      color = "black"),
    axis.ticks = element_line(
      color = "black"),
    axis.ticks.length = unit(0.2, "cm")) +
  labs(
    x="chromosome",
    y="XP-EHH",
    title="Parviglumis vs. Tropical")
dev.off()


################################


library(ggrastr)
library(data.table)
library(ggplot2)

Tr_Idt_1$norm_xpehh[
  Tr_Idt_1$norm_xpehh %in% c("nan","-nan","inf","-inf","NA","")
] <- NA

Tr_Idt_1$norm_xpehh <- as.numeric(Tr_Idt_1$norm_xpehh)
Tr_Idt_1$pos <- as.numeric(Tr_Idt_1$pos)

Tr_Idt_1 <- Tr_Idt_1[
  !is.na(norm_xpehh) &
    !is.na(pos)
]

Tr_Idt_1$CHR <- gsub("chr","",Tr_Idt_1$chr)
Tr_Idt_1$CHR <- as.numeric(Tr_Idt_1$CHR)

setorder(Tr_Idt_1, CHR, pos)

Tr_Idt_1$window <- floor(Tr_Idt_1$pos / 20000)

window_df <- Tr_Idt_1[
  ,
  .(
    median_xpehh = median(norm_xpehh, na.rm=TRUE),
    pos = mean(pos)
  ),
  by=.(CHR, window)
]

upper_thr <- quantile(window_df$median_xpehh, 0.95, na.rm=TRUE)
lower_thr <- quantile(window_df$median_xpehh, 0.05, na.rm=TRUE)

chr_sizes <- window_df[, .(chr_len=max(pos)), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR, cumlen)],
  by="CHR"
)

window_df$cumpos <- window_df$pos + window_df$cumlen

axisdf <- window_df[, .(
  center=(max(cumpos)+min(cumpos))/2
), by=CHR]

title_size <- 14
axis_title_size <- 13
axis_text_size <- 12

threshold_linewidth <- 1.2

png(file="C:/Users/kjlis/Desktop/XP_EHH_Tr_Idt_1.png", width=3000, height=1000, res=300)
ggplot(window_df, aes(x=cumpos, y=median_xpehh, color=as.factor(CHR))) +
  geom_point(size=1, alpha=1) +
  scale_color_viridis_d(option="viridis") +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center) +
  scale_y_continuous(
    breaks = c(-4, -2, 0, 2, 4)) +
  coord_cartesian(
    ylim=c(-4,4)) +
  geom_hline(
    yintercept=c(lower_thr, upper_thr),
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(
      size = title_size,
      face = "bold",
      hjust = 0.5,
      color = "black"),
    axis.title.x = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(t = 13),
      color = "black"),
    axis.title.y = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(r = 13),
      color = "black"),
    axis.text = element_text(
      size = axis_text_size,
      color = "black"),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(
      color = "black"),
    axis.ticks = element_line(
      color = "black"),
    axis.ticks.length = unit(0.2, "cm")) +
  labs(
    x="chromosome",
    y="XP-EHH",
    title="Tropical vs. Iodent I")
dev.off()


################################


library(ggrastr)
library(data.table)
library(ggplot2)

Tr_SS_1$norm_xpehh[
  Tr_SS_1$norm_xpehh %in% c("nan","-nan","inf","-inf","NA","")
] <- NA

Tr_SS_1$norm_xpehh <- as.numeric(Tr_SS_1$norm_xpehh)
Tr_SS_1$pos <- as.numeric(Tr_SS_1$pos)

Tr_SS_1 <- Tr_SS_1[
  !is.na(norm_xpehh) &
    !is.na(pos)
]

Tr_SS_1$CHR <- gsub("chr","",Tr_SS_1$chr)
Tr_SS_1$CHR <- as.numeric(Tr_SS_1$CHR)

setorder(Tr_SS_1, CHR, pos)

Tr_SS_1$window <- floor(Tr_SS_1$pos / 20000)

window_df <- Tr_SS_1[
  ,
  .(
    median_xpehh = median(norm_xpehh, na.rm=TRUE),
    pos = mean(pos)
  ),
  by=.(CHR, window)
]

upper_thr <- quantile(window_df$median_xpehh, 0.95, na.rm=TRUE)
lower_thr <- quantile(window_df$median_xpehh, 0.05, na.rm=TRUE)

chr_sizes <- window_df[, .(chr_len=max(pos)), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR, cumlen)],
  by="CHR"
)

window_df$cumpos <- window_df$pos + window_df$cumlen

axisdf <- window_df[, .(
  center=(max(cumpos)+min(cumpos))/2
), by=CHR]

title_size <- 14
axis_title_size <- 13
axis_text_size <- 12

threshold_linewidth <- 1.2

png(file="C:/Users/kjlis/Desktop/XP_EHH_Tr_SS_1.png", width=3000, height=1000, res=300)
ggplot(window_df, aes(x=cumpos, y=median_xpehh, color=as.factor(CHR))) +
  geom_point(size=1, alpha=1) +
  scale_color_viridis_d(option="viridis") +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center) +
  scale_y_continuous(
    breaks = c(-4, -2, 0, 2, 4)) +
  coord_cartesian(
    ylim=c(-4,4)) +
  geom_hline(
    yintercept=c(lower_thr, upper_thr),
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(
      size = title_size,
      face = "bold",
      hjust = 0.5,
      color = "black"),
    axis.title.x = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(t = 13),
      color = "black"),
    axis.title.y = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(r = 13),
      color = "black"),
    axis.text = element_text(
      size = axis_text_size,
      color = "black"),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(
      color = "black"),
    axis.ticks = element_line(
      color = "black"),
    axis.ticks.length = unit(0.2, "cm")) +
  labs(
    x="chromosome",
    y="XP-EHH",
    title="Tropical vs. SS I")
dev.off()


################################


library(ggrastr)
library(data.table)
library(ggplot2)

Idt_1vs2$norm_xpehh[
  Idt_1vs2$norm_xpehh %in% c("nan","-nan","inf","-inf","NA","")
] <- NA

Idt_1vs2$norm_xpehh <- as.numeric(Idt_1vs2$norm_xpehh)
Idt_1vs2$pos <- as.numeric(Idt_1vs2$pos)

Idt_1vs2 <- Idt_1vs2[
  !is.na(norm_xpehh) &
    !is.na(pos)
]

Idt_1vs2$CHR <- gsub("chr","",Idt_1vs2$chr)
Idt_1vs2$CHR <- as.numeric(Idt_1vs2$CHR)

setorder(Idt_1vs2, CHR, pos)

Idt_1vs2$window <- floor(Idt_1vs2$pos / 20000)

window_df <- Idt_1vs2[
  ,
  .(
    median_xpehh = median(norm_xpehh, na.rm=TRUE),
    pos = mean(pos)
  ),
  by=.(CHR, window)
]

upper_thr <- quantile(window_df$median_xpehh, 0.95, na.rm=TRUE)
lower_thr <- quantile(window_df$median_xpehh, 0.05, na.rm=TRUE)

chr_sizes <- window_df[, .(chr_len=max(pos)), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR, cumlen)],
  by="CHR"
)

window_df$cumpos <- window_df$pos + window_df$cumlen

axisdf <- window_df[, .(
  center=(max(cumpos)+min(cumpos))/2
), by=CHR]

title_size <- 14
axis_title_size <- 13
axis_text_size <- 12

threshold_linewidth <- 1.2

png(file="C:/Users/kjlis/Desktop/XP_EHH_Idt_1vs2.png", width=3000, height=1000, res=300)
ggplot(window_df, aes(x=cumpos, y=median_xpehh, color=as.factor(CHR))) +
  geom_point(size=1, alpha=1) +
  scale_color_viridis_d(option="viridis") +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center) +
  scale_y_continuous(
    breaks = c(-4, -2, 0, 2, 4)) +
  coord_cartesian(
    ylim=c(-4,4)) +
  geom_hline(
    yintercept=c(lower_thr, upper_thr),
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(
      size = title_size,
      face = "bold",
      hjust = 0.5,
      color = "black"),
    axis.title.x = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(t = 13),
      color = "black"),
    axis.title.y = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(r = 13),
      color = "black"),
    axis.text = element_text(
      size = axis_text_size,
      color = "black"),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(
      color = "black"),
    axis.ticks = element_line(
      color = "black"),
    axis.ticks.length = unit(0.2, "cm")) +
  labs(
    x="chromosome",
    y="XP-EHH",
    title="Iodent I vs. Iodent II")
dev.off()


################################


library(ggrastr)
library(data.table)
library(ggplot2)

SS_1vs2$norm_xpehh[
  SS_1vs2$norm_xpehh %in% c("nan","-nan","inf","-inf","NA","")
] <- NA

SS_1vs2$norm_xpehh <- as.numeric(SS_1vs2$norm_xpehh)
SS_1vs2$pos <- as.numeric(SS_1vs2$pos)

SS_1vs2 <- SS_1vs2[
  !is.na(norm_xpehh) &
    !is.na(pos)
]

SS_1vs2$CHR <- gsub("chr","",SS_1vs2$chr)
SS_1vs2$CHR <- as.numeric(SS_1vs2$CHR)

setorder(SS_1vs2, CHR, pos)

SS_1vs2$window <- floor(SS_1vs2$pos / 20000)

window_df <- SS_1vs2[
  ,
  .(
    median_xpehh = median(norm_xpehh, na.rm=TRUE),
    pos = mean(pos)
  ),
  by=.(CHR, window)
]

upper_thr <- quantile(window_df$median_xpehh, 0.95, na.rm=TRUE)
lower_thr <- quantile(window_df$median_xpehh, 0.05, na.rm=TRUE)

chr_sizes <- window_df[, .(chr_len=max(pos)), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR, cumlen)],
  by="CHR"
)

window_df$cumpos <- window_df$pos + window_df$cumlen

axisdf <- window_df[, .(
  center=(max(cumpos)+min(cumpos))/2
), by=CHR]

title_size <- 14
axis_title_size <- 13
axis_text_size <- 12

threshold_linewidth <- 1.2

png(file="C:/Users/kjlis/Desktop/XP_EHH_SS_1vs2.png", width=3000, height=1000, res=300)
ggplot(window_df, aes(x=cumpos, y=median_xpehh, color=as.factor(CHR))) +
  geom_point(size=1, alpha=1) +
  scale_color_viridis_d(option="viridis") +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center) +
  scale_y_continuous(
    breaks = c(-4, -2, 0, 2, 4)) +
  coord_cartesian(
    ylim=c(-4,4)) +
  geom_hline(
    yintercept=c(lower_thr, upper_thr),
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(
      size = title_size,
      face = "bold",
      hjust = 0.5,
      color = "black"),
    axis.title.x = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(t = 13),
      color = "black"),
    axis.title.y = element_text(
      size = axis_title_size,
      face = "bold",
      margin = margin(r = 13),
      color = "black"),
    axis.text = element_text(
      size = axis_text_size,
      color = "black"),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(
      color = "black"),
    axis.ticks = element_line(
      color = "black"),
    axis.ticks.length = unit(0.2, "cm")) +
  labs(
    x="chromosome",
    y="XP-EHH",
    title="SS I vs. SS II")
dev.off()

