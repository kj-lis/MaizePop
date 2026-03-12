read.table("zea_LD6.bin")->data
pdf("zea_LD6.pdf")
plot(data[,1]/1000,data[,2],type="l",col="blue",main="LD decay",xlab="Distance(Kb)",xlim=c(0,1000),ylab=expression(r^{2}),bty="n",lwd=2)
dev.off()
png("zea_LD6.png")
plot(data[,1]/1000,data[,2],type="l",col="blue",main="LD decay",xlab="Distance(Kb)",xlim=c(0,1000),ylab=expression(r^{2}),bty="n",lwd=2)
dev.off()

