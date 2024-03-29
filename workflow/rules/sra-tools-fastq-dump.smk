rule get_fastq_pe:
    output:
        # the wildcard name must be accession, pointing to an SRA number
        "data/pe/{accession}_1.fastq",
        "data/pe/{accession}_2.fastq"
    log: "logs/pe/{accession}.log"
    params: extra="--skipe-technical"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/sra-tools/fasterq-dump"

rule get_fastq_pe_gz:
    output:
        # the wildcard name must be accession, pointing to an SRA number
        "data/pe/{accession}_1.fastq.gz",
        "data/pe/{accession}_2.fastq.gz"
    log: "logs/pe/{accession}.gz.log"
    params: extra="--skip-technical"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/sra-tools/fasterq-dump"

rule get_fastq_pe_bz2:
    output:
        # the wildcard name must be accession, pointing to an SRA number
        "data/pe/{accession}_1.fastq.bz2",
        "data/pe/{accession}_2.fastq.bz2",
    log: "logs/pe/{accession}.bz2.log"
    params: extra="--skip-technical"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/sra-tools/fasterq-dump"

rule get_fastq_se:
    output: "data/se/{accession}.fastq"
    log: "logs/se/{accession}.log"
    params: extra="--skip-technical"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/sra-tools/fasterq-dump"

rule get_fastq_se_gz:
    output: "data/se/{accession}.fastq.gz"
    log: "logs/se/{accession}.gz.log"
    params: extra="--skip-technical"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/sra-tools/fasterq-dump"

rule get_fastq_se_bz2:
    output: "data/se/{accession}.fastq.bz2"
    log: "logs/se/{accession}.bz2.log"
    params: extra="--skip-technical"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/sra-tools/fasterq-dump"
