#nieaktualne

Q <- read.table("/home/kuba/Desktop/zmays/admix/chr_all_zmays_plink_3.7.Q")
metadane <- read.csv("/home/kuba/Desktop/zmays_uniq.csv", stringsAsFactors = FALSE, sep = ";")

colnames(Q) <- paste0("K",1:7)
data <- cbind(metadane$VCFname, Q)
colnames(data)[1] <- "ID"

all(metadane$VCFname == data$ID)

data$Assigned_cluster <- apply(Q, 1, which.max)
merged <- merge(data, metadane, by.x="ID", by.y="VCFname")

write.csv(merged, "/home/kuba/Desktop/zmays_admix7.csv", row.names=FALSE)
table(merged$Assigned_cluster)
table(merged$Assigned_cluster, merged$Q)

polish_lines <- merged[merged$origin == "Poland", ]
write.csv(polish_lines, "/home/kuba/Desktop/zmays_admix7_pl.csv", row.names=FALSE)
table(polish_lines$Assigned_cluster)

K <- max(merged$Assigned_cluster)

for(i in 1:K){
  cluster_ids <- merged$ID[merged$Assigned_cluster == i]
  writeLines(cluster_ids, paste0("/home/kuba/Desktop/zea", i, "_IDs.txt"))
}