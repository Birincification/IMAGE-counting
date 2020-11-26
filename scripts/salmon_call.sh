#!/bin/bash

sample=$1
indexAppendix=$2
out=$3
nthreads=$4

[ "$(ls -A $out)" ] && echo "[INFO] [SALMON] $out not empty; skipping.."$'\n' && exit

salmon='/home/software/salmon-0.14.1_linux_x86_64/bin/salmon'

echo "[INFO] [SALMON] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $salmon quant -t /home/data/indices/salmon/$indexAppendix/cdna.fa -l IU -a $sample -o $out -p $nthreads --dumpEq"
$salmon quant -t /home/data/indices/salmon/$indexAppendix/cdna.fa -l IU -a $sample -o $out -p $nthreads --dumpEq

echo "[INFO] [SALMON] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Finished processing $out"$'\n'

#-t [ --targets ] arg	FASTA format file containing target transcripts
#-l [ --libType ] arg	Format string describing the library type
#-a [ --alignments ] arg	input alignment (BAM) file(s)
#-p [ --threads ] arg (=8)	The number of threads to use concurrently
#--dumpEq	Dump the equivalence class counts that were computed during quasi-mapping

#/home/software/salmon-0.14.1_linux_x86_64/bin/salmon quant -t /home/indices/salmon/9606/standardchr/cdna.fa\
#		 -l IU -a output/STAR/cond1_01Aligned.toTranscriptome.out.bam\
#		 -o output/SALMON/cond1_01 -p 6 --dumpEq
