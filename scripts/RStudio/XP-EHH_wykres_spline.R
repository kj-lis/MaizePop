################################

library(data.table)
library(ggplot2)

Pv_Tr_spline <- fread("C:/Users/kjlis/Desktop/XP_EHH_Pv_Tr_smoothed.csv")

# Sprawdź nazwy kolumn
colnames(Pv_Tr_spline)

Pv_Tr_spline$chromosome <- gsub("chr", "", Pv_Tr_spline$chromosome)
Pv_Tr_spline$CHR <- as.numeric(Pv_Tr_spline$chromosome)

# Jeżeli po splineAnalyze kolumna pozycji nazywa się inaczej,
# sprawdź colnames(Pv_Tr_spline) i podmień tutaj.
# Najczęściej może to być midPoint, WindowCenter, start/end albo podobna kolumna.

Pv_Tr_spline$pos <- as.numeric(Pv_Tr_spline$midPoint)
Pv_Tr_spline$Wstat <- as.numeric(Pv_Tr_spline$Wstat)

Pv_Tr_spline <- Pv_Tr_spline[
  !is.na(CHR) &
    !is.na(pos) &
    !is.na(Wstat)
]

setorder(Pv_Tr_spline, CHR, pos)

upper_thr <- quantile(Pv_Tr_spline$Wstat, 0.95, na.rm = TRUE)
lower_thr <- quantile(Pv_Tr_spline$Wstat, 0.05, na.rm = TRUE)

chr_sizes <- Pv_Tr_spline[, .(chr_len = max(pos)), by = CHR]
chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

Pv_Tr_spline <- merge(
  Pv_Tr_spline,
  chr_sizes[, .(CHR, cumlen)],
  by = "CHR"
)

Pv_Tr_spline$cumpos <- Pv_Tr_spline$pos + Pv_Tr_spline$cumlen

axisdf <- Pv_Tr_spline[, .(
  center = (max(cumpos) + min(cumpos)) / 2
), by = CHR]


png(
  file = "C:/Users/kjlis/Desktop/XP-EHH_Pv_Tr_spline.png",
  width = 3000,
  height = 1000,
  res = 300
)

ggplot(Pv_Tr_spline, aes(x = cumpos, y = Wstat, color = as.factor(CHR))) +
  geom_point(size = 1, alpha = 1) +
  scale_color_viridis_d(option = "viridis") +
  scale_x_continuous(
    labels = axisdf$CHR,
    breaks = axisdf$center
  ) +
  geom_hline(
    yintercept = c(lower_thr, upper_thr),
    color = "red",
    linetype = "dashed",
    linewidth = 1.2
  ) +
  theme_classic() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 13, face = "bold", margin = margin(t = 13)),
    axis.title.y = element_text(size = 13, face = "bold", margin = margin(r = 13)),
    axis.text = element_text(size = 12, color = "black"),
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    axis.ticks.length = unit(0.2, "cm")
  ) +
  labs(
    x = "chromosome",
    y = "smoothed XP-EHH",
    title = "Parviglumis vs. Tropical"
  )

dev.off()

