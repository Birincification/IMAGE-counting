#!/bin/bash

gtf=$1
out=$2
nthreads=$3
indexAppendix=$4

[ -f "$out" ] && echo "[INFO] [featureCounts] $out already exists; skipping.."$'\n' && exit 

featureCounts='/home/software/subread/bin/featureCounts'

echo "[INFO] [featureCounts] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $featureCounts -T $nthreads -p -B -C -a $gtf --primary -o $out ${@:5}"
$featureCounts -T $nthreads -p -B -C -a $gtf --primary -o $out ${@:5}

echo "[INFO] [featureCounts] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $featureCounts -T $nthreads -p -B -C -O -f -t exonic_part -a /home/data/indices/DEXSeq/$indexAppendix/annot.noaggregate.gtf --primary -o $out.DEXSeq ${@:5}"
$featureCounts -T $nthreads -p -B -C -O -f -t exonic_part -a /home/data/indices/DEXSeq/$indexAppendix/annot.noaggregate.gtf --primary -o $out.DEXSeq ${@:5}

echo "[INFO] [featureCounts] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Finished processing $out"$'\n'

#  -a <string>         Name of an annotation file. GTF/GFF format by default.
#                      See -F option for more format information. Inbuilt
#                      annotations (SAF format) is available in 'annotation'
#                      directory of the package.
#
#  -o <string>         Name of the output file including read counts. A separate
#                      file including summary statistics of counting results is
#                      also included in the output ('<string>.summary').
#
#  -s <int>            Perform strand-specific read counting. Acceptable values:
#                      0 (unstranded), 1 (stranded) and 2 (reversely stranded).
#                      0 by default.
#
#  -T <int>            Number of the threads. 1 by default.
#
#  -p                  If specified, fragments (or templates) will be counted
#                      instead of reads. This option is only applicable for
#                      paired-end reads.
#
#  -B                  Only count read pairs that have both ends aligned.
#
#  -C                  Do not count read pairs that have their two ends mapping 
#                      to different chromosomes or mapping to same chromosome 
#                      but on different strands.
#
#  --fracOverlap <float> Minimum fraction of overlapping bases in a read that is
#                      required for read assignment. Value should be within range
#                      [0,1]. 0 by default. Number of overlapping bases is
#                      counted from both reads if paired end. Both this option
#                      and '--minOverlap' option need to be satisfied for read
#                      assignment.
#
#  --primary           Count primary alignments only. Primary alignments are 
#                      identified using bit 0x100 in SAM/BAM FLAG field.
#
#  -t <string>         Specify feature type in GTF annotation. 'exon' by 
#                      default. Features used for read counting will be 
#                      extracted from annotation using the provided value.
#
#  -O                  Assign reads to all their overlapping meta-features (or 
#                      features if -f is specified).
#
#  -f                  Perform read counting at feature level (eg. counting 
#                      reads for exons rather than genes).
#
#/home/software/subread/bin/featureCounts -s 0 -T 6 -p -B -C --fracOverlap 1 -a /home/GENOMIC_DERIVED/PAN/homo_sapiens/standardchr/Homo_sapiens.GRCh37.75.gtf --primary -o output/COUNTS/featureCounts output/cond1_02.bam output/cond2_01.bam output/cond1_01.bam output/cond2_00.bam output/cond1_00.bam output/cond2_02.bam

#/home/software/subread/bin/featureCounts -O -s 0 -T 6 -p -B -C -f -t exonic_part -a /home/indices/DEXSeq/9606/standardchr/annot.noaggregate.gtf --primary -o output/COUNTS/featureCounts.DEXSeq output/cond1_02.bam output/cond2_01.bam output/cond1_01.bam output/cond2_00.bam output/cond1_00.bam output/cond2_02.bam
