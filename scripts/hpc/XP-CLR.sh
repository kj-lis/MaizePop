nohup bash -c 'mkdir -p /home/kuba/Desktop/XP_CLR_out/{Pv_Tr,Tr_Idt_1,Tr_SS_1,Idt_1vs2,SS_1vs2}; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_test/Pv_Tr/chr${i}_Pv_Tr -w1 0.02 200 10000 ${i} -p1 0.95) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_test/Tr_Idt_1/chr${i}_Tr_Idt_1 -w1 0.005 200 10000 ${i} -p1 0.70) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_test/Tr_SS_1/chr${i}_Tr_SS_1 -w1 0.005 200 10000 ${i} -p1 0.70) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_test/Idt_1vs2/chr${i}_Idt_1vs2 -w1 0.005 200 10000 ${i} -p1 0.70) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_test/SS_1vs2/chr${i}_SS_1vs2 -w1 0.005 200 10000 ${i} -p1 0.70) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; wait' > /home/kuba/Desktop/XP_CLR_test/xpclr_batch.log 2>&1 &

ps aux | grep XPCLR
tail -f /home/kuba/Desktop/XP_CLR_test/xpclr_batch.log
pkill -f XPCLR

grep -H "Segmentation" xpclr_batch.log
wc -l *.wtclr.txt

################################

tail chr1_Pv_Tr.wtclr.txt
tail chr1_Tr_Idt_1.wtclr.txt
tail chr1_Tr_SS_1.wtclr.txt
tail chr1_Idt_1vs2.wtclr.txt
tail chr1_SS_1vs2.wtclr.txt

sed -i '$d' chr1_Pv_Tr.wtclr.txt
sed -i '$d' chr1_Tr_Idt_1.wtclr.txt
sed -i '$d' chr1_Tr_SS_1.wtclr.txt
sed -i '$d' chr1_Idt_1vs2.wtclr.txt
sed -i '$d' chr1_SS_1vs2.wtclr.txt

################################

(head -n 1 chr1_Pv_Tr.wtclr.txt && for i in {1..10}; do tail -n +2 chr${i}_Pv_Tr.wtclr.txt; done) > Pv_Tr.wtclr.txt
(head -n 1 chr1_Tr_Idt_1.wtclr.txt && for i in {1..10}; do tail -n +2 chr${i}_Tr_Idt_1.wtclr.txt; done) > Tr_Idt_1.wtclr.txt
(head -n 1 chr1_Tr_SS_1.wtclr.txt && for i in {1..10}; do tail -n +2 chr${i}_Tr_SS_1.wtclr.txt; done) > Tr_SS_1.wtclr.txt
(head -n 1 chr1_Idt_1vs2.wtclr.txt && for i in {1..10}; do tail -n +2 chr${i}_Idt_1vs2.wtclr.txt; done) > Idt_1vs2.wtclr.txt
(head -n 1 chr1_SS_1vs2.wtclr.txt && for i in {1..10}; do tail -n +2 chr${i}_SS_1vs2.wtclr.txt; done) > SS_1vs2.wtclr.txt

################################

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_test/Pv_Tr/chr${i}_Pv_Tr -w1 0.005 200 10000 ${i} -p1 0.70; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr${i}_Tr_Idt_1 -w1 0.02 200 10000 ${i} -p1 0.70; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr${i}_Tr_SS_1 -w1 0.02 200 10000 ${i} -p1 0.70; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr${i}_Idt_1vs2 -w1 0.02 200 10000 ${i} -p1 0.70; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr${i}_SS_1vs2 -w1 0.005 200 1000 ${i} -p1 0.70; done

################################

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr1_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr1_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr1.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr1_Pv_Tr -w1 0.02 200 10000 1 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr2_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr2_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr2.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr2_Pv_Tr -w1 0.02 200 10000 2 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr3_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr3_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr3.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr3_Pv_Tr -w1 0.02 200 10000 3 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr4_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr4_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr4.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr4_Pv_Tr -w1 0.02 200 10000 4 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr5_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr5_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr5.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr5_Pv_Tr -w1 0.02 200 10000 5 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr6_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr6_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr6.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr6_Pv_Tr -w1 0.02 200 10000 6 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr7_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr7_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr7.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr7_Pv_Tr -w1 0.02 200 10000 7 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr8_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr8_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr8.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr8_Pv_Tr -w1 0.02 200 10000 8 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr9_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr9_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr9.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr9_Pv_Tr -w1 0.02 200 10000 9 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr10_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr10_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr10.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr10_Pv_Tr -w1 0.02 200 10000 10 -p0 0.95

################################

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr1_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr1_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr1.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr1_Tr_Idt_1 -w1 0.02 200 10000 1 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr2_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr2_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr2.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr2_Tr_Idt_1 -w1 0.02 200 10000 2 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr3_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr3_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr3.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr3_Tr_Idt_1 -w1 0.02 200 10000 3 -p0 0.95 
s
/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr4_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr4_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr4.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr4_Tr_Idt_1 -w1 0.02 200 10000 4 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr5_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr5_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr5.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr5_Tr_Idt_1 -w1 0.02 200 10000 5 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr6_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr6_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr6.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr6_Tr_Idt_1 -w1 0.02 200 10000 6 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr7_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr7_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr7.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr7_Tr_Idt_1 -w1 0.02 200 10000 7 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr8_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr8_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr8.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr8_Tr_Idt_1 -w1 0.02 200 10000 8 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr9_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr9_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr9.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr9_Tr_Idt_1 -w1 0.02 200 10000 9 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr10_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr10_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr10.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr10_Tr_Idt_1 -w1 0.02 200 10000 10 -p0 0.95

################################

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr1_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr1_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr1.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr1_Tr_SS_1 -w1 0.02 200 10000 1 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr2_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr2_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr2.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr2_Tr_SS_1 -w1 0.02 200 10000 2 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr3_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr3_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr3.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr3_Tr_SS_1 -w1 0.02 200 10000 3 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr4_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr4_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr4.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr4_Tr_SS_1 -w1 0.02 200 10000 4 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr5_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr5_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr5.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr5_Tr_SS_1 -w1 0.02 200 10000 5 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr6_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr6_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr6.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr6_Tr_SS_1 -w1 0.02 200 10000 6 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr7_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr7_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr7.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr7_Tr_SS_1 -w1 0.02 200 10000 7 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr8_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr8_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr8.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr8_Tr_SS_1 -w1 0.02 200 10000 8 -p0 0.95 

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr9_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr9_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr9.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr9_Tr_SS_1 -w1 0.02 200 10000 9 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr10_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr10_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr10.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr10_Tr_SS_1 -w1 0.02 200 10000 10 -p0 0.95

################################

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr1_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr1_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr1.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr1_Idt_1vs2 -w1 0.02 200 10000 1 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr2_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr2_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr2.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr2_Idt_1vs2 -w1 0.02 200 10000 2 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr3_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr3_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr3.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr3_Idt_1vs2 -w1 0.02 200 10000 3 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr4_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr4_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr4.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr4_Idt_1vs2 -w1 0.02 200 10000 4 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr5_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr5_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr5.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr5_Idt_1vs2 -w1 0.02 200 10000 5 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr6_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr6_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr6.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr6_Idt_1vs2 -w1 0.02 200 10000 6 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr7_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr7_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr7.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr7_Idt_1vs2 -w1 0.02 200 10000 7 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr8_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr8_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr8.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr8_Idt_1vs2 -w1 0.02 200 10000 8 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr9_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr9_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr9.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr9_Idt_1vs2 -w1 0.02 200 10000 9 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr10_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr10_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr10.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr10_Idt_1vs2 -w1 0.02 200 10000 10 -p0 0.95

################################

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr1_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr1_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr1.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr1_SS_1vs2 -w1 0.02 200 10000 1 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr2_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr2_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr2.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr2_SS_1vs2 -w1 0.02 200 10000 2 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr3_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr3_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr3.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr3_SS_1vs2 -w1 0.02 200 10000 3 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr4_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr4_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr4.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr4_SS_1vs2 -w1 0.02 200 10000 4 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr5_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr5_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr5.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr5_SS_1vs2 -w1 0.02 200 10000 5 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr6_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr6_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr6.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr6_SS_1vs2 -w1 0.02 200 10000 6 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr7_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr7_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr7.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr7_SS_1vs2 -w1 0.02 200 10000 7 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr8_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr8_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr8.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr8_SS_1vs2 -w1 0.02 200 10000 8 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr9_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr9_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr9.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr9_SS_1vs2 -w1 0.02 200 10000 9 -p0 0.95

/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr10_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr10_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr10.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr10_SS_1vs2 -w1 0.02 200 10000 10 -p0 0.95

