# Depends on: rule bowtie2_build
rule bowtie2:
    input:
        sample=["results/trimmed/{sample}.paired.R1.fastq.gz", "results/trimmed/{sample}.paired.R2.fastq.gz"],
        idx=multiext(
            "resources/ref/index/genome",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
    output: "results/mapped/bowtie2/{sample}.bam"
    # resources: machine_type="e2-standard-16"
    log: "logs/bowtie2/{sample}.log"
    params:
        extra="",  # optional parameters
    threads: config["params"]["general"]["threads"]  # Use at least two threads
    wrapper: config["wrapper_version"] + "/bio/bowtie2/align"

# Depends on: rule get_genome
rule bowtie2_build:
    input: ref="resources/ref/genome.fasta",
    output:
        multiext(
            "resources/ref/index/genome",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
    log: "logs/bowtie2_build/build.log",
    params: extra="",  # optional parameters
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/bowtie2/build"
