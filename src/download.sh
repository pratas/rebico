#!/bin/bash
DOWNLOAD_SEQ=1;
DOWNLOAD_REF_SEQ=1;
DOWNLOAD_FASTA=1;
DOWNLOAD_FASTQ=1;
DOWNLOAD_BAM=1;
# =============================================================================
mkdir -p datasets
# =============================================================================
rm -fr tmp/
mkdir tmp
cd tmp/
###############################################################################
############################## DOWNLOAD DATASETS ##############################
###############################################################################
# DOWNLOAD SEQ ================================================================
if [[ "$DOWNLOAD_SEQ" -eq "1" ]]; then


fi
###############################################################################
# DOWNLOAD REF_SEQ ============================================================
if [[ "$DOWNLOAD_REF_SEQ" -eq "1" ]]; then


fi
###############################################################################
# DOWNLOAD FASTA ==============================================================
if [[ "$DOWNLOAD_FASTA" -eq "1" ]]; then
# GET HUMAN GENOME WITH GOOSE DOWNLOAD SCRIPTS ================================
git clone https://github.com/pratas/goose.git
cd goose/src/
make
cd ../scripts/
. GetHumanParse.sh
cat HS* > ../../../datasets/sapiens.seq;
cd ../../
# GET CAMERA DATA (MULTI-FASTA: 43 GB) ========================================
wget ftp://ftp.imicrobe.us/camera/camera_reference_datasets/10572.V10.fa.gz
gunzip 10572.V10.fa.gz
mv 10572.V10.fa ../datasets/camera.fa
fi
###############################################################################
# DOWNLOAD FASTQ ==============================================================
if [[ "$DOWNLOAD_FASTQ" -eq "1" ]]; then
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194146/ERR194146.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194146/ERR194146_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194146/ERR194146_2.fastq.gz
#wget ftp://ftp.sra.ebi.ac.uk/vol1/FASTQ/ERR174/ERR174310/ERR174310_1.FASTQ.gz
#wget ftp://ftp.sra.ebi.ac.uk/vol1/FASTQ/ERR174/ERR174310/ERR174310_2.FASTQ.gz
fi
###############################################################################
# DOWNLOAD BAM ================================================================
if [[ "$DOWNLOAD_BAM" -eq "1" ]]; then
wget ftp://ftp.sra.ebi.ac.uk/vol1/ERA207/ERA207860/bam/NA12877_S1.bam
wget ftp://ftp.sra.ebi.ac.uk/vol1/ERA207/ERA207860/bam/NA12878_S1.bam
wget ftp://ftp.sra.ebi.ac.uk/vol1/ERA207/ERA207860/bam/NA12882_S1.bam

#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
#wget ftp://ftp.sra.ebi.ac.uk/vol1/ERA172/ERA172924/bam/NA12877_S1.bam
#wget ftp://ftp.sra.ebi.ac.uk/vol1/ERA172/ERA172924/bam/NA12878_S1.bam
#wget ftp://ftp.sra.ebi.ac.uk/vol1/ERA172/ERA172924/bam/NA12890_S1.bam

fi
###############################################################################
cd ..
# =============================================================================
