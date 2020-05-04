MergecountsFiles <- function (fileDir="path/to/counts",#file of the directory to read in
                             filePat="_Hisat2_counts.txt", #
                             fileSep="\t", #the column delimiter used in the file (e.g "," or "\t")
                             outname="hisat2"
){
  ## Returns a data.frame with the mergeCounts
  
  # Make sure that the fileDir has training slash
  if (length(grep("/$", fileDir))==0){
    fileDir<- paste(fileDir,"/", sep="")
  }
  
  # Get Files
  setwd(fileDir)
  samples = list.files(fileDir, pattern=filePat)
  names = gsub(filePat,"",samples)
  cov <- list()
  for (i in names) {
    filepath <- file.path(fileDir,paste(i,filePat,sep=""))
    count[[i]] <- read.table(filepath,sep = fileSep, header=F, stringsAsFactors=FALSE)
    count[[i]]<-count[[i]][,-2]
    colnames(count[[i]]) <- c("ID",i)
  }
  df <-Reduce(function(x,y) merge(x = x, y = y, by ="ID"), cov)
  df<-df[-(1:5),]
  write.table(df,paste(fileDir, outname,".txt",sep=""), sep="\t", quote= F, row.names = F)
  return(df)
}
