# https://cpat.readthedocs.io/en/latest/#
rule make_hexamer:
    input:
        coding_fa="resources/ref/cds.fasta",
        noncoding_fa="resources/ref/ncrna.fasta"
    output: "results/coding_potential/hexamer.tsv"
    conda: "../envs/coding_potential.yaml"
    shell:
        """
        make_hexamer_tab.py -c {input.coding_fa} -n {input.noncoding_fa} > {output}
        """

rule gtf2bed:
    input: "resources/ref/genome.gtf"
    output: "resources/ref/genome.bed"
    log: ""
    conda: "../envs/coding_potential.yaml"
    #shell: "cat {input} | grep '^#' | gtf2bed --do-not-sort > {output}"
    shell: "../scripts/gtf2bed.pl --input {input} > {output}"

rule coding_potential_bed:
    input:
        logitmodel="logitModel.RData",
        coding_bed="resources/ref/genome.bed",
        ref="resources/ref/genome.fasta"
    output: "output3"
    conda: "../envs/coding_potential.yaml"
    shell:
        """
        cpat.py -x {rules.make_hexamer.output} --antisense -d {input.logitmodel} --top-orf=5 -g {input.coding_bed} -r {input.ref} -o {output}
        """
