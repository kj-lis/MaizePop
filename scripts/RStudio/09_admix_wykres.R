order <- scan("C:/Users/kjlis/Desktop/kolejność.txt", what="character")
fam <- read.table("C:/Users/kjlis/Desktop/chr_all_zmays.fam")
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

barplot(t(as.matrix(tbl)), col = my_colors, border = NA, xlab = "Line", ylab = "Ancestry", xaxt = "n")