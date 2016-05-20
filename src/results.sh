#!/bin/bash
###############################################################################
#################################### FASTA ####################################
###############################################################################
#
# DELIMINATE ##################################################################
#
# BC, BYTES ON COMPRESSION ====================================================
BC_DELIMINATE_HUMAN=`cat results/BC_DELIMINATE_HUMAN | awk '{ print $5; }'`;
BC_DELIMINATE_CHIMPANZE=`cat results/BC_DELIMINATE_CHIMPANZE \
| awk '{ print $5; }'`;
BC_DELIMINATE_RICE=`cat results/BC_DELIMINATE_RICE | awk '{ print $5; }'`;
BC_DELIMINATE_CAMERA=`cat results/BC_DELIMINATE_CAMERA | awk '{ print $5; }'`;
# C, COMPRESSION TIME =========================================================
C_DELIMINATE_HUMAN=`cat results/C_DELIMINATE_HUMAN | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_DELIMINATE_CHIMPANZE=`cat results/C_DELIMINATE_CHIMPANZE | tail -n 2 \ 
| head -n 1 | awk '{ print $2;}'`;
C_DELIMINATE_RICE=`cat results/C_DELIMINATE_RICE | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_DELIMINATE_CAMERA=`cat results/C_DELIMINATE_CAMERA | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
# MC, COMPRESSION MEMORY ======================================================
# XXX: MEMORY MIGHT NOT BE COMPLETE GIVEN EXTERNAL 7z PROGRAM
MC_DELIMINATE_HUMAN=`cat results/MC_DELIMINATE_HUMAN`;
MC_DELIMINATE_CHIMPANZE=`cat results/MC_DELIMINATE_CHIMPANZE`;
MC_DELIMINATE_RICE=`cat results/MC_DELIMINATE_RICE`;
MC_DELIMINATE_CAMERA=`cat results/MC_DELIMINATE_CAMERA`;
# D, DECOMPRESSION TIME =======================================================
D_DELIMINATE_HUMAN=`cat results/D_DELIMINATE_HUMAN | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
D_DELIMINATE_CHIMPANZE=`cat results/D_DELIMINATE_CHIMPANZE | tail -n 2 \ 
| head -n 1 | awk '{ print $2;}'`;
D_DELIMINATE_RICE=`cat results/D_DELIMINATE_RICE | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
D_DELIMINATE_CAMERA=`cat results/D_DELIMINATE_CAMERA | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
# MD, DECOMPRESSION MEMORY ====================================================
# XXX: MEMORY MIGHT NOT BE COMPLETE GIVEN EXTERNAL 7z PROGRAM
MD_DELIMINATE_HUMAN=`cat results/MD_DELIMINATE_HUMAN`;
MD_DELIMINATE_CHIMPANZE=`cat results/MD_DELIMINATE_CHIMPANZE`;
MD_DELIMINATE_RICE=`cat results/MD_DELIMINATE_RICE`;
MD_DELIMINATE_CAMERA=`cat results/MD_DELIMINATE_CAMERA`;
# V, DECOMPRESSION HELD WITH SUCCESS? =========================================
V_DELIMINATE_HUMAN=`cat results/V_DELIMINATE_HUMAN`;
V_DELIMINATE_CHIMPANZE=`cat results/V_DELIMINATE_CHIMPANZE`;
V_DELIMINATE_RICE=`cat results/V_DELIMINATE_RICE`;
V_DELIMINATE_CAMERA=`cat results/V_DELIMINATE_CAMERA`;
#
# MFCOMPRESS ##################################################################
#
# BC, BYTES ON COMPRESSION ====================================================
BC_MFCOMPRESS_HUMAN=`cat results/BC_MFCOMPRESS_HUMAN | awk '{ print $5; }'`;
BC_MFCOMPRESS_CHIMPANZE=`cat results/BC_MFCOMPRESS_CHIMPANZE \
| awk '{ print $5; }'`;
BC_MFCOMPRESS_RICE=`cat results/BC_MFCOMPRESS_RICE | awk '{ print $5; }'`;
BC_MFCOMPRESS_CAMERA=`cat results/BC_MFCOMPRESS_CAMERA | awk '{ print $5; }'`;
# C, COMPRESSION TIME =========================================================
C_MFCOMPRESS_HUMAN=`cat results/C_MFCOMPRESS_HUMAN | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_MFCOMPRESS_CHIMPANZE=`cat results/C_MFCOMPRESS_CHIMPANZE | tail -n 2 \ 
| head -n 1 | awk '{ print $2;}'`;
C_MFCOMPRESS_RICE=`cat results/C_MFCOMPRESS_RICE | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_MFCOMPRESS_CAMERA=`cat results/C_MFCOMPRESS_CAMERA | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
# MC, COMPRESSION MEMORY ======================================================
# XXX: MEMORY MIGHT NOT BE COMPLETE GIVEN EXTERNAL PARALLEL PROGRAM
MC_MFCOMPRESS_HUMAN=`cat results/MC_MFCOMPRESS_HUMAN`;
MC_MFCOMPRESS_CHIMPANZE=`cat results/MC_MFCOMPRESS_CHIMPANZE`;
MC_MFCOMPRESS_RICE=`cat results/MC_MFCOMPRESS_RICE`;
MC_MFCOMPRESS_CAMERA=`cat results/MC_MFCOMPRESS_CAMERA`;
# D, DECOMPRESSION TIME =======================================================
D_MFCOMPRESS_HUMAN=`cat results/D_MFCOMPRESS_HUMAN | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
D_MFCOMPRESS_CHIMPANZE=`cat results/D_MFCOMPRESS_CHIMPANZE | tail -n 2 \ 
| head -n 1 | awk '{ print $2;}'`;
D_MFCOMPRESS_RICE=`cat results/D_MFCOMPRESS_RICE | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
D_MFCOMPRESS_CAMERA=`cat results/D_MFCOMPRESS_CAMERA | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
# MD, DECOMPRESSION MEMORY ====================================================
# XXX: MEMORY MIGHT NOT BE COMPLETE GIVEN EXTERNAL PARALLEL PROGRAM
MD_MFCOMPRESS_HUMAN=`cat results/MD_MFCOMPRESS_HUMAN`;
MD_MFCOMPRESS_CHIMPANZE=`cat results/MD_MFCOMPRESS_CHIMPANZE`;
MD_MFCOMPRESS_RICE=`cat results/MD_MFCOMPRESS_RICE`;
MD_MFCOMPRESS_CAMERA=`cat results/MD_MFCOMPRESS_CAMERA`;
# V, DECOMPRESSION HELD WITH SUCCESS? =========================================
V_MFCOMPRESS_HUMAN=`cat results/V_MFCOMPRESS_HUMAN`;
V_MFCOMPRESS_CHIMPANZE=`cat results/V_MFCOMPRESS_CHIMPANZE`;
V_MFCOMPRESS_RICE=`cat results/V_MFCOMPRESS_RICE`;
V_MFCOMPRESS_CAMERA=`cat results/V_MFCOMPRESS_CAMERA`;
#
# LEON ########################################################################
#
# BC, BYTES ON COMPRESSION ====================================================
BC_LEON_HUMAN=`cat results/BC_LEON_HUMAN | awk '{ print $5; }'`;
BC_LEON_CHIMPANZE=`cat results/BC_LEON_CHIMPANZE \
| awk '{ print $5; }'`;
BC_LEON_RICE=`cat results/BC_LEON_RICE | awk '{ print $5; }'`;
BC_LEON_CAMERA=`cat results/BC_LEON_CAMERA | awk '{ print $5; }'`;
# C, COMPRESSION TIME =========================================================
C_LEON_HUMAN=`cat results/C_LEON_HUMAN | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_LEON_CHIMPANZE=`cat results/C_LEON_CHIMPANZE | tail -n 2 \ 
| head -n 1 | awk '{ print $2;}'`;
C_LEON_RICE=`cat results/C_LEON_RICE | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_LEON_CAMERA=`cat results/C_LEON_CAMERA | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
# MC, COMPRESSION MEMORY ======================================================
# XXX: MEMORY MIGHT NOT BE COMPLETE GIVEN EXTERNAL PARALLEL PROGRAM
MC_LEON_HUMAN=`cat results/MC_LEON_HUMAN`;
MC_LEON_CHIMPANZE=`cat results/MC_LEON_CHIMPANZE`;
MC_LEON_RICE=`cat results/MC_LEON_RICE`;
MC_LEON_CAMERA=`cat results/MC_LEON_CAMERA`;
# D, DECOMPRESSION TIME =======================================================
D_LEON_HUMAN=`cat results/D_LEON_HUMAN | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
D_LEON_CHIMPANZE=`cat results/D_LEON_CHIMPANZE | tail -n 2 \ 
| head -n 1 | awk '{ print $2;}'`;
D_LEON_RICE=`cat results/D_LEON_RICE | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
D_LEON_CAMERA=`cat results/D_LEON_CAMERA | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
# MD, DECOMPRESSION MEMORY ====================================================
# XXX: MEMORY MIGHT NOT BE COMPLETE GIVEN EXTERNAL PARALLEL PROGRAM
MD_LEON_HUMAN=`cat results/MD_LEON_HUMAN`;
MD_LEON_CHIMPANZE=`cat results/MD_LEON_CHIMPANZE`;
MD_LEON_RICE=`cat results/MD_LEON_RICE`;
MD_LEON_CAMERA=`cat results/MD_LEON_CAMERA`;
# V, DECOMPRESSION HELD WITH SUCCESS? =========================================
V_LEON_HUMAN=`cat results/V_LEON_HUMAN`;
V_LEON_CHIMPANZE=`cat results/V_LEON_CHIMPANZE`;
V_LEON_RICE=`cat results/V_LEON_RICE`;
V_LEON_CAMERA=`cat results/V_LEON_CAMERA`;
#
###############################################################################
############################## BUILD TABLE ####################################
###############################################################################




###############################################################################




