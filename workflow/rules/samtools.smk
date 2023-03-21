env = "workflow/envs/samtools.yaml"

rule convert_to_bam:
    input:
        sam_file="results/sam/tiny/{sample}.sam"
    output:
        bam_file="results/bam/{sample}.bam"
    threads: 4
    conda:
        env
    shell:
        "samtools view -@ {threads} -S -b {input.sam_file} > {output.bam_file}"

rule sort_bam:
    input:
        bam_file="results/bam/{sample}.bam"
    output:
        sorted_bam_file="results/bam_sorted/{sample}.sorted.bam"
    threads: 4
    conda:
        env
    shell:
        "samtools sort -@ {threads} -o {output.sorted_bam_file} {input.bam_file}"

rule index_bam:
    input:
        sorted_bam_file="results/bam_sorted/{sample}.sorted.bam"
    output:
        index_file="results/bam_sorted/{sample}.sorted.bam.bai"
    threads: 4
    conda:
        env
    shell:
        "samtools index -@ {threads} {input.sorted_bam_file} {output.index_file}"

rule mapping_stats:
    input:
        sorted_bam_file="results/bam_sorted/{sample}.sorted.bam",
        index_file="results/bam_sorted/{sample}.sorted.bam.bai"
    output:
        stats_file="results/stats/{sample}_aug.txt"
    threads: 4
    conda:
        env
    shell:
        "samtools idxstats -@ {threads} {input.sorted_bam_file} > {output.stats_file}"