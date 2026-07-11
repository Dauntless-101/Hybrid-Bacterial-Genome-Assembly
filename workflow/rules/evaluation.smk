rule quast:
    input:
        "results/{sample}/05_unicycler/assembly.fasta",
    output:
        "results/{sample}/06_quast/report.tsv",
    params:
        outdir = "results/{sample}/06_quast",
    log:
        "results/{sample}/logs/quast.log",
    benchmark:
        "results/{sample}/benchmarks/quast.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/quast.yaml"
    shell:
        "quast.py {input} -o {params.outdir} -t {threads} --silent > {log} 2>&1"

rule busco:
    input:
        "results/{sample}/05_unicycler/assembly.fasta",
    output:
        "results/{sample}/07_busco/short_summary.txt",
    params:
        outdir  = "results/{sample}/07_busco",
        lineage = config["busco"]["lineage"],
    log:
        "results/{sample}/logs/busco.log",
    benchmark:
        "results/{sample}/benchmarks/busco.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/busco.yaml"
    shell:
        "busco -i {input} -o {params.outdir} "
        "-l {params.lineage} -m genome -c {threads} --offline "
        "> {log} 2>&1"
