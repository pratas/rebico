#!/bin/bash
###############################################################################
# PERFORMANCE OF MULTIPLE COMPRESSION ALGORITHMS ON GENOMIC DATA
#   - REFERENCE METHOS
#   - REFERENCE-FREE METHODS
# REQUIREMENTS: linux OS & DEPENDENCIES
###############################################################################
# SYSTEM FLAGS ================================================================
INSTALL_DEPENDENCIES=1;
  INSTALL_ZLIB=1;
  INSTALL_CMAKE=1;
  INSTALL_LIBBOOST=1;
  INSTALL_VALGRIND=1;
# INSTALL PROGS ===============================================================
INSTALL_IDOCOMP=1;
INSTALL_DNACOMPACT=1;
INSTALL_GECO=1;
INSTALL_GREEN=1;
INSTALL_COGI=1;
INSTALL_GDC2=1;
INSTALL_FRESCO=1;
INSTALL_ORCOM=1;
INSTALL_DSRC=1;
INSTALL_MFCOMPRESS=1;
INSTALL_FQC=1;
INSTALL_FQZCOMP=1;
INSTALL_QUIP=1;
INSTALL_GRS=1;
INSTALL_NGC=1;
INSTALL_DEEZ=1;
INSTALL_SCALCE=1;
# RUN PROGS ===================================================================
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
RUN_QUIP=1;
RUN_GRS=1;
RUN_NGC=1;
RUN_DEEZ=1;
RUN_SCALCE=1;
###############################################################################
# CREATE TEMPORARY FOLDER =====================================================
rm -fr ctest;
mkdir ctest;
cd ctest/
###############################################################################
# STATUS ======================================================================
# http://www.cs.tut.fi/~tabus/genml/ # NOT AVAILABLE: ONLY A DECOMPRESSOR
# http://www.ics.uci.edu/~dnazip/    # ERROR COMPILATION
# ww2.cs.mu.oz.au/~kuruppu/comrad/   # BROKEN LINK
###############################################################################
########################### DOWNLOAD DEPENDENCIES #############################
###############################################################################
# GET LIBS ====================================================================
if [[ "$INSTALL_DEPENDENCIES" -eq "1" ]]; then
  # GET ZLIB ==================================================================
  if [[ "$INSTALL_ZLIB" -eq "1" ]]; then
  rm -f zlib_1.2.8.dfsg.orig.tar.gz
  wget \
  https://launchpad.net/ubuntu/+archive/primary/+files/zlib_1.2.8.dfsg.orig.tar.gz
  tar -xzf zlib_1.2.8.dfsg.orig.tar.gz
  cd zlib-1.2.8/
  ./configure
  make
  cd ..
  fi
  # GET CMAKE =================================================================
  if [[ "$INSTALL_CMAKE" -eq "1" ]]; then
  rm -f cmake-3.5.2-Linux-x86_64.sh
  wget https://cmake.org/files/v3.5/cmake-3.5.2-Linux-x86_64.sh
  . cmake-3.5.2-Linux-x86_64.sh
  fi
  # GET LIBBOOST ==============================================================
  if [[ "$INSTALL_LIBBOOST" -eq "1" ]]; then
  sudo apt-get update ;
  sudo apt-get install libboost1.54-dev
  sudo apt-get install libboost-system1.54-dev
  sudo apt-get install libboost-system-dev
  sudo apt-get install libboost-filesystem1.54-dev
  sudo apt-get install libboost-filesystem-dev
  sudo apt-get install libboost-iostreams-dev
  sudo apt-get install libboost-iostreams1.54-dev
  sudo apt-get install libboost-thread1.54-dev
  sudo apt-get install libboost-thread-dev
  fi
  # GET VALGRIND AND MASSIF ===================================================
  if [[ "$INSTALL_VALGRIND" -eq "1" ]]; then
  sudo apt-get install valgrind
  fi
fi
###############################################################################
############################## F U N C T I O N S ##############################
###############################################################################
# MEMORY ======================================================================
function ProgMemory {
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
######################### DOWNLOAD COMPRESSION MODELS #########################
###############################################################################
# GET iDoComp =================================================================
if [[ "$INSTALL_IDOCOMP" -eq "1" ]]; then
rm -fr iDoComp_website_v1*
wget http://web.stanford.edu/~iochoa/iDoComp_website_v1.tar.gz
tar -xvzf iDoComp_website_v1.tar.gz
cd iDoComp_website_v1/sais-lite-2.4.1/source-code/
gcc -o ../sa.run sa_generator.c sais.c -lm
cd ../../
cd simulations/source_code/
gcc -o ../iDoComp.run idc_generate_mapping.c main.c stats.c arith.c \
fasta_decompressor.c idc_load_chr.c os_stream.c fasta_compressor.c \
sam_stream.c -lm
cd ../../../
fi
###############################################################################
# GET DNACompact ==============================================================
if [[ "$INSTALL_DNACOMPACT" -eq "1" ]]; then
COMPACTPATH="projects/dnacompact/files/latest";
rm -f FILES
wget http://sourceforge.net/$COMPACTPATH/download?source=typ_redirect -O FILES
unzip FILES
cd Latest\ Public\ source\ code
make; 
cp compact ../
cd ..
ulimit -s 200000000 # UNLIMIT SIZE OF OPEN FILES
#(time ./compact n ../BI/B9-CLEAN ) &> REPORT_B9_CLEAN ;
fi
###############################################################################
# GET COGI ====================================================================
if [[ "$INSTALL_COGI" -eq "1" ]]; then
rm -f cogi.zip
wget http://admis.fudan.edu.cn/projects/CoGI/cogi.zip
unzip cogi.zip
cd cogi/
mkdir bin/
make
cp bin/compress ../cogi-compress
cp bin/uncompress ../cogi-uncompress
cd ../
fi
###############################################################################
# GET GECO ====================================================================
if [[ "$INSTALL_GECO" -eq "1" ]]; then
rm -fr geco/
git clone https://github.com/pratas/geco.git
cd geco/src/
cmake .
make
cp GeCo ../../
cp GeDe ../../
cd ../../
fi
###############################################################################
# GET GREEN ===================================================================
if [[ "$INSTALL_GREEN" -eq "1" ]]; then
rm -f GReEn1.tar.gz;
wget http://bioinformatics.ua.pt/wp-content/uploads/2014/09/GReEn1.tar.gz
tar -xvzf GReEn1.tar.gz
cd GReEn1/
make
cp GReEnC ../
cp GReEnD ../
cd ..
fi
###############################################################################
# GET FRESCO ==================================================================
if [[ "$INSTALL_FRESCO" -eq "1" ]]; then
rm -fr FRESCO/
git clone https://github.com/hubsw/FRESCO.git
cd FRESCO/build/
printf 'CPP=g++\nCC=gcc\nLD=g++\nLIB=ar\nWINDRES=\nOBJS_RELEASE=../main.o\n\nRelease: ../FRESCO\n../FRESCO: $(OBJS_RELEASE)\n\t@echo Building console executable ../FRESCO\n\t@g++ -lz -lboost_system -lboost_filesystem -lboost_iostreams -o ../FRESCO $(OBJS_RELEASE) -s -lz -lboost_system -lboost_filesystem -lboost_iostreams\n\n../main.o: ../source/main.cpp\n\t@echo Compiling: ../source/main.cpp\n\t@g++ -Wall -Wunused-variable -fexceptions -std=c++11 -O3 -c ../source/main.cpp -o ../main.o\n\n../source/main.cpp: ../include/* ../include/Sequence/* ../include/Index/*.h ../include/Compressor/* ../include/Serializer/* ../include/Config/ConfigFileParser.h\n\n.PHONY: clean\n\nclean:\n\t@echo Delete $(OBJS_RELEASE) ../FRESCO\n\t-@rm -f $(OBJS_RELEASE) ../FRESCO\n' > Makefile;
make clean ;
make ; 
cd ../
cp FRESCO ../FRESCO-BIN
cd ../
fi
###############################################################################
# GET GDC =====================================================================
if [[ "$INSTALL_GDC2" -eq "1" ]]; then
rm -f gdc2.tat.gz
wget http://sun.aei.polsl.pl/REFRESH/gdc/downloads/2.0/gdc2.tar.gz
tar -xzf gdc2.tar.gz
cd gdc2/gdc_2/Gdc2/
# LIBRARIES ORDER ACCESS CREATE SOME PROBLES (WE ADD THEM TO THE END)
printf '\nall: gdc2 \n\nCC      = g++\nCFLAGS  = -Wall -O3 -m64 -Wl,--whole-archive -lpthread -Wl,--no-whole-archive -std=c++11 \nCLINK   = -lm -O3 -m64 -Wl,--whole-archive -lpthread -Wl,--no-whole-archive -std=c++11 -lz \n\n.cpp.o: \n\t$(CC) $(CFLAGS) -c $< -o $@ \n\ngdc2: c1stage.o c2stage.o fasta.o hasher.o main.o p1stage.o qsmodel.o queue.o rangecod.o timer.o \n\t$(CC) $(CLINK) -o gdc2 c1stage.o c2stage.o fasta.o hasher.o main.o p1stage.o qsmodel.o queue.o rangecod.o timer.o ../libs/libaelf64.a -lz -lpthread \n\nclean: \n\trm gdc2 \n\trm *.o \n' > Makefile;
make clean ; make
cp gdc2 ../../../GDC2 # TO NOT OVERLAP FOLDER NAME
cd ../../../
fi
###############################################################################
# DNAzip ======================================================================
if [[ "$INSTALL_DNAZIP" -eq "1" ]]; then
rm -fr DNAZip/;
mkdir DNAZip
cd DNAZip;
wget http://www.ics.uci.edu/~dnazip/DNAzip.tar.gz
tar -xzf DNAzip.tar.gz
make # FIXME: ERROR ON COMPILATION
cd ../
fi
###############################################################################
# ERGC ========================================================================
if [[ "$INSTALL_ERGC" -eq "1" ]]; then
rm -f ERGC.zip
wget http://engr.uconn.edu/~rajasek/ERGC.zip
unzip ERGC.zip
cd ERGC/
make
chmod 777 7za 7z
cp *.class ..
cp 7za ..
cp 7z ..
cp SCRIPT_ERGC_COMP ..
cp SCRIPT_ERGC_DECOMP ..
cd ..
fi
###############################################################################
# GET ORCOM ===================================================================
if [[ "$INSTALL_ORCOM" -eq "1" ]]; then
rm -fr orcom/
git clone https://github.com/lrog/orcom.git
cd orcom/
make
cp bin/orcom_bin ../
cp bin/orcom_pack ../
cd ..
fi
###############################################################################
# GET DSRC ====================================================================
if [[ "$INSTALL_DSRC" -eq "1" ]]; then
rm -fr dsrc/
git clone https://github.com/lrog/dsrc.git
cd dsrc/
make
cp bin/dsrc ../
cd ..
fi
###############################################################################
# GET MFCOMPRESS ==============================================================
if [[ "$INSTALL_MFCOMPRESS" -eq "1" ]]; then
rm -f MFCompress-src-1.01.tgz;
wget http://sweet.ua.pt/ap/software/mfcompress/MFCompress-src-1.01.tgz
tar -xzf MFCompress-src-1.01.tgz
cd MFCompress-src-1.01/
cp Makefile.linux Makefile # make -f Makefile.linux
make
cp MFCompressC ..
cp MFCompressD ..
cd ..
fi
###############################################################################
# GET FQC =====================================================================
if [[ "$INSTALL_FQC" -eq "1" ]]; then
rm -f FQC_LINUX_64bit.tar.gz
wget \
http://metagenomics.atc.tcs.com/Compression_archive/FQC/FQC_LINUX_64bit.tar.gz
tar -xzf FQC_LINUX_64bit.tar.gz
cd FQC_LINUX_64bit/
cp 7za ../
cp fcompfastq ../
cp fdecompfastq ../
cp fqc ../
cd ../
fi
###############################################################################
# GET FQZ_COMP ================================================================
if [[ "$INSTALL_FQZCOMP" -eq "1" ]]; then
rm -f fqzcomp-4.6.tar.gz
wget https://downloads.sourceforge.net/project/fqzcomp/fqzcomp-4.6.tar.gz
tar -xzf fqzcomp-4.6.tar.gz
cd fqzcomp-4.6/
make
cp fqz_comp ../
cd ..
fi
###############################################################################
# GET QUIP ====================================================================
if [[ "$INSTALL_QUIP" -eq "1" ]]; then
wget http://homes.cs.washington.edu/~dcjones/quip/quip-1.1.8.tar.gz
tar -xzf quip-1.1.8.tar.gz
cd quip-1.1.8/
./configure
cd src/
make
cp quip ../../
cd ../../
fi

###############################################################################
# GET GRS =====================================================================
if [[ "$INSTALL_GRS" -eq "1" ]]; then
rm -f GRS1.0_Source_Code.tar.bz2
http://gmdd.shgmo.org/Computational-Biology/GRS/GRS1.0_Source_Code.tar.bz2
tar -xjf GRS1.0_Source_Code.tar.bz2
cd GRS1.0_Source_Code/
. install.sh
cd ..
fi
###############################################################################
# GET NGC =====================================================================
if [[ "$INSTALL_NGC" -eq "1" ]]; then
rm -fr NGC
mkdir NGC
cd NGC
wget http://www.cibiv.at/~niko/ngc/download/ngc-core-0.0.1-standalone.jar
wget http://www.cibiv.at/~niko/ngc/download/ngc-core-0.0.1.jar
cd ../
fi

###############################################################################
# GET ABRC ====================================================================
if [[ "$INSTALL_ABRC" -eq "1" ]]; then
rm -f ABRC_0.2.zip
wget http://www2.informatik.hu-berlin.de/~wandelt/blockcompression/ABRC_0.2.zip
unzip ABRC_0.2.zip
# AND AFTER?!
fi
###############################################################################
# GET DEEZ ====================================================================
if [[ "$INSTALL_DEEZ" -eq "1" ]]; then
rm -rf deez
git clone https://github.com/sfu-compbio/deez.git
cd deez;
make -j
cp deez ../
cd ../
fi
###############################################################################
# GET SCALCE ==================================================================
if [[ "$INSTALL_SCALCE" -eq "1" ]]; then
rm -rf scalce
git clone https://github.com/sfu-compbio/scalce.git
cd scalce
make download
make
cp scalce ../scalce-bin
cd ../
fi
#
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
###############################################################################
if [[ "$RUN_ORCOM" -eq "1" ]]; then
/orcom_bin e -f”NA19238_1.fastq NA19238_2.fastq” -oNA19238.bin
fi
###############################################################################
if [[ "$RUN_DSRC" -eq "1" ]]; then
./dsrc c SRR001471.fastq SRR001471.dsrc
./dsrc d SRR001471.dsrc SRR001471.out.fastq
fi
###############################################################################
if [[ "$RUN_MFCOMPRESS" -eq "1" ]]; then
./MFCompressC -3 -v -o OUT FILE
./MFCompressD -v -o FIL2 OUT
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
if [[ "$RUN_GRS" -eq "1" ]]; then
cp REF.seq Compress/bin/
cp TAR.seq Compress/bin/
cd Compress/bin/
./GRS.sh REF.seq TAR.seq
cd ../../
cp REF.seq Decompress/bin/
echo "THIS IS REPUGNANT!";
fi
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
./deez -r [reference] [input.sam] -o [output]
./deez -r [reference] [input.dz] -o [output] ([region])
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


