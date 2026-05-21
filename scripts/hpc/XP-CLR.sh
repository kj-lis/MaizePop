for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Parviglumis.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/chr${i}_Pv_Tr -w1 0.02 800 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/chr${i}_Tr_Idt_1 -w1 0.02 800 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Tropical.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/chr${i}_Tr_SS_1 -w1 0.02 800 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_Iodent_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/chr${i}_Idt_1vs2 -w1 0.02 800 10000 ${i} -p0 0.95; done

for i in {1..10}; do /home/kuba/Desktop/xp./xp/XPCLR -xpclr /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_2.geno /home/kuba/Desktop/05_XP_CLR/chr${i}_SS_1.geno /home/kuba/Desktop/XP_CLR_mapa/chr${i}.snp /home/kuba/Desktop/XP_CLR_out/chr${i}_SS_1vs2 -w1 0.02 800 10000 ${i} -p0 0.95; done