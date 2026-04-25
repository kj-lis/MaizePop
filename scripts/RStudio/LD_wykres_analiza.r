################################


perl /home/jl430796/software/PopLDdecay/bin/Plot_OnePop.pl -inFile LD1.stat.gz -output ./LD1


################################


library(ggplot2)
library(dplyr)

data1 <- read.table("C:/Users/kjlis/Desktop/LD1/LD1.bin")
data2 <- read.table("C:/Users/kjlis/Desktop/LD1/LD2.bin")
data3 <- read.table("C:/Users/kjlis/Desktop/LD1/LD3.bin")
data4 <- read.table("C:/Users/kjlis/Desktop/LD1/LD4.bin")
data5 <- read.table("C:/Users/kjlis/Desktop/LD1/LD5.bin")
data6 <- read.table("C:/Users/kjlis/Desktop/LD1/LD6.bin")
data7 <- read.table("C:/Users/kjlis/Desktop/LD1/LD7.bin")

datasets <- list(data1, data2, data3, data4, data5, data6, data7)

pop_names <- c("Iodent","SS","NSS","Tropical","Mix","Parviglumis","Mexicana")
colors <- c("green3","blue","red","purple","gold","cyan3","darkorange")

df <- bind_rows(lapply(seq_along(datasets), function(i) {
  data.frame(
    Distance = datasets[[i]][,1] / 1000,
    r2 = datasets[[i]][,2],
    Population = pop_names[i]
  )
}))

df$Population <- factor(df$Population, levels = pop_names)

png(file="C:/Users/kjlis/Desktop/LD1.png", width=2500, height=1800, res=300)
ggplot(df, aes(x = Distance, y = r2, color = Population)) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = colors) +
  coord_cartesian(xlim = c(0, 500), ylim = c(0, 1)) +
  labs(
    x = "distance (kb)",
    y = expression(bold(r^2)),
    color = "Subpopulation"
  ) +
  theme_classic() +
  theme(
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 13)),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 13)),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 14, face = "bold"),
    legend.text = element_text(size = 14),
    legend.key.size = unit(1, "cm"),
    legend.position = c(0.98, 0.98),
    legend.justification = c(1, 1)
  )
dev.off()


get_ld_decay <- function(data, threshold = 0.2){
  data$dist_kb <- data[,1] / 1000
  data$r2 <- data[,2]
  idx <- which(data$r2 <= threshold)[1]
  return(data$dist_kb[idx])
}
sapply(datasets, get_ld_decay)


################################


library(ggplot2)
library(dplyr)

data1 <- read.table("C:/Users/kjlis/Desktop/LD2/LD1.bin")
data2 <- read.table("C:/Users/kjlis/Desktop/LD2/LD2.bin")
data3 <- read.table("C:/Users/kjlis/Desktop/LD2/LD3.bin")
data4 <- read.table("C:/Users/kjlis/Desktop/LD2/LD4.bin")
data5 <- read.table("C:/Users/kjlis/Desktop/LD2/LD5.bin")
data6 <- read.table("C:/Users/kjlis/Desktop/LD2/LD6.bin")
data7 <- read.table("C:/Users/kjlis/Desktop/LD2/LD7.bin")
data8 <- read.table("C:/Users/kjlis/Desktop/LD2/LD8.bin")
data9 <- read.table("C:/Users/kjlis/Desktop/LD2/LD9.bin")

datasets <- list(data1, data2, data3, data4, data5, data6, data7, data8, data9)

pop_names <- c("Iodent I", "Iodent II", "SS I", "SS II", "NSS","Tropical","Mix","Parviglumis","Mexicana")
colors <- c("green3","springgreen1","blue","deepskyblue4","red","purple","gold","cyan3","darkorange")

df <- bind_rows(lapply(seq_along(datasets), function(i) {
  data.frame(
    Distance = datasets[[i]][,1] / 1000,
    r2 = datasets[[i]][,2],
    Population = pop_names[i]
  )
}))

df$Population <- factor(df$Population, levels = pop_names)

png(file="C:/Users/kjlis/Desktop/LD2.png", width=2500, height=1800, res=300)
ggplot(df, aes(x = Distance, y = r2, color = Population)) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = colors) +
  coord_cartesian(xlim = c(0, 500), ylim = c(0, 1)) +
  labs(
    x = "distance (kb)",
    y = expression(bold(r^2)),
    color = "Subpopulation"
  ) +
  theme_classic() +
  theme(
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 13)),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 13)),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 14, face = "bold"),
    legend.text = element_text(size = 14),
    legend.key.size = unit(1, "cm"),
    legend.position = c(0.98, 0.98),
    legend.justification = c(1, 1)
  )
dev.off()


get_ld_decay <- function(data, threshold = 0.2){
  data$dist_kb <- data[,1] / 1000
  data$r2 <- data[,2]
  idx <- which(data$r2 <= threshold)[1]
  return(data$dist_kb[idx])
}
sapply(datasets, get_ld_decay)
