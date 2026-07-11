rule bakta:
    input:
        "results/{sample}/05_unicycler/assembly.fasta",
    output:
        "results/{sample}/08_bakta/annotation.gff3",
    params:
        outdir  = "results/{sample}/08_bakta",
        db_path = config["bakta"]["db_path"],
    log:
        "results/{sample}/logs/bakta.log",
    benchmark:
        "results/{sample}/benchmarks/bakta.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/bakta.yaml"
    shell:
        "bakta --db {params.db_path} --output {params.outdir} "
        "--threads {threads} {input} > {log} 2>&1"
