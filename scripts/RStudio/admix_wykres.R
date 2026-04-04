order <- scan("C:/Users/kjlis/Desktop/admix_kolejnosc.txt", what="character")
fam <- read.table("C:/Users/kjlis/Desktop/chr_all_zmays_plink_3.fam")
tbl <- read.table("C:/Users/kjlis/Desktop/chr_all_zmays_plink_3.7.Q")

rownames(tbl) <- fam$V2
tbl <- tbl[order, ]

my_colors <- c(
  V1 = "#00BF7D",
  V2 = "#00B0F6",
  V3 = "#F8766D",
  V4 = "#F8766D",
  V5 = "#00B0F6",
  V6 = "#E76BF3",
  V7 = "#00BF7D")

cluster_labels <- c(
  V1 = "Iodent",
  V2 = "SS",
  V3 = "NSS",
  V4 = "NSS",
  V5 = "SS",
  V6 = "Tropical",
  V7 = "Iodent")

axis_label_size <- 1.5
axis_text_size  <- 1.3
legend_text_size <- 1.2 

barplot(
  t(as.matrix(tbl)),
  col = my_colors,
  border = NA,
  ylab = "Ancestry",
  xaxt = "n",
  cex.lab = axis_label_size,
  cex.axis = axis_text_size)

legend_colors <- my_colors[!names(my_colors) %in% c("V1","V4","V5")]
legend_labels <- cluster_labels[!names(cluster_labels) %in% c("V1","V4","V5")]

legend(
  "topright",
  legend = legend_labels,
  fill = legend_colors,
  border = NA,
  bty = "n",
  title = "Heterotic group",
  cex = legend_text_size)


plot.new()
legend(
  "center",
  legend = legend_labels,
  fill = legend_colors,
  border = NA,
  bty = "n",
  title = "Heterotic group",
  ncol = length(legend_labels))

