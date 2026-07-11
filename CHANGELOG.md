# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-07-11

### Added

- Initial release.
- Snakemake workflow: FastQC + NanoPlot → fastp + chopper → Unicycler → QUAST + BUSCO → Bakta → MultiQC.
- Per‑rule Conda environments for conflict‑free dependency management.
- Pinned Docker & Apptainer containers (mambaforge:24.7.1‑0).
- Full provenance collection (config, versions, checksums, runtime).
- Self‑contained Snakemake report (manual generation).
- Multi‑sample support via sample sheet.
- Configurable trimming thresholds for chopper.
