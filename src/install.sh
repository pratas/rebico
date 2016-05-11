#!/bin/bash
###############################################################################
# INSTALL MULTIPLE COMPRESSION ALGORITHMS FOR GENOMIC DATA
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
INSTALL_LWFQZIP=1;
INSTALL_LEON=1;
###############################################################################
# CREATE PROGS FOLDER =========================================================
rm -fr progs;
mkdir progs;
cd progs/
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
###############################################################################
# GET LWFQZIP =================================================================
if [[ "$INSTALL_LWFQZIP" -eq "1" ]]; then
rm -rf LWFQZip-v1.02.zip
wget http://csse.szu.edu.cn/staff/zhuzx/LWFQZip/LWFQZip-v1.02.zip
unzip LWFQZip-v1.02.zip
cd LWFQZip-v1.02
make
make clean;
make
cd ../
fi
###############################################################################
# GET LEON ====================================================================
if [[ "$INSTALL_LEON" -eq "1" ]]; then
git clone --recursive https://github.com/GATB/leon.git
# compile the code an run a simple test on your computer
cd leon
sh INSTALL
cd ../
fi
###############################################################################
cd ..
# =============================================================================
