#Header & id included command for creating sam file

bwa mem -t 8 -R "@RG\tID:SRR30031098\tPL:ILLUMINA\tSM:SRR30031098"  GCF_000195955.2_ASM19595v2_genomic.fna SRR30031098_1.fastq SRR30031098_2.fastq > output.sam

# perform dedup function using GATK MarkDuplicates

#/home/sujathnair/tools/gatk-4.6.0.0/gatk MarkDuplicatesSpark --input /home/sujathnair/tools/sratoolkit.3.1.1-ubuntu64/bin/SRR30031098/output.sam --output de_dupe.bam



#We have omitted the Base Quality Recalibration because there are no vcf files available for Mycobacterium tuberculosis.

#It doesn't reduce the accuracy too much



#Variant Calling
#Variant Calling

#/home/sujathnair/tools/gatk-4.6.0.0/gatk HaplotypeCaller -R /home/sujathnair/tools/sratoolkit.3.1.1-ubuntu64/bin/SRR30031098/GCF_000195955.2_ASM19595v2_genomic.fna -I /home/sujathnair/de_dupe.bam -O /home/sujathnair/variants.vcf





#Separating variants

#/home/sujathnair/tools/gatk-4.6.0.0/gatk SelectVariants -R /home/sujathnair/tools/sratoolkit.3.1.1-ubuntu64/bin/SRR30031098/GCF_000195955.2_ASM19595v2_genomic.fna -V /home/sujathnair/variants.vcf --select-type SNP -O /home/sujathnair/res_SNP.vcf;



#/home/sujathnair/tools/gatk-4.6.0.0/gatk SelectVariants -R /home/sujathnair/tools/sratoolkit.3.1.1-ubuntu64/bin/SRR30031098/GCF_000195955.2_ASM19595v2_genomic.fna -V /home/sujathnair/variants.vcf --select-type INDEL -O /home/sujathnair/res_INDEL.vcf;



#Variant Filteration

#/home/sujathnair/tools/gatk-4.6.0.0/gatk VariantFiltration -R /home/sujathnair/tools/sratoolkit.3.1.1-ubuntu64/bin/SRR30031098/GCF_000195955.2_ASM19595v2_genomic.fna -V /home/sujathnair/res_SNP.vcf -O /home/sujathnair/filtered_SNP.vcf -filter-name "QD_filter" -filter "QD< 2.0" -filter-name "FS_filter" -filter "FS > 50.0" -filter-name "MQ_filter" -filter "MQ < 40.0" -filter-name "SOR_filter" -filter "SOR > 3.0" -genotype-filter-expression "DP < 10" -genotype-filter-name "DP_filter" -genotype-filter-expression "GQ < 10" -genotype-filter-name "GQ_filter"



#/home/sujathnair/tools/gatk-4.6.0.0/gatk VariantFiltration -R /home/sujathnair/tools/sratoolkit.3.1.1-ubuntu64/bin/SRR30031098/GCF_000195955.2_ASM19595v2_genomic.fna -V /home/sujathnair/res_INDEL.vcf -O /home/sujathnair/filtered_INDELS.vcf -filter-name "QD_filter" -filter "QD< 2.0" -filter-name "FS_filter" -filter "FS > 50.0" -filter-name "SOR_filter" -filter "SOR > 3.0" -genotype-filter-expression "DP < 10" -genotype-filter-name "DP_filter" -genotype-filter-expression "GQ < 10" -genotype-filter-name "GQ_filter"

#Excluding filtered variants

#/home/sujathnair/tools/gatk-4.6.0.0/gatk SelectVariants --exclude-filtered -V /home/sujathnair/filtered_SNP.vcf -O /home/sujathnair/filter_removed_SNP.vcf

#/home/sujathnair/tools/gatk-4.6.0.0/gatk SelectVariants --exclude-filtered -V /home/sujathnair/filtered_INDELS.vcf -O /home/sujathnair/filter_removed_INDELS.vcf

#Segregating filter passed variants

#cat filter_removed_INDELS.vcf| grep -v -E "DP_filter|GQ_filter" > filter_passed_INDELS.vcf
 cat filter_removed_SNP.vcf| grep -v -E "DP_filter|GQ_filter" > filter_passed_SNP.vcf

#Merging passed variant files

/home/sujathnair/tools/gatk-4.6.0.0/gatk MergeVcfs I=/home/sujathnair/filter_passed_SNP.vcf I=/home/sujathnair/filter_passed_INDELS.vcf O=/home/sujathnair/merged_variants.vcf

