rule multiqc:
    input:
        expand("results/{sample}/01_fastqc", sample=SAMPLES.keys()),
        expand("results/{sample}/02_nanoplot", sample=SAMPLES.keys()),
        expand("results/{sample}/03_fastp", sample=SAMPLES.keys()),
        expand("results/{sample}/06_quast", sample=SAMPLES.keys()),
        expand("results/{sample}/07_busco", sample=SAMPLES.keys()),
    output:
        "results/multiqc/multiqc_report.html",
    log:
        "results/logs/multiqc.log",
    benchmark:
        "results/benchmarks/multiqc.tsv",
    conda:
        "workflow/envs/multiqc.yaml"
    shell:
        "multiqc -f -o results/multiqc {input} > {log} 2>&1"

rule copy_config:
    input:
        "config/config.yaml",
    output:
        "results/provenance/config.yaml",
    log:
        "results/logs/copy_config.log",
    conda:
        "workflow/envs/provenance.yaml"
    shell:
        "cp {input} {output} > {log} 2>&1"

rule software_versions:
    input:
        expand("results/{sample}/08_bakta/annotation.gff3", sample=SAMPLES.keys()),
    output:
        "results/provenance/software_versions.yml",
    log:
        "results/logs/software_versions.log",
    conda:
        "workflow/envs/provenance.yaml"
    script:
        "workflow/scripts/write_versions.py"

rule checksums:
    input:
        [SAMPLES[s]["r1"] for s in SAMPLES] +
        [SAMPLES[s]["r2"] for s in SAMPLES] +
        [SAMPLES[s]["long_reads"] for s in SAMPLES] +
        expand("results/{sample}/05_unicycler/assembly.fasta", sample=SAMPLES.keys()) +
        expand("results/{sample}/08_bakta/annotation.gff3", sample=SAMPLES.keys()),
    output:
        "results/provenance/checksums.tsv",
    log:
        "results/logs/checksums.log",
    conda:
        "workflow/envs/provenance.yaml"
    script:
        "workflow/scripts/generate_checksums.py"

rule aggregate_runtime:
    input:
        expand("results/{sample}/benchmarks/{rule}.tsv",
               sample=SAMPLES.keys(),
               rule=["fastqc","nanoplot","fastp","chopper","unicycler","quast","busco","bakta"]),
        "results/benchmarks/multiqc.tsv",
    output:
        "results/provenance/runtime.tsv",
    log:
        "results/logs/aggregate_runtime.log",
    conda:
        "workflow/envs/provenance.yaml"
    script:
        "workflow/scripts/aggregate_runtime.py"
