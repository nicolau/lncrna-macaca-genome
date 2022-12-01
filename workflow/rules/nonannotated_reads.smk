rule bamtobed:
    input: "results/mapped/" + config["params"]["mapper"] + "/{sample}.bam",
    output: "results/mapped/" + config["params"]["mapper"] + "/{sample}.bed",
    log: "logs/bamtobed/{sample}.log",
    params: extra="-bedpe",  # optional parameters
    wrapper: config["wrapper_version"] + "/bio/bedtools/bamtobed"

rule bedtools_merge:
    input:
        left="results/mapped/" + config["params"]["mapper"] + "/{sample}.bed",
        right="resources/ref/genome.bed"
    output: "results/counts/intersect/{sample}.intersected.bed"
    params:
        ## Add optional parameters
        extra="-wa -wb" ## In this example, we want to write original entries in A and B for each overlap.
    log: "logs/intersect/{sample}.log"
    wrapper: config["wrapper_version"] + "/bio/bedtools/intersect"

rule get_unannotated_reads:
    input: "results/counts/intersect/{sample}.intersected.bed"
    output: "results/counts/unannotated/{sample}.ids"
    shell:
        """
        cat {input} > {output}
        """

#rule combine_unannotated_reads:
#    input: ""
#    output: ""