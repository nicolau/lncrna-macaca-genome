# Depends on: rule salmon_quant_reads
rule tximport:
    input:
        quant = expand("results/mapped/salmon/{sample}/quant.sf")
        # Optional transcript/gene links as described in tximport
        # tx2gene = /path/to/tx2gene
    output: txi = "txi.RDS"
    params: extra = "type='salmon', txOut=TRUE"
    wrapper: config["wrapper_version"] + "/bio/tximport"
