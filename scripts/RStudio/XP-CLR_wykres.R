################################


library(data.table)
library(ggplot2)
library(scales)

path <- "C:/Users/kjlis/Desktop/Pv_Tr"

xpclr_list <- lapply(1:10, function(i){
  
  file <- paste0(path,"/chr",i,"_Pv_Tr.wtclr.txt")
  
  df <- fread(file,header=FALSE)
  
  colnames(df) <- c(
    "CHR",
    "grid",
    "nSNP_window",
    "pos",
    "genetic_pos",
    "xpclr",
    "pval_like",
    "left_bound",
    "right_bound",
    "nSNP_total",
    "fst",
    "nSNP_effective"
  )
  
  df$CHR <- i
  
  return(df)
})

window_df <- rbindlist(xpclr_list)

setorder(window_df,CHR,pos)

window_df <- window_df[
  is.finite(xpclr) &
    !is.na(xpclr) &
    xpclr >= 0
]

upper_thr <- quantile(
  window_df$xpclr,
  0.95,
  na.rm=TRUE
)

chr_sizes <- window_df[, .(
  chr_len=max(pos)
), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR,cumlen)],
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

png(
  file="C:/Users/kjlis/Desktop/XP_CLR_Pv_Tr.png",
  width=3000,
  height=1000,
  res=300
)

ggplot(
  window_df,
  aes(
    x=cumpos,
    y=xpclr,
    color=as.factor(CHR)
  )
) +
  geom_point(
    size=0.6,
    alpha=0.8
  ) +
  scale_color_viridis_d(
    option="plasma"
  ) +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center
  ) +
  geom_hline(
    yintercept=upper_thr,
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth
  ) +
  coord_cartesian(
    ylim=c(
      0,
      quantile(window_df$xpclr,0.99999)
    )
  ) +
  theme_classic() +
  theme(
    legend.position="none",
    plot.title=element_text(
      size=title_size,
      face="bold",
      hjust=0.5,
      color="black"
    ),
    axis.title.x=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(t=13),
      color="black"
    ),
    axis.title.y=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(r=13),
      color="black"
    ),
    axis.text=element_text(
      size=axis_text_size,
      color="black"
    ),
    panel.grid=element_blank(),
    panel.border=element_blank(),
    axis.line=element_line(
      color="black"
    ),
    axis.ticks=element_line(
      color="black"
    ),
    axis.ticks.length=unit(
      0.2,"cm"
    )
  ) +
  labs(
    x="chromosome",
    y="XP-CLR",
    title="Parviglumis vs. Tropical"
  )

dev.off()


################################


library(data.table)
library(ggplot2)
library(scales)

path <- "C:/Users/kjlis/Desktop/Tr_Idt_1"

xpclr_list <- lapply(1:10, function(i){
  
  file <- paste0(path,"/chr",i,"_Tr_Idt_1.wtclr.txt")
  
  df <- fread(file,header=FALSE)
  
  colnames(df) <- c(
    "CHR",
    "grid",
    "nSNP_window",
    "pos",
    "genetic_pos",
    "xpclr",
    "pval_like",
    "left_bound",
    "right_bound",
    "nSNP_total",
    "fst",
    "nSNP_effective"
  )
  
  df$CHR <- i
  
  return(df)
})

window_df <- rbindlist(xpclr_list)

setorder(window_df,CHR,pos)

window_df <- window_df[
  is.finite(xpclr) &
    !is.na(xpclr) &
    xpclr >= 0
]

upper_thr <- quantile(
  window_df$xpclr,
  0.95,
  na.rm=TRUE
)

chr_sizes <- window_df[, .(
  chr_len=max(pos)
), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR,cumlen)],
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

png(
  file="C:/Users/kjlis/Desktop/XP_CLR_Tr_Idt_1.png",
  width=3000,
  height=1000,
  res=300
)

ggplot(
  window_df,
  aes(
    x=cumpos,
    y=xpclr,
    color=as.factor(CHR)
  )
) +
  geom_point(
    size=0.6,
    alpha=0.8
  ) +
  scale_color_viridis_d(
    option="plasma"
  ) +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center
  ) +
  geom_hline(
    yintercept=upper_thr,
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth
  ) +
  coord_cartesian(
    ylim=c(
      0,
      quantile(window_df$xpclr,0.99999)
    )
  ) +
  theme_classic() +
  theme(
    legend.position="none",
    plot.title=element_text(
      size=title_size,
      face="bold",
      hjust=0.5,
      color="black"
    ),
    axis.title.x=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(t=13),
      color="black"
    ),
    axis.title.y=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(r=13),
      color="black"
    ),
    axis.text=element_text(
      size=axis_text_size,
      color="black"
    ),
    panel.grid=element_blank(),
    panel.border=element_blank(),
    axis.line=element_line(
      color="black"
    ),
    axis.ticks=element_line(
      color="black"
    ),
    axis.ticks.length=unit(
      0.2,"cm"
    )
  ) +
  labs(
    x="chromosome",
    y="XP-CLR",
    title="Tropical vs. Iodent I"
  )

dev.off()


################################


library(data.table)
library(ggplot2)
library(scales)

path <- "C:/Users/kjlis/Desktop/Tr_SS_1"

xpclr_list <- lapply(1:10, function(i){
  
  file <- paste0(path,"/chr",i,"_Tr_SS_1.wtclr.txt")
  
  df <- fread(file,header=FALSE)
  
  colnames(df) <- c(
    "CHR",
    "grid",
    "nSNP_window",
    "pos",
    "genetic_pos",
    "xpclr",
    "pval_like",
    "left_bound",
    "right_bound",
    "nSNP_total",
    "fst",
    "nSNP_effective"
  )
  
  df$CHR <- i
  
  return(df)
})

window_df <- rbindlist(xpclr_list)

setorder(window_df,CHR,pos)

window_df <- window_df[
  is.finite(xpclr) &
    !is.na(xpclr) &
    xpclr >= 0
]

upper_thr <- quantile(
  window_df$xpclr,
  0.95,
  na.rm=TRUE
)

chr_sizes <- window_df[, .(
  chr_len=max(pos)
), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR,cumlen)],
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

png(
  file="C:/Users/kjlis/Desktop/XP_CLR_Tr_SS_1.png",
  width=3000,
  height=1000,
  res=300
)

ggplot(
  window_df,
  aes(
    x=cumpos,
    y=xpclr,
    color=as.factor(CHR)
  )
) +
  geom_point(
    size=0.6,
    alpha=0.8
  ) +
  scale_color_viridis_d(
    option="plasma"
  ) +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center
  ) +
  geom_hline(
    yintercept=upper_thr,
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth
  ) +
  coord_cartesian(
    ylim=c(
      0,
      quantile(window_df$xpclr,0.99999)
    )
  ) +
  theme_classic() +
  theme(
    legend.position="none",
    plot.title=element_text(
      size=title_size,
      face="bold",
      hjust=0.5,
      color="black"
    ),
    axis.title.x=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(t=13),
      color="black"
    ),
    axis.title.y=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(r=13),
      color="black"
    ),
    axis.text=element_text(
      size=axis_text_size,
      color="black"
    ),
    panel.grid=element_blank(),
    panel.border=element_blank(),
    axis.line=element_line(
      color="black"
    ),
    axis.ticks=element_line(
      color="black"
    ),
    axis.ticks.length=unit(
      0.2,"cm"
    )
  ) +
  labs(
    x="chromosome",
    y="XP-CLR",
    title="Tropical vs. SS I"
  )

dev.off()


################################


library(data.table)
library(ggplot2)
library(scales)

path <- "C:/Users/kjlis/Desktop/Idt_1vs2"

xpclr_list <- lapply(1:10, function(i){
  
  file <- paste0(path,"/chr",i,"_Idt_1vs2.wtclr.txt")
  
  df <- fread(file,header=FALSE)
  
  colnames(df) <- c(
    "CHR",
    "grid",
    "nSNP_window",
    "pos",
    "genetic_pos",
    "xpclr",
    "pval_like",
    "left_bound",
    "right_bound",
    "nSNP_total",
    "fst",
    "nSNP_effective"
  )
  
  df$CHR <- i
  
  return(df)
})

window_df <- rbindlist(xpclr_list)

setorder(window_df,CHR,pos)

window_df <- window_df[
  is.finite(xpclr) &
    !is.na(xpclr) &
    xpclr >= 0
]

upper_thr <- quantile(
  window_df$xpclr,
  0.95,
  na.rm=TRUE
)

chr_sizes <- window_df[, .(
  chr_len=max(pos)
), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR,cumlen)],
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

png(
  file="C:/Users/kjlis/Desktop/XP_CLR_Idt_1vs2.png",
  width=3000,
  height=1000,
  res=300
)

ggplot(
  window_df,
  aes(
    x=cumpos,
    y=xpclr,
    color=as.factor(CHR)
  )
) +
  geom_point(
    size=0.6,
    alpha=0.8
  ) +
  scale_color_viridis_d(
    option="plasma"
  ) +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center
  ) +
  geom_hline(
    yintercept=upper_thr,
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth
  ) +
  coord_cartesian(
    ylim=c(
      0,
      quantile(window_df$xpclr,0.99999)
    )
  ) +
  theme_classic() +
  theme(
    legend.position="none",
    plot.title=element_text(
      size=title_size,
      face="bold",
      hjust=0.5,
      color="black"
    ),
    axis.title.x=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(t=13),
      color="black"
    ),
    axis.title.y=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(r=13),
      color="black"
    ),
    axis.text=element_text(
      size=axis_text_size,
      color="black"
    ),
    panel.grid=element_blank(),
    panel.border=element_blank(),
    axis.line=element_line(
      color="black"
    ),
    axis.ticks=element_line(
      color="black"
    ),
    axis.ticks.length=unit(
      0.2,"cm"
    )
  ) +
  labs(
    x="chromosome",
    y="XP-CLR",
    title="Iodent I vs. Iodent II"
  )

dev.off()


################################


library(data.table)
library(ggplot2)
library(scales)

path <- "C:/Users/kjlis/Desktop/SS_1vs2"

xpclr_list <- lapply(1:10, function(i){
  
  file <- paste0(path,"/chr",i,"_SS_1vs2.wtclr.txt")
  
  df <- fread(file,header=FALSE)
  
  colnames(df) <- c(
    "CHR",
    "grid",
    "nSNP_window",
    "pos",
    "genetic_pos",
    "xpclr",
    "pval_like",
    "left_bound",
    "right_bound",
    "nSNP_total",
    "fst",
    "nSNP_effective"
  )
  
  df$CHR <- i
  
  return(df)
})

window_df <- rbindlist(xpclr_list)

setorder(window_df,CHR,pos)

window_df <- window_df[
  is.finite(xpclr) &
    !is.na(xpclr) &
    xpclr >= 0
]

upper_thr <- quantile(
  window_df$xpclr,
  0.95,
  na.rm=TRUE
)

chr_sizes <- window_df[, .(
  chr_len=max(pos)
), by=CHR]

chr_sizes$cumlen <- cumsum(chr_sizes$chr_len) - chr_sizes$chr_len

window_df <- merge(
  window_df,
  chr_sizes[, .(CHR,cumlen)],
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

png(
  file="C:/Users/kjlis/Desktop/XP_CLR_SS_1vs2.png",
  width=3000,
  height=1000,
  res=300
)

ggplot(
  window_df,
  aes(
    x=cumpos,
    y=xpclr,
    color=as.factor(CHR)
  )
) +
  geom_point(
    size=0.6,
    alpha=0.8
  ) +
  scale_color_viridis_d(
    option="plasma"
  ) +
  scale_x_continuous(
    labels=axisdf$CHR,
    breaks=axisdf$center
  ) +
  geom_hline(
    yintercept=upper_thr,
    color="red",
    linetype="dashed",
    linewidth=threshold_linewidth
  ) +
  coord_cartesian(
    ylim=c(
      0,
      quantile(window_df$xpclr,0.99999)
    )
  ) +
  theme_classic() +
  theme(
    legend.position="none",
    plot.title=element_text(
      size=title_size,
      face="bold",
      hjust=0.5,
      color="black"
    ),
    axis.title.x=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(t=13),
      color="black"
    ),
    axis.title.y=element_text(
      size=axis_title_size,
      face="bold",
      margin=margin(r=13),
      color="black"
    ),
    axis.text=element_text(
      size=axis_text_size,
      color="black"
    ),
    panel.grid=element_blank(),
    panel.border=element_blank(),
    axis.line=element_line(
      color="black"
    ),
    axis.ticks=element_line(
      color="black"
    ),
    axis.ticks.length=unit(
      0.2,"cm"
    )
  ) +
  labs(
    x="chromosome",
    y="XP-CLR",
    title="SS I vs. SS II"
  )

dev.off()

