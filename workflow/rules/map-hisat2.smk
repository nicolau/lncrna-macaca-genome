rule hisat2_index:
    input: fasta = "{genome}.fasta"
    output: directory("index_{genome}")
    params: prefix = "index_{genome}/"
    log: "logs/hisat2_index_{genome}.log"
    threads: 2
    wrapper: "v1.7.2/bio/hisat2/index"

rule hisat2_align:
    input: reads=["reads/{sample}_R1.fastq", "reads/{sample}_R2.fastq"]
    output: "mapped/{sample}.bam"
    log: "logs/hisat2_align_{sample}.log"
    params:
      extra="",
      idx="index/",
    threads: 2
    wrapper: config["wrapper_version"] + "/bio/hisat2/align"
