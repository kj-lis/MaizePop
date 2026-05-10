java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr1_maf005_miss025.vcf.gz out=chr1_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr2_maf005_miss025.vcf.gz out=chr2_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr3_maf005_miss025.vcf.gz out=chr3_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr4_maf005_miss025.vcf.gz out=chr4_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr5_maf005_miss025.vcf.gz out=chr5_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr6_maf005_miss025.vcf.gz out=chr6_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr7_maf005_miss025.vcf.gz out=chr7_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr8_maf005_miss025.vcf.gz out=chr8_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr9_maf005_miss025.vcf.gz out=chr9_imputed nthreads=12
java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr10_maf005_miss025.vcf.gz out=chr10_imputed nthreads=12


echo '##contig=<ID=chr1>' > chr1.hdr
echo '##contig=<ID=chr2>' > chr2.hdr
echo '##contig=<ID=chr3>' > chr3.hdr
echo '##contig=<ID=chr4>' > chr4.hdr
echo '##contig=<ID=chr5>' > chr5.hdr
echo '##contig=<ID=chr6>' > chr6.hdr
echo '##contig=<ID=chr7>' > chr7.hdr
echo '##contig=<ID=chr8>' > chr8.hdr
echo '##contig=<ID=chr9>' > chr9.hdr
echo '##contig=<ID=chr10>' > chr10.hdr

bcftools annotate --header-lines chr1.hdr -Oz -o chr1_fixed.vcf.gz chr1_imputed.vcf.gz
bcftools annotate --header-lines chr2.hdr -Oz -o chr2_fixed.vcf.gz chr2_imputed.vcf.gz
bcftools annotate --header-lines chr3.hdr -Oz -o chr3_fixed.vcf.gz chr3_imputed.vcf.gz
bcftools annotate --header-lines chr4.hdr -Oz -o chr4_fixed.vcf.gz chr4_imputed.vcf.gz
bcftools annotate --header-lines chr5.hdr -Oz -o chr5_fixed.vcf.gz chr5_imputed.vcf.gz
bcftools annotate --header-lines chr6.hdr -Oz -o chr6_fixed.vcf.gz chr6_imputed.vcf.gz
bcftools annotate --header-lines chr7.hdr -Oz -o chr7_fixed.vcf.gz chr7_imputed.vcf.gz
bcftools annotate --header-lines chr8.hdr -Oz -o chr8_fixed.vcf.gz chr8_imputed.vcf.gz
bcftools annotate --header-lines chr9.hdr -Oz -o chr9_fixed.vcf.gz chr9_imputed.vcf.gz
bcftools annotate --header-lines chr10.hdr -Oz -o chr10_fixed.vcf.gz chr10_imputed.vcf.gz

