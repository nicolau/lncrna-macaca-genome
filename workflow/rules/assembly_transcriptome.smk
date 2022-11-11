rule samtools_sort:
    input: "results/mapped/bowtie2/{sample}.bam"
    output: "results/mapped/bowtie2/{sample}.sorted.bam"
    #log: "logs/samtools_sort.log"
    params: extra="" # optional parameters
    threads: config["params"]["general"]["threads"] # Use at least two threads
	conda: "../envs/general.yaml"
	wrapper: config["wrapper_version"] + "/bio/samtools/sort"

#rule samtools_index:
#    input: "results/mapped/bowtie2/{sample}.sorted.bam"
#    output: "results/mapped/bowtie2/{sample}.sorted.bam.bai"
#    log: "logs/samtools_index.log"
#    params: extra="" # optional parameters
#    threads: config["params"]["general"]["threads"] # Use at least two threads
#	conda: "../envs/general.yaml",
#	wrapper: config["wrapper_version"] + "/bio/samtools/index"

#### Assembly and Quantificaion ####

# Initial assembly of transcripts with StringTie for each sample 
rule stringtie_initial:
	input: 
		sbam="results/mapped/bowtie2/{sample}.sorted.bam",
		anno="resources/ref/genome.gtf"
	output: temp("results/assembly/stringtie/{sample}.gtf")
	log: "logs/stringtie/{sample}.log"
	threads: config["params"]["general"]["threads"] # Use at least two threads
	conda: "../envs/assembly.yaml"
	shell: "stringtie -v -p {threads} -G {input.anno} -o {output} {input.sbam} 2> {log}"

# Merge assembled transcripts from all samples. This produces a single, consistent set of transcripts and should overcome low coverage (leading to fragmented transcripts in some samples.
rule stringtie_merge:
	input: 
		gtf=expand("results/assembly/stringtie/{sample}.gtf", sample=SAMPLES), # or prepare a mergelist.txt of files.
		anno="resources/ref/genome.gtf"
	output: "results/assembly/stringtie/merged_assembly.gtf"
	log: "logs/stringtie/merge.log"
	threads: config["params"]["general"]["threads"] # Use at least two threads
	conda: "../envs/assembly.yaml"
	shell: "stringtie -v --merge -p {threads} -G {input.anno} -o {output} {input.gtf} 2> {log}"

# Comparison of reference annotation with all transcripts assembled by stringtie --merge. Thereby usefull class codes are assigned describing the relation betwenn reference transcripts and assembled transcripts.
rule gffcompare_transcripts:
	input:
		st_transcripts="results/assembly/stringtie/merged_assembly.gtf",
		anno="resources/ref/genome.gtf"
	output: "results/assembly/stringtie/gffcompare/GFFcompare.annotated.gtf"
	threads: config["params"]["general"]["threads"] # Use at least two threads
	conda: "../envs/assembly.yaml"
	shell: "gffcompare -G -r {input.anno} -o results/assembly/stringtie/gffcompare/GFFcompare {input.st_transcripts}"

# New stringtie assembly and quantification restricted to the transcript set produced by stringtie --merge. Additional input for ballgown analysis is prepared.
rule stringtie_ballgown:
	input: 
		#anno=rules.stringtie_merge.output[1]
		anno="results/assembly/stringtie/merged_assembly.gtf", 	# important to use set of merged transcripts as annotation file!!
		sbam="results/mapped/bowtie2/{sample}.sorted.bam"
	output: "results/assembly/stringtie/ballgown/{sample}.gtf"
	threads: config["params"]["general"]["threads"] # Use at least two threads
	conda: "../envs/assembly.yaml"
	shell: "stringtie -e -B -p {threads} -G {input.anno} -o {output} {input.sbam}"

# TODO this rule is presenting an error:
# Error: no GTF files found under base directory ../ballgown !
# I dont know how to figure out yet.
# generation of gene and transcript count matrices from stringtie quanitification using the python 2.7 script coming with stringtie. 
#rule count_tables:
#	input: expand("results/assembly/stringtie/ballgown/{sample}.gtf", sample=SAMPLES)
#	output:
#		"results/assembly/stringtie/counts/gene_count_matrix.csv",
#		"results/assembly/stringtie/counts/transcript_count_matrix.csv"
#	conda: "../envs/assembly_count_tables.yaml"
#	shell:
#		"""
#		cd results/assembly/stringtie/counts/
#		ls ../ballgown
#		python ../../../scripts/prepDE.py -i ../ballgown
#		"""


# TODO prepare a trinity rule for single- and paired-end libraries
#rule trinity:
#    input:
#		left=expand("../resources/reads/{sample}_1.fastq.gz", sample=SAMPLES),
#        right=expand("../resources/reads/{sample}_2.fastq.gz", sample=SAMPLES)
#    output: "results/assembly/trinity/Trinity.fasta"
#    log: 'logs/trinity/trinity.log'
#    params: extra=""
#    threads: config["params"]["general"]["threads"] # Use at least two threads
#    # optional specification of memory usage of the JVM that snakemake will respect with global
#    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
#    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
#    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
#    resources: mem_gb=10
#    wrapper: config["wrapper_version"] + "/bio/trinity"