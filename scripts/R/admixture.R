Q <- read.table("/home/kuba/Desktop/full/chr_zea_mays_all_plink_3.5.Q")

metadane <- read.csv("/home/kuba/Desktop/zmays_metadane_PCA.csv", header=T)
metadane_unique <- metadane[!duplicated(metadane$VCFname), ]

colnames(Q) <- paste0("K",1:5)
data <- cbind(metadane_unique$VCFname, Q)
colnames(data)[1] <- "ID"

data$Assigned_cluster <- apply(Q, 1, which.max)
merged <- merge(data, metadane_unique, by.x="ID", by.y="VCFname")

write.csv(merged, "/home/kuba/Desktop/admixture_5.csv", row.names=FALSE)

polish_lines <- merged[merged$orygin == "Poland", ]
write.csv(polish_lines, "/home/kuba/Desktop/admixture_5_polish.csv", row.names=FALSE)

polish <- subset(merged, orygin=="Poland")
table(polish$Assigned_cluster)


#############################

K <- max(merged$Assigned_cluster)

for(i in 1:K){
  cluster_ids <- merged$ID[merged$Assigned_cluster == i]
    writeLines(cluster_ids, paste0("/home/kuba/Desktop/", i, "_IDs.txt"))
}
