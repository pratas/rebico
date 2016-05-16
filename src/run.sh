#!/bin/bash
RUN_IDOCOMP=1;
RUN_GECO=1;
RUN_GREEN=1;
RUN_COGI=1;
RUN_DNACOMPACT=1;
RUN_GDC2=1;
RUN_FRESCO=1;
RUN_EGRC=1;
RUN_ORCOM=1;
RUN_DSRC=1;
RUN_MFCOMPRESS=1;
RUN_FQC=1;
RUN_FQZCOMP=1;
RUN_SAMCOMP=1;
RUN_QUIP=1;
RUN_GRS=1;
RUN_NGC=1;
RUN_DEEZ=1;
RUN_SCALCE=1;
RUN_LWFQZIP=1;
RUN_LEON=1;
###############################################################################
############################## F U N C T I O N S ##############################
###############################################################################
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
  cat mem_ps | sort -V | head -n 1 > $2;
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
################################ RUN PROGRAMS #################################
###############################################################################
#
if [[ "$RUN_IDOCOMP" -eq "1" ]]; then
# Generating suffix array
echo "Generating suffix array ..."
cd iDoComp_website_v1/sais-lite-2.4.1/
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
cd ../../
fi
###############################################################################
if [[ "$RUN_GECO" -eq "1" ]]; then
# REFERENCE-FREE COMPRESSION
./GeCo -v \
-tm 4:1:0:0/0 -tm 11:1:0/0 -tm 14:50:1:0/0 -tm 20:100:1:3/10 -c 40 TAR
./GeDe -v TAR.co
cmp TAR.de TAR
# REFERENTIAL COMPRESSION
./GeCo -v -tm 4:1:0:0/0 -tm 13:20:1:0/0 \
-rm 6:1:0:0/0 -rm 14:100:1:0/0 -rm 20:500:1:4/50 -c 40 -r REF TAR
./GeDe -v -r REF TAR.co
cmp TAR.de TAR
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
if [[ "$RUN_EGRC" -eq "1" ]]; then
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
if [[ "$RUN_LEON" -eq "1" ]]; then
./leon -c -nb-cores 4 -file IN > OUT
./leon -d -nb-cores 4 -file OUT > IN.2
fi
###############################################################################
if [[ "$RUN_MFCOMPRESS" -eq "1" ]]; then
./MFCompressC -3 -v -o OUT FILE
./MFCompressD -v -o FIL2 OUT
fi
##############################################################################
#
##############################################################################
################################# SAM / BAM ##################################
##############################################################################
if [[ "$RUN_NGC" -eq "1" ]]; then
# http://www.cibiv.at/~niko/ngc/download.html
cp REF.seq NGC/
java -jar -Xmx4G ngc-core-0.0.1-standalone.jar compress -i data.bam \
-o data.ngc -r hg19.fa
java -jar -Xmx4G ngc-core-0.0.1-standalone.jar decompress -i data.ngc \
-o data-decompressed.bam -r hg19.fa
cd ../
fi
##############################################################################
if [[ "$RUN_DEEZ" -eq "1" ]]; then
cd progs/deez/
mv ../../datasets/human.fna .
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
(time ./deez -r human.fna NA12877_S1.bam -o OUT.dz ) &> C_DEEZ_NA12877_S1
ProgMemoryEnd $MEMPID "MC_DEEZ_NA12877_S1";
ProgMemoryStart "./deez" &
MEMPID=$!
(time ./deez -r human.fna OUT.dz -o NA12877_S1.dec ) &> D_DEEZ_NA12877_S1
rogMemoryEnd $MEMPID "MD_DEEZ_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam > V_DEEZ_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
(time ./deez -r human.fna NA12878_S1.bam -o OUT.dz ) &> C_DEEZ_NA12878_S1
(time ./deez -r human.fna OUT.dz -o NA12878_S1.dec ) &> D_DEEZ_NA12878_S1
cmp NA12878_S1.dec NA12878_S1.bam > V_DEEZ_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
(time ./deez -r human.fna NA12882_S1.bam -o OUT.dz ) &> C_DEEZ_NA12882_S1
(time ./deez -r human.fna OUT.dz -o NA12882_S1.dec ) &> D_DEEZ_NA12882_S1
cmp NA12882_S1.dec NA12882_S1.bam > V_DEEZ_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
(time ./deez -r human.fna ERR317482.bam -o OUT.dz ) &> C_DEEZ_ERR317482
(time ./deez -r human.fna OUT.dz -o ERR317482.dec ) &> D_DEEZ_ERR317482
cmp ERR317482.dec ERR317482.bam > V_DEEZ_ERR317482
mv ERR317482.bam ../../datasets/
#
mv human.fna ../../datasets/
fi
##############################################################################
if [[ "$RUN_SAMCOMP" -eq "1" ]]; then
sam_comp2 [-r ref_dir] [-f format] < file.sam > file.zam
sam_comp2 [-r ref_dir] [-f format] -d < file.zam > file.sam
fi
##############################################################################

