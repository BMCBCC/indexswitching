#!/usr/bin/env nextflow

params.fastq = '/home/data/test.fastq' 
fastq_ch = Channel.of(params.fastq) 
params.knownbarcodes = '/home/data/barcodes.txt' 
knownbarcodes_ch = Channel.of(params.knownbarcodes) 
params.outdir = './results' 

process DOWNSAMPLE { 
    input: 
    val x 

    output: 
    path '*fastq' 

    script: 
    """
    head -n 8000000 $x|tail -n 4000000 >sample.fastq
    """
} 

process BARCODES { 
    input: 
    path y 

    output: 
    path '*barcodes' 

    script: 
    """
    /net/ostrom/data/bcc/projects/nextflow/barcodeswitching/bin/format.pl $y barcodes
    """
} 

process CLEANBARCODES { 
    input:
    path bar
    val knownbar

    output: 
    path "barcodes_clean", emit: obsbc
    path "ilab_barcodes_clean", emit: stdbc
 

    script: 
    """
    cut -f2-3 $knownbar |grep -v Read>ilab_barcodes_clean
    /net/ostrom/data/bcc/projects/nextflow/barcodeswitching/bin/overlaphash.pl $bar ilab_barcodes_clean int
    /net/ostrom/data/bcc/projects/nextflow/barcodeswitching/bin/overlaphash2.pl int ilab_barcodes_clean barcodes_clean
    """
} 

process FREQMATRIX {
    publishDir params.outdir, mode: 'copy' 
    input:
    path cleanbar
    path stdbc

    output: 
    path '*_data.xlsx' 

    script: 
    """
    /home/software/python/python-3.6.4/bin/python3 /net/ostrom/data/bcc/projects/nextflow/barcodeswitching/bin/freqmatrix.py $cleanbar
    /home/software/python/python-3.6.4/bin/python3 /net/ostrom/data/bcc/projects/nextflow/barcodeswitching/bin/reorder.py 
    """
} 

process PLOTTING {
    publishDir params.outdir, mode: 'copy' 
    input:
    path x

    output: 
    path '*jpg' 

    script: 
    """
    /home/software/python/python-3.6.4/bin/python3 /net/ostrom/data/bcc/projects/nextflow/barcodeswitching/bin/heatmap.py 
    """
} 


workflow { 
    downsampleresults_ch = DOWNSAMPLE(fastq_ch) 
    barcoderesults_ch = BARCODES(downsampleresults_ch.flatten()) 
    cleanbarcoderesults_ch = CLEANBARCODES(barcoderesults_ch.flatten(),knownbarcodes_ch)
    output1_ch=cleanbarcoderesults_ch.obsbc 
    output2_ch=cleanbarcoderesults_ch.stdbc 
    freqmatrixresults_ch = FREQMATRIX(output1_ch,output2_ch) 
    plottingresults_ch = PLOTTING(freqmatrixresults_ch) 
    plottingresults_ch.view { it } 
}

