#!/usr/bin/env python3
import pandas as pd

dfs = []
for f in snakemake.input:
    try:
        df = pd.read_csv(f, sep="\t")
        df["file"] = f
        dfs.append(df)
    except Exception:
        pass
if dfs:
    pd.concat(dfs, ignore_index=True).to_csv(snakemake.output[0], sep="\t", index=False)
else:
    pd.DataFrame(columns=["file"]).to_csv(snakemake.output[0], sep="\t", index=False)
