#suppressMessages(library(jsonlite))
suppressMessages(library(ggplot2))
suppressMessages(library(tidyverse))

norm.exp  <- readr::read_tsv(file = snakemake@input[["log2cpm"]]) %>% tibble::column_to_rownames("Symbol")
phenodata <- readr::read_tsv(file = snakemake@input[["phenodata"]])
phenodata <- phenodata[ phenodata$Sample %in% colnames( norm.exp ), ]
norm.exp  <- norm.exp[ ,c( as.character( phenodata$Sample ) ) ]
phenodata <- phenodata[ phenodata$Sample %in% colnames( norm.exp ), ]

# transpose the data to have variables (genes) as columns
data_for_PCA <- t(norm.exp)

# calculate MDS (matrix of dissimilarities)
mds <- cmdscale(dist(data_for_PCA), k=3, eig=TRUE)
# k = the maximum dimension of the space which the data are to be represented in
# eig = indicates whether eigenvalues should be returned  

# transform the Eigen values into percentage
eig_pc <- mds$eig * 100 / sum(mds$eig)
eig_pc <- eig_pc[1:10]
p <- ggplot(data = data.frame(eigen = eig_pc, PC = paste0("Dim ", 1:length(eig_pc))), aes(x = reorder(PC, -eigen), eigen)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(text = element_text(size = 8), axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Dimensions") +
  ylab("Explained var.")
ggsave(filename = snakemake@output[[1]], plot = p, width = 3, height = 4)

## calculate MDS
mds           <- as.data.frame(cmdscale(dist(data_for_PCA), k=3)) # Performs MDS analysis
mds$Condition <- phenodata$Class
mds$Timepoint <- phenodata$Timepoint
colnames(mds) <- c("Dim1", "Dim2", "Dim3", "Condition", "Timepoint")

p <- ggplot(mds, aes(Dim1, Dim2, shape=Condition, color=Timepoint)) +
  geom_point(size=3) +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(text = element_text(size = 8), legend.position = "top") +
  xlab(paste0("Dim 1 (", format(eig_pc[1], digits = 4), "% explained var.)")) +
  ylab(paste0("Dim 2 (", format(eig_pc[2], digits = 4), "% explained var.)")) +
  coord_cartesian(xlim = 1.2 * c(min(mds$Dim1), max(mds$Dim1)),
                  ylim = 1.2 * c(min(mds$Dim2), max(mds$Dim2))) +   # change axis limits
  coord_fixed() +
  xlim(c(ceiling(min(mds$Dim1))-1,ceiling(max(mds$Dim1))+1)) +
  ylim(c(ceiling(min(mds$Dim2))-1,ceiling(max(mds$Dim2))+1))
ggsave(filename = snakemake@output[[2]], plot = p, width = 6, height = 6)
