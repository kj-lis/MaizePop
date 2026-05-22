################################


library(data.table)
library(ggplot2)
library(dplyr)

path <- "C:/Users/kjlis/Desktop/Pv_Tr/XP_CLR_out/Pv_Tr"

xpclr_list <- lapply(1:10, function(i){
file <- paste0(path, "/chr", i, "_Pv_Tr")
df <- fread(file, header = FALSE)

colnames(df) <- c(
    "CHR",
    "pos",
    "genetic_pos",
    "nSNP",
    "xpclr"
  )
  
  df$CHR <- i
  
  return(df)
})

window_df <- rbindlist(xpclr_list)
window_df <- window_df[
  is.finite(xpclr) & !is.na(xpclr)
]

upper_thr <- quantile(
  window_df$xpclr,
  0.99,
  na.rm = TRUE
)

chr_sizes <- window_df[, .(
  chr_len = max(pos)
), by = CHR]

chr_sizes$cumlen <- cumsum(
  chr_sizes$chr_len
) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR, cumlen)],
  by = "CHR"
)

window_df$cumpos <- window_df$pos + window_df$cumlen

axisdf <- window_df[, .(
  center = (max(cumpos) + min(cumpos)) / 2
), by = CHR]

title_size <- 14
axis_title_size <- 13
axis_text_size <- 12

threshold_linewidth <- 1.2

png(file = "C:/Users/kjlis/Desktop/XP_CLR_Pv_Tr.png", width = 3000, height = 1000, res = 300)

ggplot(window_df,aes(x = cumpos,y = xpclr,color = as.factor(CHR))) +
  geom_point(size = 1,alpha = 1) +
  scale_color_viridis_d(option="plasma") +
  scale_x_continuous(labels = axisdf$CHR,breaks = axisdf$center) +
  geom_hline(yintercept = upper_thr,color = "red",linetype = "dashed",linewidth = threshold_linewidth) +
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
    axis.ticks.length = unit(
      0.2,"cm")) +
  labs(
    x = "chromosome",
    y = "XP-CLR",
    title = "Parviglumis vs. Tropical")
dev.off()


