perl /home/jl430796/software/PopLDdecay/bin/Plot_OnePop.pl -inFile /home/jl430796/MaizePop/data/processed/03_LDdecay/zea_LD1.stat.gz -output   /home/jl430796/MaizePop/results/full/zea_LD1



read.table("/home/kuba/Desktop/zea_LD1.bin")->data1
read.table("/home/kuba/Desktop/zea_LD2.bin")->data2
read.table("/home/kuba/Desktop/zea_LD3.bin")->data3
read.table("/home/kuba/Desktop/zea_LD4.bin")->data4
read.table("/home/kuba/Desktop/zea_LD5.bin")->data5
read.table("/home/kuba/Desktop/zea_LD6.bin")->data6
read.table("/home/kuba/Desktop/zea_LD7.bin")->data7

datasets <- list(data1, data2, data3, data4, data5, data6, data7)

pop_names <- c("Iodent","SS","NSS","Tropical","Mix","Parviglumis","Mexicana")
colors <- c("#00BF7D","#00B0F6","#F8766D","#E76BF3","#A3A500","#12E9E3","#f09a4a")

pdf("/home/kuba/Desktop/LD_all.pdf")
plot(1, type="n", xlim=c(0,1000), ylim=c(0,1),
     xlab="Distance (Kb)", ylab=expression(r^2),
     main="LD decay", bty="n")

for(i in seq_along(datasets)){
  lines(datasets[[i]][,1]/1000, datasets[[i]][,2], col=colors[i], lwd=2)
}

legend("topright", legend=pop_names, col=colors, lwd=2)
dev.off()