#!/bin/bash

sample=$1
gtf=$2
out=$3
nthreads=$4

stringtie='/home/software/stringtie-1.3.5.Linux_x86_64/stringtie'

[ -f "$out.gtf" ] && echo "[INFO] [STRINGTIE] $out.gtf already exists; skipping.."$'\n' && exit

echo "[INFO] [STRINGTIE] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $stringtie -e -B -p $nthreads -G $gtf -o "$out.gtf" $sample"
$stringtie -e -B -p $nthreads -G $gtf -o "$out.gtf" $sample

echo "[INFO] [STRINGTIE] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Finished processing $out"$'\n'

#	-e only estimate the abundance of given reference transcripts (requires -G)
#	-B enable output of Ballgown table files which will be created in the
#	   same directory as the output GTF (requires -G, -o recommended)
#	-p number of threads (CPUs) to use (default: 1)
#	-G <guide_gff>   reference annotation to include in the merging (GTF/GFF3)

#/home/software/stringtie-1.3.5.Linux_x86_64/stringtie  -e -B -p 6 -G /home/GENOMIC_DERIVED/PAN/homo_sapiens/standardchr/Homo_sapiens.GRCh37.75.gtf -o output/STRINGTIE/cond1_01/cond1_01.gtf output/cond1_01.bam
