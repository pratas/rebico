#!/bin/bash
###############################################################################
# DOWNLOAD DATA: IT WILL DOWNLOAD +\- 1 TB
# DEPENDENCIES: GOOSE FRAMEWORK, wget, git, gunzip, external online links
###############################################################################
DOWNLOAD_GOOSE=1;
#
DOWNLOAD_SEQ=1;
DOWNLOAD_FASTA=1;
DOWNLOAD_FASTQ=1;
DOWNLOAD_BAM=1;
# URL SHORTCUTS ===============================================================
EBI="ftp://ftp.sra.ebi.ac.uk/vol1";
# =============================================================================
mkdir -p datasets
# =============================================================================
rm -fr tmp/
mkdir tmp
cd tmp/
# =============================================================================
# GET GOOSE DOWNLOAD SCRIPTS ==================================================
if [[ "$DOWNLOAD_GOOSE" -eq "1" ]]; then
git clone https://github.com/pratas/goose.git
cd goose/src/
make
cd ../../
fi
# =============================================================================
###############################################################################
############################## DOWNLOAD DATASETS ##############################
###############################################################################
# DOWNLOAD SEQ ================================================================
if [[ "$DOWNLOAD_SEQ" -eq "1" ]]; then
cp goose/src/goose-renamehumanheaders .
cp goose/scripts/GetHumanParse.sh .
cp goose/scripts/GetHumanCHMParse.sh .
cp goose/scripts/GetChimpParse.sh .
cp goose/scripts/GetOSativaV5.sh .
cp goose/scripts/GetOSativaV7.sh .
. GetHumanParse.sh
rm -f ../datasets/human.fna
for((x=1 ; x<=22 ; ++x));
  do 
  cat HS$x >> ../datasets/human.fna;
  done
  cat HS23 >> ../datasets/human.fna;
  cat HS24 >> ../datasets/human.fna;
./goose-renamehumanheaders < ../datasets/human.fna > ../datasets/humanDZ.fna
. GetHumanCHMParse.sh
cat CHM* > ../datasets/human2.fna;
. GetChimpParse.sh
cat PT* > ../datasets/chimpanze.fna;
. GetOSativaV5.sh
cat OS5-* > ../datasets/rice5.fna;
. GetOSativaV7.sh
cat OS7-* > ../datasets/rice7.fna;
# * HUMAN GENOME CITATION:
#
# * RICE GENOME CITATION:
# Ouyang,S., Zhu,W., Hamilton,J., Lin,H., Campbell,M., Childs,K.,
# Thibaud-Nissen,F., Malek,R.L., Lee,Y., Zheng,L. et al . (2007) The TIGR Rice 
# Genome Annotation Resource: improvements and new features. NAR, 35, D883–D887
fi
###############################################################################
# DOWNLOAD FASTA ==============================================================
if [[ "$DOWNLOAD_FASTA" -eq "1" ]]; then
# GET CAMERA DATA (MULTI-FASTA: 43 GB) ========================================
rm -fr 10572.V10.fa.gz;
wget ftp://ftp.imicrobe.us/camera/camera_reference_datasets/10572.V10.fa.gz
gunzip 10572.V10.fa.gz
mv 10572.V10.fa ../datasets/camera.fa
fi
###############################################################################
# DOWNLOAD FASTQ ==============================================================
if [[ "$DOWNLOAD_FASTQ" -eq "1" ]]; then
wget $EBI/fastq/ERR194/ERR194146/ERR194146_1.fastq.gz # 51x
gunzip ERR194146_1.fastq.gz;
mv ERR194146_1.fastq ../datasets/
wget $EBI/fastq/ERR194/ERR194146/ERR194146_2.fastq.gz # 51x
gunzip ERR194146_2.fastq.gz;
mv ERR194146_2.fastq ../datasets/
wget $EBI/fastq/ERR174/ERR174310/ERR174310_1.fastq.gz # 7x [MPEG standard]
gunzip ERR174310_1.fastq.gz;
mv ERR174310_1.fastq ../datasets/
wget $EBI/fastq/ERR174/ERR174310/ERR174310_2.fastq.gz # 7x [MPEG standard]
gunzip ERR174310_2.fastq.gz;
mv ERR174310_2.fastq ../datasets/
fi
###############################################################################
# DOWNLOAD BAM ================================================================
if [[ "$DOWNLOAD_BAM" -eq "1" ]]; then
wget $EBI/ERA207/ERA207860/bam/NA12877_S1.bam # 122G #52x [MPEG standard]
mv NA12877_S1.bam ../datasets/
wget $EBI/ERA207/ERA207860/bam/NA12878_S1.bam # 114G #52x [MPEG standard]
mv NA12878_S1.bam ../datasets/
wget $EBI/ERA207/ERA207860/bam/NA12882_S1.bam # 101G #52x [MPEG standard]
mv NA12882_S1.bam ../datasets/
wget $EBI/ERA242/ERA242167/bam/9827_2%2349.bam -O ERR317482.bam # 1.9x
mv ERR317482.bam ../datasets/ # [MPEG standard]
fi
###############################################################################
cd ..
# =============================================================================

