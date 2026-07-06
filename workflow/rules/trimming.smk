rule fastp:
    input:
        r1 = lambda w: SAMPLES[w.sample]["r1"],
        r2 = lambda w: SAMPLES[w.sample]["r2"],
    output:
        r1_trimmed = "results/{sample}/03_fastp/trimmed_R1.fastq.gz",
        r2_trimmed = "results/{sample}/03_fastp/trimmed_R2.fastq.gz",
        json        = "results/{sample}/03_fastp/fastp.json",
    log:
        "results/{sample}/logs/fastp.log",
    benchmark:
        "results/{sample}/benchmarks/fastp.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/fastp.yaml"
    shell:
        "fastp -i {input.r1} -I {input.r2} "
        "-o {output.r1_trimmed} -O {output.r2_trimmed} "
        "-j {output.json} -w {threads} > {log} 2>&1"

rule chopper:
    input:
        reads = lambda w: SAMPLES[w.sample]["long_reads"],
    output:
        filtered = "results/{sample}/04_chopper/reads.filtered.fastq.gz",
    params:
        min_qual = config["trimming"]["min_quality"],
        min_len  = config["trimming"]["min_length"],
    log:
        "results/{sample}/logs/chopper.log",
    benchmark:
        "results/{sample}/benchmarks/chopper.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/chopper.yaml"
    shell:
        "chopper -q {params.min_qual} -l {params.min_len} "
        "-i {input.reads} -o {output.filtered} > {log} 2>&1"
