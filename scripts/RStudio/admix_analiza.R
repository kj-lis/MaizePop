Q <- read.table("C:/Users/kjlis/Desktop/chr_all_admix_2.9.Q")
fam <- read.table("C:/Users/kjlis/Desktop/chr_all_admix_2.fam")
metadane <- read.csv("C:/Users/kjlis/Desktop/metadane_all.csv", stringsAsFactors = FALSE, sep = ";")

colnames(fam)[2] <- "ID"

metadane_ordered <- metadane[match(fam$ID, metadane$VCFname), ]
all(fam$ID == metadane_ordered$VCFname)

colnames(Q) <- paste0("K",1:9)
admix <- cbind(metadane_ordered, Q)

idx <- which(names(admix) == "subpopulation")
admix <- cbind(
  admix[, 1:idx],
  assigned_cluster = max.col(Q),
  admix[, (idx+1):ncol(admix)])

write.csv(admix, "C:/Users/kjlis/Desktop/admix_K9.csv", row.names=FALSE)

