# DOWNLOAD
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_ref_GRCh38.p2_chr8.fa.gz -O HS8.fa.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_alt_CHM1_1.1_chr8.fa.gz -O HSCHM8.fa.gz
#
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_ref_GRCh38.p2_chr11.fa.gz -O HS11.fa.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_alt_CHM1_1.1_chr11.fa.gz -O HSCHM11.fa.gz
#
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_ref_GRCh38.p2_chr16.fa.gz -O HS16.fa.gz
wget ftp://ftp.kobic.re.kr/pub/KOBIC-KoreanGenome/fasta/chromosome_16.fa.gz -O HSK16.fa.gz
#
# HUMAN 11 ALREADY DOWNLOADED
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Pan_troglodytes/Assembled_chromosomes/seq/ptr_ref_Pan_tro_3.0_chr11.fa.gz -O PT11.fa.gz
#
# PARSE =======================================================================
echo "> X" > HEADER
#
zcat HS8.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HS8;
mv HS8 datasets/
zcat HSCHM8.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HSCHM8;
mv HSCHM8 datasets/
#
zcat HS11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HS11;
mv HS11 datasets/
zcat HSCHM11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HSCHM11;
mv HSCHM11 datasets/
#
zcat HS16.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HS16;
mv HS16 datasets/
zcat HSK16.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HSK16;
mv HSK16 datasets/
#
zcat PT11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > PT11;
mv PT11 datasets/
#
# RUN =========================================================================




# 











