#!/usr/bin/env Rscript
##Usage example
#./PostMappingAnalysis.R -b bam -o path -t 6


library("optparse")

option_list = list(
  make_option(c("-b", "--MappingFile"), type="character", default=NULL, 
              help="Path to the mapping file in bam format", metavar="bam"),
  
  make_option(c("-o", "--output"), type="character", default="Stdout", 
              help="Output directory for all files created", metavar="PATH"),
  
  make_option(c("-t", "--threads"), type="numeric", default="5", 
              help="number of threads", metavar="threads")
  
  
  
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if (is.null(opt$MappingFile)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

cat("##--------------------------------",'\n')   
cat("##01 Inputs",'\n')
cat("##--------------------------------",'\n') 

cat(paste(c("Bam file:",opt$MappingFile), collapse='\t'), '\n')
cat(paste(c("output directory:",opt$output), collapse='\t'), '\n')
cat(paste(c("number of threads:",opt$threads), collapse='\t'), '\n')

cat("##--------------------------------",'\n')   
cat("##02 Flagstat",'\n')
cat("##--------------------------------",'\n') 

cat(paste(c("Start:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')

system(paste0("samtools flagstat ",opt$output))

cat(paste(c("End:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')

cat("##--------------------------------",'\n')   
cat("##03 Qualimap BamQC",'\n')
cat("##--------------------------------",'\n') 

cat(paste(c("Start:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')

system(paste0("mkdir -p ",opt$output,"/bamqc"))
system(paste0("qualimap bamqc -bam ",opt$MappingFile," -outdir ",opt$output,"/bamqc --java-mem-size=2G " ))

cat(paste(c("End:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')

cat("##--------------------------------",'\n')   
cat("##04 Indexing",'\n')
cat("##--------------------------------",'\n') 

cat(paste(c("Start:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')

system(paste0("samtools index ",opt$MappingFile))

cat(paste(c("End:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')

cat("##--------------------------------",'\n')   
cat("##05 mapping bams",'\n')
cat("##--------------------------------",'\n') 

cat(paste(c("Start:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')

system(paste0("samtools view -F 4 ",opt$MappingFile , " > ",opt$output,"/OnlyMapped_sorted.bam "))
system(paste0("samtools view -f 4 ",opt$MappingFile , " > ",opt$output,"/OnlyUnmapped_sorted.bam "))

cat(paste(c("End:",cat(as.character(Sys.time()[1]))), collapse='\t'), '\n')



