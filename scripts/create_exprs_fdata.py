#!/usr/bin/python3
import os
import sys
import pandas as pd

featureCounts="/home/data/out/COUNTS/featureCounts";
outDir="/home/data/out/COUNTS/"
pdata="/home/data/p_data.txt"
transform_conditions=True

samples = sys.argv[1:]

#for arg in sys.argv:
#    print(arg)
#for arg in samples:
#    print(arg)


df = pd.read_csv(featureCounts, sep="\t", comment="#")
df = df.drop(["Chr", "Start", "End", "Strand", "Length"], axis=1)
df = df.set_index("Geneid")
df = df.loc[(df!=0).any(axis=1)]

df.columns = samples

df.to_csv(os.path.join(outDir, "exprs.txt"), sep="\t", header=False, index=False)

with open(os.path.join(outDir, "f_data.txt"), 'w') as outfile:
    for i in df.index:
        print(i, file=outfile)

transformer = -1
transformed = set()
with open(pdata, 'r') as pfile, open(os.path.join(outDir, "p_data.txt"), 'w') as ofile:
    i = 0
    for l in pfile:
        i += 1
        if i == 1:
            continue
        if transform_conditions:
            sp = l.split()
            if not sp[1] in transformed:
                transformed.add(sp[1])
                transformer = transformer + 1
            ofile.write("\t".join([sp[0], str(transformer)])+"\n")
            continue
        ofile.write(l)
