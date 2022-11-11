# Depends on: rule star_index
rule star:
    input:
        fq1=["../resources/reads/{sample}.fastq.gz"],
        idx=directory("resources/ref/star_genome")
    output:
        aln="results/mapped/star/{sample}.bam",
        log="results/mapped/star/log/log_{sample}.out",
        log_final="results/mapped/star/log/log_{sample}.final.out"
    log: "logs/star/{sample}.log"
    params: extra="--outSAMtype BAM Unsorted"
    threads: config["params"]["general"]["threads"]
    #wrapper: "v1.10.0/bio/star/align"
    wrapper: config["wrapper_version"] + "/bio/star/align"

# Depends on: rule get_genome and rule get_annotation
rule star_index:
   input:
       fasta="resources/ref/genome.fasta",
       annotation="resources/ref/genome.gtf"
   output: directory("resources/ref/star_genome"),
   threads: config["params"]["general"]["threads"]
   #params: extra="--sjdbGTFfile {input.annotation} --sjdbOverhang 100"
   log: "logs/star_index_genome.log"
   cache: True
   wrapper: config["wrapper_version"] + "/bio/star/index"
