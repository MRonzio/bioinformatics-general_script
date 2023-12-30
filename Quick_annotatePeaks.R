#!/usr/bin/env Rscript
#  annotate one-shot
library(tidyverse)
library(ChIPseeker)
library(ggrepel)
library("optparse")

#Rscript quick_annPeaks.R --peakfile NFYA_peak_summits.bed --out NFYA_annotation --genome hg38


option_list = list(
  make_option(c("-p", "--peakfile"), type="character", default=NULL, 
              help="peak summits file name", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out", 
              help="output file name [default= %default]", metavar="character"),
  make_option(c("-g", "--genome"), type="character", default=NULL,
              help="genome [hg38 or mm10]", metavar="character"),
  make_option(c("-t", "--title"), type="character", default=NULL,
              help="plot names", metavar="character")
); 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$peakfile)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

if (is.null(opt$title)){
  plot_names=opt$peakfile
}else{
  plot_names=opt$title
}
names(plot_names) = opt$peakfile

# genome setting
if(opt$gen=="hg38"){
  orgdb<-"org.Hs.eg.db"
  library(TxDb.Hsapiens.UCSC.hg38.knownGene)
  library(org.Hs.eg.db)
  txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
}else if(op$gen=="mm10"){
  orgdb<-"org.Mm.eg.db"
  library(TxDb.Mmusculus.UCSC.mm10.knownGene)
  library(org.Mm.eg.db)
  txdb_mm10 <- TxDb.Mmusculus.UCSC.mm10.knownGene
}

# gen ranges
gen_ranges_list <- function(directories,extend=T){
  grangeslist <- lapply(as.list(directories), readPeakFile)
  if(extend==T){
    grangeslist <- lapply(grangeslist,flank, width=75, both=TRUE) 
  }
  grangeslist <- GRangesList(grangeslist)
  return(grangeslist)
}

# perform annotation
run_anno <- function(txdb=txdb,orgdb=orgdb,grangeslist=grangeslist){
  peakAnnoList <- lapply(grangeslist, annotatePeak, TxDb=txdb, annoDb=orgdb,
                         tssRegion=c(-450, 50), verbose=T)
  return(peakAnnoList)
}

# collapse annotation, giving one annotation element of a list
collapse_annotations<- function(peakAnnoList_element){
  annoStats <- peakAnnoList_element@annoStat
  exon_features<-c("5' UTR","3' UTR", "1st Exon", "Other Exon","Exon")
  intron_features<- c("1st Intron", "Other Intron", "Intron")
  intergenic_features<- c("Distal Intergenic", "Downstream (<=300)", "Intergenic")
  exon_freq <- sum(annoStats[annoStats$Feature %in% exon_features,]$Frequency)
  intron_freq <- sum(annoStats[annoStats$Feature %in% intron_features,]$Frequency)
  intergenic_freq <- sum(annoStats[annoStats$Feature %in% intergenic_features,]$Frequency)
  promoter_freq <- sum(annoStats[annoStats$Feature == "Promoter",]$Frequency)
  peakAnnoList_element_collapsed <- peakAnnoList_element
  new_annoStats <- data.frame(Feature=c("Promoter","Exon","Intron","Intergenic"),
                              Frequency=c(promoter_freq,exon_freq,intron_freq,intergenic_freq))
  peakAnnoList_element_collapsed@annoStat <- new_annoStats
  return(peakAnnoList_element_collapsed)
}


# save pies function
save_pie_grid <- function(peakAnnoList=peakAnnoList,plot_names,
                          save=F,append_name=NULL,piearrow=F,rows=2){
  anno_df <- map_dfr(peakAnnoList,~ .x@annoStat, .id="exp") %>%
    dplyr::mutate(exp=fct_inorder(exp)) %>%
    group_by(exp) %>% 
    dplyr::mutate(label=scales::percent(Frequency,scale = 1,accuracy = 1)) # Compute a good label
  
  anno_df2 <- anno_df %>% mutate(csum = rev(cumsum(rev(Frequency))), 
                                 pos = Frequency/2 + lead(csum, 1),
                                 pos = if_else(is.na(pos), Frequency/2, pos)) %>%
    ungroup()
  
  p<-ggplot(anno_df2, aes(x = "" , y = Frequency, fill = fct_inorder(Feature))) +
    geom_col(width = 1, color = 1) +
    coord_polar(theta = "y") +
    scale_fill_manual(values=col_anno_names)+
    ggrepel::geom_label_repel(aes(label=label,y=pos), position = position_nudge(),
                              size=5,seed = 123, show.legend = F,
                              max.time = 1,force = 0.5) +
    facet_wrap(~ exp, nrow = rows,labeller = as_labeller(plot_names))+
    guides(fill = guide_legend(title = "Feature")) +
    theme_void()
  if(piearrow==T){
    p<-NULL
    p<-ggplot(anno_df2, aes(x = "" , y = Frequency, fill = fct_inorder(Feature),segment.color="black")) +
      geom_col(width = 1, color = 1) +
      coord_polar(theta = "y") +
      scale_fill_manual(values=col_anno_names)+
      geom_label_repel(data = anno_df2,
                       aes(y = pos, label = label),color="white",min.segment.length = 0.6,
                       size = 5, nudge_x = 1, show.legend = FALSE) +
      facet_wrap(~ exp, nrow = rows,labeller = as_labeller(plot_names))+
      guides(fill = guide_legend(title = "Feature")) +
      theme_void()
  }
  if(save==T){
    ggsave(plot=p,filename = paste0(opt$out,"annotationpies",
                         append_name,".png"),
           height = 6, width = 9, bg = "white")
  } else{
    p
  }
}  



## program...
experiments = gen_ranges_list(opt$peakfile)
peakAnnoList<-run_anno(txdb=txdb,orgdb=orgdb,grangeslist=experiments)
peakAnnoList <- map(peakAnnoList, ~ collapse_annotations(.x))

#get names of annotation and set colors
anno_names <- map(peakAnnoList,~ as.character(.x@annoStat$Feature)) %>% purrr::reduce(c) %>% unique
col_anno_names <- ChIPseeker:::getCols(9)[c(2,4,3,9)]

# plot all pies together with arrows in SVG in one row
save_pie_grid(peakAnnoList,save=F,piearrow = T,rows=1,plot_names=plot_names) +
  theme(legend.position = "bottom",strip.text = element_text(size=14),
        legend.text = element_text(size=12),legend.title = element_blank())
ggsave(filename = paste0(opt$out,"_annotationpies_forcearrow_1row.svg"),
       width = 16,height = 4,bg = "white")


