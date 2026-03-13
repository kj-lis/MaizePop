fst <- read.table("/home/kuba/Desktop/Parviglumis_Tropical_fst.fst", header=TRUE)
head(fst)
str(fst)

hist(fst$Fst,
     breaks=100,
     col="steelblue",
     main="Distribution of FST",
     xlab="FST")

install.packages("qqman")
library(qqman)

fst2 <- fst
fst2 <- fst2[!is.na(fst2$Fst), ]
fst2$Fst[fst2$Fst < 0] <- 0

manhattan(fst2,
          chr="Chr",
          bp="bp",
          snp="SNP",
          p="Fst",
          logp=FALSE,
          col=c("darkblue","orange"),
          ylab="FST")