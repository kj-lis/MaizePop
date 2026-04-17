################################


perl /home/jl430796/software/PopLDdecay/bin/Plot_OnePop.pl -inFile LD1.stat.gz -output ./LD1


################################


read.table("C:/Users/kjlis/Desktop/LD/LD1.bin")->data1
read.table("C:/Users/kjlis/Desktop/LD/LD2.bin")->data2
read.table("C:/Users/kjlis/Desktop/LD/LD3.bin")->data3
read.table("C:/Users/kjlis/Desktop/LD/LD4.bin")->data4
read.table("C:/Users/kjlis/Desktop/LD/LD5.bin")->data5
read.table("C:/Users/kjlis/Desktop/LD/LD6.bin")->data6
read.table("C:/Users/kjlis/Desktop/LD/LD7.bin")->data7


datasets <- list(data1, data2, data3, data4, data5, data6, data7)

pop_names <- c("Iodent","SS","NSS","Tropical","Mix","Parviglumis","Mexicana")
colors <- c("green3","blue","red","purple","gold","cyan3","darkorange")


axis_label_size <- 1.5
axis_text_size  <- 1.5
main_title_size <- 1.8
legend_text_size <- 1.5

png("C:/Users/kjlis/Desktop/LD_all.png", width=1600, height=1200, res=150)

par(mar=c(5,6,4,2))

plot(1, type="n", xlim=c(0,1000), ylim=c(0,1),
     xlab="Distance (Kb)", ylab=expression(r^2),
     main="LD decay", bty="n",
     cex.lab=axis_label_size,
     cex.axis=axis_text_size,
     cex.main=main_title_size)

for(i in seq_along(datasets)){
  lines(datasets[[i]][,1]/1000, datasets[[i]][,2], col=colors[i], lwd=3)
}

legend("topright", legend=pop_names, col=colors, lwd=5, bty="n", cex=legend_text_size)

dev.off()



pdf("C:/Users/kjlis/Desktop/LD.pdf")
plot(1, type="n", xlim=c(0,1000), ylim=c(0,1),
     xlab="Distance (kb)", ylab=expression(r^2),
     main="LD decay", bty="n")

for(i in seq_along(datasets)){
  lines(datasets[[i]][,1]/1000, datasets[[i]][,2], col=colors[i], lwd=2)
}

legend("topright", legend=pop_names, col=colors, lwd=2)
dev.off()

