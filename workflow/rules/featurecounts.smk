# Depends on: rule bowtie2, salmon or star mapper
rule feature_counts_ensemblid:
    input:
        bams=expand("results/mapped/" + config["params"]["mapper"] + "/{sample}.bam", sample=SAMPLES),
        # bams=expand("results/mapped/bowtie2/{sample}.bam", sample=SAMPLES),
        gtf="resources/ref/genome.gtf"
    output: "results/counts/raw_count_matrix_ensemblid.tsv"
    threads: config["params"]["general"]["threads"]
    log: "logs/feature_counts.log"
    conda: "../envs/general.yaml"
    shell:
        """
        featureCounts -T {threads} -t gene -g gene_id -F 'gtf' -a {input.gtf} -o {output} {input.bams} 2> {log}
        """
