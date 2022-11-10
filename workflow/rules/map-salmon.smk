# Depends on: rule salmon_index
rule salmon_quant_reads:
    input:
        # If you have multiple fastq files for a single sample (e.g. technical replicates)
        # use a list for r1 and r2.
        r1 = "../resources/reads/{sample}.fastq.gz",
        index = "resources/ref/salmon_index"
    output:
        quant = "results/mapped/salmon/{sample}/quant.sf",
        lib = "results/mapped/salmon/{sample}/lib_format_counts.json"
    log: "logs/salmon/{sample}.log"
    params:
        # optional parameters
        libtype ="A",
        #zip_ext = bz2 # req'd for bz2 files ('bz2'); optional for gz files('gz')
        extra=""
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/salmon/quant"

# Depends on: rule get_transcriptome
rule salmon_index:
    input: "resources/ref/transcriptome.fa"
    output: directory("resources/ref/salmon_index")
    log: "logs/salmon/transcriptome_index.log"
    threads: config["params"]["general"]["threads"]
    params: extra=""
    wrapper: config["wrapper_version"] + "/bio/salmon/index"
