rule fastqc:
    input:
        r1 = lambda w: SAMPLES[w.sample]["r1"],
        r2 = lambda w: SAMPLES[w.sample]["r2"],
    output:
        html1 = "results/{sample}/01_fastqc/{sample}_R1_fastqc.html",
        html2 = "results/{sample}/01_fastqc/{sample}_R2_fastqc.html",
    log:
        "results/{sample}/logs/fastqc.log",
    benchmark:
        "results/{sample}/benchmarks/fastqc.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/fastqc.yaml"
    shell:
        "fastqc -t {threads} -o results/{wildcards.sample}/01_fastqc {input.r1} {input.r2} > {log} 2>&1"

rule nanoplot:
    input:
        reads = lambda w: SAMPLES[w.sample]["long_reads"],
    output:
        directory("results/{sample}/02_nanoplot/"),
    log:
        "results/{sample}/logs/nanoplot.log",
    benchmark:
        "results/{sample}/benchmarks/nanoplot.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/nanoplot.yaml"
    shell:
        "NanoPlot --fastq {input.reads} -o results/{wildcards.sample}/02_nanoplot -t {threads} > {log} 2>&1"
