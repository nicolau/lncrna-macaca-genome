rule trim_pe:
    input:
        r1="../resources/reads/{sample}_R1_001.fastq.gz",
        r2="../resources/reads/{sample}_R2_001.fastq.gz"
    output:
        r1="results/trimmed/{sample}.paired.R1.fastq.gz",
        r2="results/trimmed/{sample}.paired.R2.fastq.gz"
    log: "logs/trim/{sample}.pe.log"
    params:
        # List of trimmers (see manual)
        trimmer=["TRAILING:3"],
        # Optional parameters
        extra=""
        compression_level="-9"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/trimmomatic/pe"

rule trim_se:
    input: "../resources/reads/{sample}.fastq.gz"
    output: "results/trimmed/{sample}.filtered.fastq.gz"
    log: "logs/trim/{sample}.se.log"
    params:
        # List fo trimmers (see manual)
        trimmer=["TRAILING:3"],
        # Optional parameters
        extra="",
        # Optional compression levels from -0 to -9 and -11
        compression_level="-9"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/trimmomatic/se"
