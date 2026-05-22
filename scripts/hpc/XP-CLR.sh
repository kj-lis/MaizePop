for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr${i}_Pv_Tr -w1 0.02 200 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr${i}_Tr_Idt_1 -w1 0.02 200 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr${i}_Tr_SS_1 -w1 0.02 200 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr${i}_Idt_1vs2 -w1 0.02 200 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr${i}_SS_1vs2 -w1 0.02 200 10000 ${i} -p0 0.95; done


nohup bash -c 'for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Pv_Tr/chr${i}_Pv_Tr -w1 0.02 200 10000 ${i} -p0 0.95) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Tr_Idt_1/chr${i}_Tr_Idt_1 -w1 0.02 200 10000 ${i} -p0 0.95) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Tr_SS_1/chr${i}_Tr_SS_1 -w1 0.02 200 10000 ${i} -p0 0.95) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/Idt_1vs2/chr${i}_Idt_1vs2 -w1 0.02 200 10000 ${i} -p0 0.95) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; for i in {1..10}; do (/home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/SS_1vs2/chr${i}_SS_1vs2 -w1 0.02 200 10000 ${i} -p0 0.95) & if (( $(jobs -r | wc -l) >= 4 )); then wait -n; fi; done; wait' > /home/kuba/Desktop/XP_CLR_out/xpclr_batch.log 2>&1 &

ps aux | grep XPCLR
tail -f /home/kuba/Desktop/XP_CLR_out/xpclr_batch.log
pkill -f XPCLR


grep -H "Segmentation" xpclr_batch.log
wc -l *.wtclr.txt

tail chr1_Pv_Tr.wtclr.txt
sed -i '$d' chr1_Pv_Tr.wtclr.txt