library(data.table)
library(ggplot2)

Pv_Tr <- fread("C:/Users/kjlis/Desktop/Pv_Tr.norm")
Tr_Idt_1 <- fread("C:/Users/kjlis/Desktop/Tr_Idt_1.norm")
Tr_SS_1 <- fread("C:/Users/kjlis/Desktop/Tr_SS_1.norm")
Idt_1vs2 <- fread("C:/Users/kjlis/Desktop/Idt_1vs2.norm")
SS_1vs2 <- fread("C:/Users/kjlis/Desktop/SS_1vs2.norm")

Pv_Tr$norm_xpehh <- as.numeric(Pv_Tr$norm_xpehh)
Tr_Idt_1$norm_xpehh <- as.numeric(Tr_Idt_1$norm_xpehh)
Tr_SS_1$norm_xpehh <- as.numeric(Tr_SS_1$norm_xpehh)
Idt_1vs2$norm_xpehh <- as.numeric(Idt_1vs2$norm_xpehh)
SS_1vs2$norm_xpehh <- as.numeric(SS_1vs2$norm_xpehh)

Pv_Tr <- Pv_Tr[!is.na(norm_xpehh)]
Tr_Idt_1 <- Tr_Idt_1[!is.na(norm_xpehh)]
Tr_SS_1 <- Tr_SS_1[!is.na(norm_xpehh)]
Idt_1vs2 <- Idt_1vs2[!is.na(norm_xpehh)]
SS_1vs2 <- SS_1vs2[!is.na(norm_xpehh)]

ggplot(SS_1vs2, aes(x=norm_xpehh)) +
  geom_histogram(
    bins=100,
    color="black",
    fill="mediumturquoise"
  ) +
  theme_bw() +
  labs(
    x="Normalized XP-EHH",
    y="Count",
    title="Distribution of XP-EHH scores (SS I vs. SS II)"
  )




library(ggrastr)


library(data.table)
library(ggplot2)

Pv_Tr <- fread("genomewide.norm", colClasses="character")

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

# 50 kb windows
Pv_Tr$window <- floor(Pv_Tr$pos / 50000)

# median XP-EHH per window
window_df <- Pv_Tr[
  ,
  .(
    median_xpehh = median(norm_xpehh, na.rm=TRUE),
    pos = mean(pos)
  ),
  by=.(CHR, window)
]

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

p <- ggplot(
  window_df,
  aes(x=cumpos, y=median_xpehh, color=as.factor(CHR))
) +
  geom_point(size=0.8) +
  scale_color_viridis_d(option = "turbo") +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center
  ) +
  geom_hline(
    yintercept=c(-2,2),
    color="red",
    linetype="dashed"
  ) +
  theme_bw() +
  theme(
    legend.position="none",
    panel.grid.major.x=element_blank(),
    panel.grid.minor.x=element_blank(),
    panel.border=element_blank(),
    axis.line=element_line(color="black")
  ) +
  labs(
    x="Chromosome",
    y="Median XP-EHH",
    title="Sliding-window XP-EHH (50 kb)"
  )