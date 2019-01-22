#ggplot lib
library(ggplot2)
#plot scaling lib
library(scales)
#column selection lib
library(dplyr)

## Collect arguments
args <- commandArgs(TRUE)

## Parse arguments (we expect the form --arg=value)
parseArgs <- function(x) strsplit(sub("^--", "", x), "=")
argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
argsL <- as.list(as.character(argsDF$V2))
names(argsL) <- argsDF$V1

for (i in 1:length(argsL)){
  if(names(argsL)[i] == "file"){
    perfData <- read.csv(file=(argsL)$file, header=TRUE, sep=",")
  }
}
taillesGrille <- unique(select(perfData, taille_cote_grille))
print(taillesGrille)
for(i in 1:nrow(taillesGrille)){
  print("taille=")
  print(taillesGrille[i,])
  perfDataFiltered <- perfData[perfData$taille_cote_grille ==  taillesGrille[i,],]
  print(perfDataFiltered)
  perfPlot <- ggplot(perfDataFiltered, aes(x = nb_threads, y=tempsMoyen))+ geom_col() + scale_x_log10(breaks = trans_breaks("log2", function(x) 2^x),
                                                                                              labels = trans_format("log2", math_format(2^.x)))
  ggsave(paste("PassageEchelleFort-", taillesGrille[i,], "x", taillesGrille[i,], ".png"))
}
