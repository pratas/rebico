#!/bin/bash
###############################################################################
# SEQ : NORMAL
RUN_DNACOMPACT=1;
RUN_GECO=1;
RUN_COGI=1;
###############################################################################
# SEQ : REFERENCE
RUN_GECO_REF=1;
RUN_COGI_REF=1;
RUN_IDOCOMP=1;
RUN_FRESCO=1;
RUN_GREEN=1;
RUN_GRS=1;
RUN_GDC2=1;
RUN_ERGC=1;
###############################################################################
# FASTA
RUN_MFCOMPRESS=1;
RUN_DELIMINATE=1;
RUN_LEON=1;
###############################################################################
# FASTQ
RUN_FQZCOMP=1;
RUN_QUIP=1;
RUN_SCALCE=1;
RUN_ORCOM=1;
RUN_DSRC=1;
RUN_FQC=1;
RUN_LWFQZIP=1;
###############################################################################
# SAM/BAM
RUN_SAMCOMP=1;
RUN_DEEZ=1;
RUN_NGC=1;
###############################################################################
mkdir -p results
###############################################################################
############################## F U N C T I O N S ##############################
###############################################################################
# CHECK IF FILE EXISTS ========================================================
function FExists {
  file="$1"
  if [ ! -e "$file" ];
    then
    echo "ERROR: File $file does not exist!";
    return;
    fi
  }
# MEMORY1 =====================================================================
function ProgMemoryStart {
  echo "0" > mem_ps;
  while true
    do
    ps aux | grep $1 | head -n 1 | awk '{ print $6; }' >> mem_ps;
    sleep 5;
    done
  }
function ProgMemoryStop {
  kill $1 >/dev/null 2>&1
  cat mem_ps | sort -V | tail -n 1 > $2;
  }
# MEMORY2 =====================================================================
function ProgMemory2 {
  valgrind --tool=massif --pages-as-heap=yes --massif-out-file=massif.out ./$1; 
  cat massif.out | \
  grep mem_heap_B | \
  sed -e 's/mem_heap_B=\(.*\)/\1/' | \
  sort -g | \
  tail -n 1
  }
# TIME ========================================================================
function ProgTime {
  time ./$1
  }
###############################################################################
############################### CHECK DATASETS ################################
###############################################################################
FExists "datasets/human.fna"
FExists "datasets/human2.fna"
FExists "datasets/humanDZ.fna"
FExists "datasets/chimpanze.fna"
FExists "datasets/rice5.fna"
FExists "datasets/rice7.fna"
FExists "datasets/camera.fa"
#
FExists "datasets/ERR174310_1.fastq"
FExists "datasets/ERR174310_2.fastq"
FExists "datasets/ERR194146_1.fastq"
FExists "datasets/ERR194146_2.fastq"
#
FExists "datasets/NA12877_S1.bam"
FExists "datasets/NA12878_S1.bam"
FExists "datasets/NA12882_S1.bam"
FExists "datasets/ERR317482.bam"
###############################################################################
################################ RUN PROGRAMS #################################
###############################################################################
###
###                          REFERENCE COMPRESSION
###
###############################################################################
###
### FILES TO COMPRESS:
###   [+] human2.fna | human.fna
###   [+] human.fna  | chimpanze.fna
###   [+] rice5.fna  | rice7.fna
###
##############################################################################
if [[ "$RUN_IDOCOMP" -eq "1" ]]; then
mkdir -p results
cd progs/idocomp
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/human2.fna | grep -v ">" | tr -d -c "ACGT" > human2.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
cat ../../datasets/rice7.fna | grep -v ">" | tr -d -c "ACGT" > rice7.seq
# HUMAN

# Generating suffix array
echo "Generating suffix array ..."
cd idocomp/sais-lite-2.4.1/
mkdir sa ref;
cp ../../$1 ref/
./generateSA.sh ref sa
cd sa/
SANAME=`echo '*.sa'`;
cd ..
mkdir tar;
cp ../../$2 tar/
rm -f f.txt;
echo ref/$1 tar/$2 sa/$SANAME > f.txt;
echo "Compressing ..."
cd ../simulations/
mv ../sais-lite-2.4.1/f.txt .
mv ../sais-lite-2.4.1/ref/ .
mv ../sais-lite-2.4.1/tar/ .
mv ../sais-lite-2.4.1/sa/ .
./iDoComp.run c f.txt xxx



#
rm -f human.seq human2.seq chimpanze.seq rice5.seq rice7.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_GECO_REF" -eq "1" ]]; then
mkdir -p results
cd progs/geco
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/human2.fna | grep -v ">" | tr -d -c "ACGT" > human2.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
cat ../../datasets/rice7.fna | grep -v ">" | tr -d -c "ACGT" > rice7.seq
# HUMAN
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f human2.seq.co
(time ./GeCo -v -l 14 -r human.seq \
human2.seq ) &> ../../results/C_GECO_REF_HUMAN
ls -la human2.seq.co > ../../results/BC_GECO_REF_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_GECO_REF_HUMAN";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f human2.seq.de
(time ./GeCo -v -r human.seq \
human2.seq.co ) &> ../../results/D_GECO_REF_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_GECO_REF_HUMAN";
cmp human.seq human2.seq.de > ../../results/V_GECO_REF_HUMAN
# CHIMPANZEE
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f human.seq.co
(time ./GeCo -v -l 14 -r chimpanze.seq \
human.seq ) &> ../../results/C_GECO_REF_CHIMPANZE
ls -la human.seq.co > ../../results/BC_GECO_REF_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_GECO_REF_CHIMPANZE";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f human.seq.de
(time ./GeCo -v -r chimpanze.seq \
human.seq.co ) &> ../../results/D_GECO_REF_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_GECO_REF_CHIMPANZE";
cmp human.seq human.seq.de > ../../results/V_GECO_REF_CHIMPANZE
# RICE
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f rice5.seq.co
(time ./GeCo -v -l 14 -r rice7.seq \
rice5.seq ) &> ../../results/C_GECO_REF_RICE
ls -la rice5.seq.co > ../../results/BC_GECO_REF_RICE
ProgMemoryStop $MEMPID "../../results/MC_GECO_REF_RICE";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f rice5.seq.de
(time ./GeCo -v -r rice7.seq \
rice5.seq.co ) &> ../../results/D_GECO_REF_RICE
ProgMemoryStop $MEMPID "../../results/MD_GECO_REF_RICE";
cmp rice5.seq rice5.seq.de > ../../results/V_GECO_REF_RICE
#
rm -f human.seq human2.seq chimpanze.seq rice5.seq rice7.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_GREEN" -eq "1" ]]; then
# COMPRESSION -----------------------------------------------------------------
GREEN_PARAMETERS=" -v -i -k 16 -f 5 ";
ProgTime "GReEnC $GREEN_PARAMETERS -o TAR.green REF TAR" > TMP;
cat TMP | grep "number of bytes" | awk '{print $5}' > REPORT_GREEN_BITS;
cat TMP | grep "Total cpu time" | awk '{print $5}' > REPORT_GREEN_TIME;
ProgMemory "GReEnC $GREEN_PARAMETERS -o TAR.green REF TAR" > REPORT_GREEN_MEM;
# UNCOMPRESSION ---------------------------------------------------------------
./GReEnD -v -o OUT REF TAR.green
ProgMemory "GReEnD -v -o OUT REF TAR.green" >> REPORT_GREEN_MEM
fi
###############################################################################
if [[ "$RUN_COGI" -eq "1" ]]; then
compress -ur --hash -n <sequence count> <reference> <seq path1> ...
compress --mse -n <sequence count> <reference> <seq path1> ...
compress --bce -n <sequence count> <reference> <seq path1> ...
uncompress -r <reference file> -l [length of one line]
fi
###############################################################################
if [[ "$RUN_DNACOMPACT" -eq "1" ]]; then
./compact n [-N] infile 
#Command line options:N is the minimum match length, (default 25)
./compact n -d infile
#Default output is infile.y
#For reference-based compression:
./compact r c sourcefile reference leftWindowSize rightWindowSize
#Default leftWindowSize and rightWindowSize are adaptively obtained through 
#calculating the difference percentage between source sequence and reference 
#sequence.
./compact r d sourcefile reference
fi
###############################################################################
if [[ "$RUN_GDC" -eq "1" ]]; then
./GDC2 my_archive @files_list.txt
./GDC2 c -mp15,4 -i2 -t8 my_archive @files_list
./GDC2 d my_archive @files_list
./GDC2 d my_archive
./GDC2 l my_archive
fi
###############################################################################
if [[ "$RUN_ERGC" -eq "1" ]]; then
. SCRIPT_ERGC_COMP ..
. SCRIPT_ERGC_DECOMP ..
fi
###############################################################################
if [[ "$RUN_FRESCO" -eq "1" ]]; then
./FRESCO-BIN FRESCO/config.ini COMRESS /bio/uncompressed/ /bio/compressed/ 
./FRESCO-BIN FRESCO/config.ini DECOMRESS /bio/compressed/ /bio/decompressed/ 
fi
##############################################################################
if [[ "$RUN_GRS" -eq "1" ]]; then
cp REF.seq Compress/bin/
cp TAR.seq Compress/bin/
cd Compress/bin/
./GRS.sh REF.seq TAR.seq
cd ../../
cp REF.seq Decompress/bin/
echo "THIS IS REPUGNANT!";
fi
###############################################################################
#
##############################################################################
################################### FASTQ ####################################
##############################################################################
if [[ "$RUN_ORCOM" -eq "1" ]]; then
/orcom_bin e -f”NA19238_1.fastq NA19238_2.fastq” -oNA19238.bin
fi
###############################################################################
if [[ "$RUN_DSRC" -eq "1" ]]; then
./dsrc c SRR001471.fastq SRR001471.dsrc
./dsrc d SRR001471.dsrc SRR001471.out.fastq
fi
###############################################################################
if [[ "$RUN_FQC" -eq "1" ]]; then
./fqc -c -i sample.fastq -o tmp
./fqc -d -i tmp -o sample.out.fastq
fi
###############################################################################
if [[ "$RUN_FQZCOMP" -eq "1" ]]; then
./fqz_comp -s5+ -q3 -n2 < sample.fastq > out
./fqz_comp -d < out > sample.out.fastq
fi
###############################################################################
if [[ "$RUN_QUIP" -eq "1" ]]; then
./quip sample.fastq > out
./quip -d 
fi
##############################################################################
if [[ "$RUN_SCALCE" -eq "1" ]]; then
scalce input_1.fastq -o result
#Compress input_1.fastq to the files result.00_1.scalcen.gz, result.00_1.scalcer.gz 
#and result.00_1.scalceq.gz
scalce input_1.fastq -r -o result -n library
#Compress input_1.fastq together with its paired end input_2.fastq, discarding 
#the names and setting library name to library
scalce input_1.scalcen -d -o something.fastq
#Decompress the scalce file to something.fast
fi
##############################################################################
if [[ "$RUN_LWFQZIP" -eq "1" ]]; then
cd LWFQZip-v1.02/
./LWFQZip -c -i IN > OUT
./LWFQZip -d -i OUT > IN.2
fi
##############################################################################
#
##############################################################################
################################### FASTA ####################################
##############################################################################
###
### FILES TO COMPRESS:
###   [+] human.fna
###   [+] chimpanze.fna
###   [+] rice5.fna
###   [+] camera.fa
###
##############################################################################
if [[ "$RUN_DELIMINATE" -eq "1" ]]; then
mkdir -p results
cd progs/deliminate
# HUMAN
mv ../../datasets/human.fna .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f human.fna.dlim
(time ./delim a human.fna ) &> ../../results/C_DELIMINATE_HUMAN
ls -la human.fna.dlim > ../../results/BC_DELIMINATE_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_HUMAN";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f human.fna.delim.d
(time ./delim e human.fna.dlim ) &> ../../results/D_DELIMINATE_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_HUMAN";
cmp human.fna human.fna.dlim.d > ../../results/V_DELIMINATE_HUMAN
mv human.fna ../../datasets/
# CHIMPANZEE
mv ../../datasets/chimpanze.fna .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f chimpanze.fna.dlim
(time ./delim a chimpanze.fna ) &> ../../results/C_DELIMINATE_CHIMPANZE
ls -la chimpanze.fna.dlim > ../../results/BC_DELIMINATE_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_CHIMPANZE";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f chimpanze.fna.delim.d
(time ./delim e chimpanze.fna.dlim ) &> ../../results/D_DELIMINATE_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_CHIMPANZE";
cmp chimpanze.fna chimpanze.fna.dlim.d > ../../results/V_DELIMINATE_CHIMPANZE
mv chimpanze.fna ../../datasets/
# RICE
mv ../../datasets/rice5.fna .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f rice5.fna.dlim
(time ./delim a rice5.fna ) &> ../../results/C_DELIMINATE_RICE
ls -la rice5.fna.dlim > ../../results/BC_DELIMINATE_RICE
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_RICE";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f rice5.fna.delim.d
(time ./delim e rice5.fna.dlim ) &> ../../results/D_DELIMINATE_RICE
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_RICE";
cmp rice5.fna rice5.fna.dlim.d > ../../results/V_DELIMINATE_RICE
mv rice5.fna ../../datasets/
# CAMERA
mv ../../datasets/camera.fa .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f camera.fa.dlim
(time ./delim a camera.fa ) &> ../../results/C_DELIMINATE_CAMERA
ls -la camera.fa.dlim > ../../results/BC_DELIMINATE_CAMERA
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_CAMERA";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f camera.fa.delim.d
(time ./delim e camera.fa.dlim ) &> ../../results/D_DELIMINATE_CAMERA
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_CAMERA";
cmp camera.fa camera.fa.dlim.d > ../../results/V_DELIMINATE_CAMERA
mv camera.fa ../../datasets/
cd ../../
fi
###############################################################################
if [[ "$RUN_LEON" -eq "1" ]]; then
mkdir -p results
cd progs/leon
# HUMAN
mv ../../datasets/human.fna human.fa
ProgMemoryStart "leon" &
MEMPID=$!
rm -f human.fna.leon
(time ./leon -c -file human.fa ) &> ../../results/C_LEON_HUMAN
ls -la human.fa.leon > ../../results/BC_LEON_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_LEON_HUMAN";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f human.fa.d
(time ./leon -d -file human.fa.leon ) &> ../../results/D_LEON_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_LEON_HUMAN";
cmp human.fa human.fa.d > ../../results/V_LEON_HUMAN
mv human.fa ../../datasets/human.fna
# CHIMPANZEE
mv ../../datasets/chimpanze.fna chimpanze.fa
ProgMemoryStart "leon" &
MEMPID=$!
rm -f chimpanze.fa.leon
(time ./leon -c -file chimpanze.fa ) &> ../../results/C_LEON_CHIMPANZE
ls -la chimpanze.fa.leon > ../../results/BC_LEON_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_LEON_CHIMPANZE";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f chimpanze.fa.d
(time ./leon -d -file chimpanze.fa.leon ) &> ../../results/D_LEON_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_LEON_CHIMPANZE";
cmp chimpanze.fa chimpanze.fa.d > ../../results/V_LEON_CHIMPANZE
mv chimpanze.fa ../../datasets/chimpanze.fna
# RICE
mv ../../datasets/rice5.fna rice5.fa
ProgMemoryStart "leon" &
MEMPID=$!
rm -f rice5.fa.leon
(time ./leon -c -file rice5.fa ) &> ../../results/C_LEON_RICE
ls -la rice5.fa.leon > ../../results/BC_LEON_RICE
ProgMemoryStop $MEMPID "../../results/MC_LEON_RICE";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f rice5.fa.d
(time ./leon -d -file rice5.fa.leon ) &> ../../results/D_LEON_RICE
ProgMemoryStop $MEMPID "../../results/MD_LEON_RICE";
cmp rice5.fa rice5.fa.d > ../../results/V_LEON_RICE
mv rice5.fa ../../datasets/rice5.fna
mv ../../datasets/camera.fa .
ProgMemoryStart "leon" &
MEMPID=$!
rm -f camera.fa.leon
(time ./leon -c -file camera.fa ) &> ../../results/C_LEON_CAMERA
ls -la camera.fa.leon > ../../results/BC_LEON_CAMERA
ProgMemoryStop $MEMPID "../../results/MC_LEON_CAMERA";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f camera.fa.d
(time ./leon -d -file camera.fa.leon ) &> ../../results/D_LEON_CAMERA
ProgMemoryStop $MEMPID "../../results/MD_LEON_CAMERA";
cmp camera.fa camera.fa.d > ../../results/V_LEON_CAMERA
mv camera.fa ../../datasets/
cd ../../
fi
###############################################################################
if [[ "$RUN_MFCOMPRESS" -eq "1" ]]; then
mkdir -p results
cd progs/mfcompress
# HUMAN
mv ../../datasets/human.fna .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f human.fna.mfc
(time ./MFCompressC -v \
-o human.fna.mfc human.fna ) &> ../../results/C_MFCOMPRESS_HUMAN
ls -la human.fna.mfc > ../../results/BC_MFCOMPRESS_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_HUMAN";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f human.fna.d
(time ./MFCompressD -v \
-o human.fna.d human.fna.mfc ) &> ../../results/D_MFCOMPRESS_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_HUMAN";
cmp human.fna human.fna.d > ../../results/V_MFCOMPRESS_HUMAN
mv human.fna ../../datasets/
# CHIMPANZEE
mv ../../datasets/chimpanze.fna .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f chimpanze.fna.mfc
(time ./MFCompressC -v \
-o chimpanze.fna.mfc chimpanze.fna ) &> ../../results/C_MFCOMPRESS_CHIMPANZE
ls -la chimpanze.fna.mfc > ../../results/BC_MFCOMPRESS_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_CHIMPANZE";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f chimpanze.fna.d
(time ./MFCompressD -v \
-o chimpanze.fna.d chimpanze.fna.mfc ) &> ../../results/D_MFCOMPRESS_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_CHIMPANZE";
cmp chimpanze.fna chimpanze.fna.d > ../../results/V_MFCOMPRESS_CHIMPANZE
mv chimpanze.fna ../../datasets/
# RICE
mv ../../datasets/rice5.fna .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f rice5.fna.mfc
(time ./MFCompressC -v \
-o rice5.fna.mfc rice5.fna ) &> ../../results/C_MFCOMPRESS_RICE
ls -la rice5.fna.mfc > ../../results/BC_MFCOMPRESS_RICE
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_RICE";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f rice5.fna.d
(time ./MFCompressD -v \
-o rice5.fna.d rice5.fna.mfc ) &> ../../results/D_MFCOMPRESS_RICE
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_RICE";
cmp rice5.fna rice5.fna.d > ../../results/V_MFCOMPRESS_RICE
mv rice5.fna ../../datasets/
# CAMERA
mv ../../datasets/camera.fa .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f camera.fa.mfc
(time ./MFCompressC -v \
-o camera.fa.mfc camera.fa ) &> ../../results/C_MFCOMPRESS_CAMERA
ls -la camera.fa.mfc > ../../results/BC_MFCOMPRESS_CAMERA
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_CAMERA";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f camera.fa.d
(time ./MFCompressD -v \
-o camera.fa.d camera.fa.mfc ) &> ../../results/D_MFCOMPRESS_CAMERA
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_CAMERA";
cmp camera.fa camera.fa.d > ../../results/V_MFCOMPRESS_CAMERA
mv camera.fa ../../datasets/
cd ../../
fi
##############################################################################
#
##############################################################################
################################# SAM / BAM ##################################
##############################################################################
###
### FILES TO COMPRESS:
###   [+] NA12877_S1.bam
###   [+] NA12878_S1.bam
###   [+] NA12882_S1.bam
###   [+] ERR317482.bam
###
##############################################################################
if [[ "$RUN_NGC" -eq "1" ]]; then
# http://www.cibiv.at/~niko/ngc/download.html
mkdir -p results
cd progs/ngc/
mv ../../datasets/humanDZ.fna .
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i NA12877_S1.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_NA12877_S1
ls -la OUT.dz > ../../results/BC_NGC_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MC_NGC_NA12877_S1";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f NA12877_S1.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o NA12877_S1.dec -r humanDZ.fna ) &> ../../results/D_NGC_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MD_NGC_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam > ../../results/V_NGC_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i NA12878_S1.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_NA12878_S1
ls -la OUT.dz > ../../results/BC_NGC_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MC_NGC_NA12878_S1";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f NA12878_S1.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o NA12878_S1.dec -r humanDZ.fna ) &> ../../results/D_NGC_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MD_NGC_NA12878_S1";
cmp NA12878_S1.dec NA12878_S1.bam > ../../results/V_NGC_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i NA12882_S1.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_NA12882_S1
ls -la OUT.dz > ../../results/BC_NGC_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MC_NGC_NA12882_S1";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f NA12882_S1.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o NA12882_S1.dec -r humanDZ.fna ) &> ../../results/D_NGC_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MD_NGC_NA12882_S1";
cmp NA12882_S1.dec NA12882_S1.bam > ../../results/V_NGC_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i ERR317482.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_ERR317482
ls -la OUT.dz > ../../results/BC_NGC_ERR317482
ProgMemoryStop $MEMPID "../../results/MC_NGC_ERR317482";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f ERR317482.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o ERR317482.dec -r humanDZ.fna ) &> ../../results/D_NGC_ERR317482
ProgMemoryStop $MEMPID "../../results/MD_NGC_ERR317482";
cmp ERR317482.dec ERR317482.bam > ../../results/V_NGC_ERR317482
mv ERR317482.bam ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
##############################################################################
if [[ "$RUN_DEEZ" -eq "1" ]]; then
mkdir -p results
cd progs/deez/
mv ../../datasets/humanDZ.fna .
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna NA12877_S1.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_NA12877_S1
ls -la OUT.dz > ../../results/BC_DEEZ_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_NA12877_S1";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f NA12877_S1.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o NA12877_S1.dec ) &> ../../results/D_DEEZ_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam > ../../results/V_DEEZ_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna NA12878_S1.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_NA12878_S1
ls -la OUT.dz > ../../results/BC_DEEZ_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_NA12878_S1";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f NA12878_S1.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o NA12878_S1.dec ) &> ../../results/D_DEEZ_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_NA12878_S1";
cmp NA12878_S1.dec NA12878_S1.bam > ../../results/V_DEEZ_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna NA12882_S1.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_NA12882_S1
ls -la OUT.dz > ../../results/BC_DEEZ_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_NA12882_S1";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f NA12882_S1.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o NA12882_S1.dec ) &> ../../results/D_DEEZ_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_NA12882_S1";
cmp NA12882_S1.dec NA12882_S1.bam > ../../results/V_DEEZ_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna ERR317482.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_ERR317482
ls -la OUT.dz > ../../results/BC_DEEZ_ERR317482
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_ERR317482";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f ERR317482.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o ERR317482.dec ) &> ../../results/D_DEEZ_ERR317482
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_ERR317482";
cmp ERR317482.dec ERR317482.bam > ../../results/V_DEEZ_ERR317482
mv ERR317482.bam ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
##############################################################################
if [[ "$RUN_SAMCOMP" -eq "1" ]]; then
mkdir -p results
cd progs/samcomp/
mv ../../datasets/humanDZ.fna .
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < NA12877_S1.bam > OUT.dz ) &> ../../results/C_SAMCOMP_NA12877_S1
ls -la OUT.dz > ../../results/BC_SAMCOMP_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_NA12877_S1";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f NA12877_S1.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > NA12877_S1.dec ) &> ../../results/D_SAMCOMP_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam > ../../results/V_SAMCOMP_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < NA12878_S1.bam > OUT.dz ) &> ../../results/C_SAMCOMP_NA12878_S1
ls -la OUT.dz > ../../results/BC_SAMCOMP_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_NA12878_S1";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f NA12878_S1.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > NA12878_S1.dec ) &> ../../results/D_SAMCOMP_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_NA12878_S1";
cmp NA12878_S1.dec NA12878_S1.bam > ../../results/V_SAMCOMP_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < NA12882_S1.bam > OUT.dz ) &> ../../results/C_SAMCOMP_NA12882_S1
ls -la OUT.dz > ../../results/BC_SAMCOMP_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_NA12882_S1";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f NA12882_S1.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > NA12882_S1.dec ) &> ../../results/D_SAMCOMP_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_NA12882_S1";
cmp NA12882_S1.dec NA12882_S1.bam > ../../results/V_SAMCOMP_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < ERR317482.bam > OUT.dz ) &> ../../results/C_SAMCOMP_ERR317482
ls -la OUT.dz > ../../results/BC_SAMCOMP_ERR317482
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_ERR317482";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f ERR317482.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > ERR317482.dec ) &> ../../results/D_SAMCOMP_ERR317482
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_ERR317482";
cmp ERR317482.dec ERR317482.bam > ../../results/V_SAMCOMP_ERR317482
mv ERR317482.bam ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
##############################################################################

