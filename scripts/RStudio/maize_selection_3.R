library(data.table)
library(gprofiler2)

project_dir <- "C:/Users/kjlis/Desktop/maize_selection/"

genes <- fread(paste0(project_dir, "results_1/top1/XP_CLR_top1_genes.csv"))

gene_lists <- split(genes$Gene_ID,genes$Comparison)
gene_lists <- lapply(gene_lists,unique)

writeClipboard(paste(gene_lists$Pv_Tr,collapse = "\n"))
writeClipboard(paste(gene_lists$Tr_Idt_1,collapse = "\n"))
writeClipboard(paste(gene_lists$Tr_SS_1,collapse = "\n"))
writeClipboard(paste(gene_lists$Idt_1vs2,collapse = "\n"))
writeClipboard(paste(gene_lists$SS_1vs2,collapse = "\n"))

################################

gostres_Pv_Tr <- gost(query = gene_lists$Pv_Tr,organism = "zmays")
gostres_Tr_Idt_1 <- gost(query = gene_lists$Tr_Idt_1,organism = "zmays")
gostres_Tr_SS_1 <- gost(query = gene_lists$Tr_SS_1,organism = "zmays")
gostres_Idt_1vs2 <- gost(query = gene_lists$Idt_1vs2,organism = "zmays")
gostres_SS_1vs2 <- gost(query = gene_lists$SS_1vs2,organism = "zmays")

head(gostres_Pv_Tr$result)
head(gostres_Tr_Idt_1$result)
head(gostres_Tr_SS_1$result)
head(gostres_Idt_1vs2$result)
head(gostres_SS_1vs2$result)

gostplot(gostres_Pv_Tr, capped = FALSE, interactive = FALSE)
gostplot(gostres_Tr_Idt_1, capped = FALSE, interactive = FALSE)
gostplot(gostres_Tr_SS_1, capped = FALSE, interactive = FALSE)
gostplot(gostres_Idt_1vs2, capped = FALSE, interactive = FALSE)
gostplot(gostres_SS_1vs2, capped = FALSE, interactive = FALSE)

