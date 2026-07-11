rule unicycler:
    input:
        r1   = "results/{sample}/03_fastp/trimmed_R1.fastq.gz",
        r2   = "results/{sample}/03_fastp/trimmed_R2.fastq.gz",
        long = "results/{sample}/04_chopper/reads.filtered.fastq.gz",
    output:
        assembly = "results/{sample}/05_unicycler/assembly.fasta",
    params:
        outdir = "results/{sample}/05_unicycler",
    log:
        "results/{sample}/logs/unicycler.log",
    benchmark:
        "results/{sample}/benchmarks/unicycler.tsv",
    threads: config["resources"]["default_threads"]
    resources:
        mem_mb = config["resources"]["memory_mb"]
    conda:
        "workflow/envs/unicycler.yaml"
    shell:
        "unicycler -1 {input.r1} -2 {input.r2} -l {input.long} "
        "-o {params.outdir} -t {threads} > {log} 2>&1"
