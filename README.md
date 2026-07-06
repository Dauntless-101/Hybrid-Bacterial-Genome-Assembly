# Hybrid-Bacterial-Genome-Assembly

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.0-brightgreen.svg)](https://snakemake.github.io)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com)
[![Apptainer](https://img.shields.io/badge/apptainer-ready-blue.svg)](https://apptainer.org)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.XXXXXX-orange.svg)](https://doi.org/10.5281/zenodo.XXXXXX)

**A reproducible Snakemake workflow for hybrid bacterial genome assembly from Illumina short reads and Oxford Nanopore long reads.**

---

## Introduction

**Hybrid-Bacterial-Genome-Assembly** is a reproducible, modular pipeline that combines the high base‑accuracy of Illumina short reads with the contiguity of Oxford Nanopore long reads to produce highly complete, high‑quality bacterial genomes. Starting from raw FASTQ files of both types, the pipeline performs quality control, read trimming and filtering, hybrid *de novo* assembly with Unicycler, assembly evaluation, and genome annotation.

The workflow is implemented in Snakemake and designed around **reproducibility, portability, and transparency**.  
It uses **per‑rule Conda environments** to eliminate dependency conflicts, records software versions and runtime benchmarks, captures full provenance, and can be executed identically via Conda, Docker, or Apptainer.

Designed for bacterial genomes, the pipeline is expected to perform robustly across a broad range of bacterial taxa, subject to sequencing quality and genome characteristics.

---

## Features

- End‑to‑end hybrid assembly and annotation from raw Illumina paired‑end and ONT FASTQ files  
- **Multi‑sample support** via a simple sample sheet (TSV)  
- **Per‑rule Conda environments** — no dependency conflicts  
- Conda, Docker, and Apptainer support with pinned container images  
- Automatic software version tracking and runtime benchmarking  
- Adapter trimming and quality filtering for both read types  
- Gold‑standard hybrid assembler **Unicycler** (polishes internally, no separate step needed)  
- Comprehensive quality assessment (QUAST, BUSCO)  
- Modern structural & functional annotation with Bakta  
- Aggregated MultiQC report and self‑contained HTML final report via Snakemake  
- **Full provenance capture**: config, versions, checksums, and run metadata  

---

## Reproducibility

This workflow is built to guarantee computational reproducibility:

- ✅ Tiny per‑rule Conda environments, each with pinned dependencies  
- ✅ Docker & Apptainer images with **fixed base image tags** (mambaforge:24.7.1‑0)  
- ✅ Automatic recording of all software versions (`provenance/software_versions.yml`)  
- ✅ Runtime benchmarks for every rule  
- ✅ Detailed log files per rule  
- ✅ Deterministic output directory structure  
- ✅ Full provenance folder: config copy, checksums, runtime, and invocation  

---

## Pipeline overview

```mermaid
flowchart TD
    A[Illumina paired FASTQ] --> B[FastQC]
    C[ONT long FASTQ] --> D[NanoPlot]
    B --> E[fastp trimming / filtering]
    D --> F[chopper filtering]
    E --> G[Unicycler hybrid assembly]
    F --> G
    G --> H[QUAST]
    G --> I[BUSCO]
    H --> J[Bakta annotation]
    I --> J
    J --> K[MultiQC]
    K --> L[Snakemake report + provenance]
Tool table
Step	Tool	Purpose / Output
1	FastQC	Illumina read QC → HTML reports
2	NanoPlot	ONT read quality visualisation → plots & stats
3	fastp	Illumina adapter removal, quality trimming → cleaned paired FASTQ
4	chopper	ONT read length / quality filtering → filtered FASTQ
5	Unicycler	Hybrid assembly using both read types, with internal polishing → final genome
6	QUAST	Assembly contiguity & correctness metrics → report
7	BUSCO	Genome completeness → lineage‑based scores
8	Bakta	Structural/functional annotation → GFF3, GBK, etc.
9	MultiQC	Aggregates all QC logs → interactive HTML
10	Snakemake report	Built‑in self‑contained report with DAG, runtimes, embedded outputs (run manually after the pipeline)
11	Provenance rule	Collects config, versions, checksums, runtime
Tool selection rationale
Why Unicycler?
Unicycler is the most widely adopted hybrid assembler for bacterial genomes. It combines SPAdes’ short‑read assembly with long‑read scaffolding in a graph‑based framework, resolving repeats and frequently circularising chromosomes. It automatically runs Pilon polishing using the short reads, so no separate polishing step is needed.

Why NanoPlot instead of LongQC?
NanoPlot is the current standard for visualising Oxford Nanopore read quality. It produces publication‑ready plots of read length, quality, and throughput, and is actively maintained. LongQC, while useful historically, was designed for older ONT chemistries and is no longer the preferred QC tool in modern workflows.

Why fastp and chopper?
fastp and chopper are modern, fast replacements for Trimmomatic and NanoFilt respectively. They are actively maintained, produce structured reports for MultiQC, and are extremely performant.

Why Bakta?
Bakta is actively maintained, faster, and more accurate than Prokka. It handles databases transparently and outputs standardised annotation files directly usable in downstream analyses.

Why per‑rule environments?
Single‑environment workflows often suffer from version conflicts. By giving each tool its own minimal Conda environment, we guarantee that updates or changes to one tool never break another. This is the same approach used by nf‑core pipelines.

Repository structure
text
Hybrid-Bacterial-Genome-Assembly/
├── README.md
├── CITATION.cff
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── environment.yml                  # Snakemake + Mamba only
├── Dockerfile
├── Singularity.def
├── config/
│   └── config.yaml
├── workflow/
│   ├── Snakefile
│   ├── rules/
│   │   ├── qc.smk
│   │   ├── trimming.smk
│   │   ├── assembly.smk
│   │   ├── evaluation.smk
│   │   ├── annotation.smk
│   │   └── report.smk
│   ├── envs/
│   │   ├── fastqc.yaml
│   │   ├── nanoplot.yaml
│   │   ├── fastp.yaml
│   │   ├── chopper.yaml
│   │   ├── unicycler.yaml
│   │   ├── quast.yaml
│   │   ├── busco.yaml
│   │   ├── bakta.yaml
│   │   └── multiqc.yaml
│   └── scripts/
│       ├── write_versions.py
│       ├── generate_checksums.py
│       └── aggregate_runtime.py
└── docs/
    ├── installation.md
    ├── workflow.md
    ├── tools.md
    ├── faq.md
    └── troubleshooting.md
Requirements
Snakemake ≥ 8.0

Conda (Miniconda or Miniforge) or Docker or Apptainer

BUSCO lineage dataset (pre‑downloaded) and Bakta database (pre‑downloaded) – see Setup
