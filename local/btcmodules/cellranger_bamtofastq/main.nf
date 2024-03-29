process CELLRANGER_BAMTOFASTQ{
    time '96h'
    cpus 1
    memory '10 GB'
    label 'process_medium'

    input:
        path(per_sample_data)
    output:
        tuple(val("${per_sample_data.baseName}"), path("output"), path("${per_sample_data}/*metrics_summary.csv"))
    script:
        """
            cellranger_utils bam-to-fastq \
              --bam_file $per_sample_data/*bam \
              --metrics $per_sample_data/*metrics_summary.csv \
              --outdir output \
              --tempdir temp
        """
    stub:
        """
        mkdir output
        mkdir -p "${per_sample_data.baseName}"
        touch "${per_sample_data.baseName}/metrics_summary.csv"
        """
}
