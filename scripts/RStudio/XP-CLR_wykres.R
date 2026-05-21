library(data.table)
library(dplyr)
library(ggplot2)

path <- "C:/Users/kjlis/Desktop/XP_CLR_out"
files <- paste0(path, "/XP_CLR_chr", 1:10, "_Pv_Tr")

# wczytanie wszystkich chromosomów
xpclr_list <- lapply(1:10, function(i){
  
  df <- fread(files[i], header = FALSE)
  
  # dostosuj nazwy kolumn jeśli output wygląda inaczej
  colnames(df) <- c(
    "chr",
    "pos",
    "genetic_pos",
    "xpclr"
  )
  
  df$chr <- i
  
  return(df)
})

# połączenie
xpclr <- bind_rows(xpclr_list)

# usunięcie NA / inf
xpclr <- xpclr %>%
  filter(!is.na(xpclr)) %>%
  filter(is.finite(xpclr))

# cumulative position
chr_sizes <- xpclr %>%
  group_by(chr) %>%
  summarise(chr_len = max(pos)) %>%
  mutate(tot = cumsum(chr_len) - chr_len)

xpclr <- xpclr %>%
  left_join(chr_sizes, by = "chr") %>%
  mutate(bp_cum = pos + tot)

# pozycje etykiet chromosomów
axisdf <- xpclr %>%
  group_by(chr) %>%
  summarise(center = (max(bp_cum) + min(bp_cum)) / 2)

# Manhattan plot
p <- ggplot(xpclr, aes(x = bp_cum, y = xpclr, color = as.factor(chr))) +
  geom_point(size = 0.8, alpha = 0.8) +
  
  scale_x_continuous(
    label = axisdf$chr,
    breaks = axisdf$center
  ) +
  
  scale_color_manual(values = rep(c("steelblue4", "orange3"), 5)) +
  
  labs(
    x = "Chromosome",
    y = "XP-CLR score",
    title = "XP-CLR Manhattan Plot"
  ) +
  
  theme_bw() +
  
  theme(
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

print(p)

# zapis
ggsave(
  "XPCLR_manhattan.png",
  p,
  width = 14,
  height = 6,
  dpi = 300
)
```
