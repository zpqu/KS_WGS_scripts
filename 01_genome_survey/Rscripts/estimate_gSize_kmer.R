## 08/01/2010
## Zhipeng

files = list.files(path = "./", pattern = "mer.histo$")
sum.df = as.data.frame(matrix(0, length(files), 5))

for(k in 1:length(files)){
  i = gsub("mer.histo$", "", files[k])
  histoName = paste0(i, "mer.out.histo")
  kmer.hist.df = read.table(paste0(i, "mer.histo"))
  peakY = max(kmer.hist.df$V2[10:100])
  peakX = kmer.hist.df$V1[kmer.hist.df$V2 == peakY][1]

  #calculate the genome size
  nkmer = sum(as.numeric(kmer.hist.df$V1[-1])*as.numeric(kmer.hist.df$V2[-1])) 
  gSize = round(sum(as.numeric(kmer.hist.df$V1[-1])*as.numeric(kmer.hist.df$V2[-1]))/peakX)
  singleC = round(sum(as.numeric(kmer.hist.df$V1[2:50])*as.numeric(kmer.hist.df$V2[2:50]))/peakX)
  singleC.per = round((singleC/gSize)*100, digits = 2)
  print(paste0("The estimated genome size is: ~", format(gSize, big.mark = ",", scientific = F)))

  sum.df[k, 1] = i
  sum.df[k, 2] = format(nkmer, big.mark = ",", scientific = F)
  sum.df[k, 3] = format(gSize, big.mark = ",", scientific = F)
  sum.df[k, 4] = format(singleC, big.mark = ",", scientific = F)
  sum.df[k, 5] = singleC.per

  #plot frequencing counting (1 to 200) of kmers without poisd
  pdf(file = paste0(i, "mer.histo.pdf"), width = 9, height = 4.5)
  plot(kmer.hist.df[1:100, ], type = "l",
  main = (paste0(i, "mer")),
  xlab = ("Frequency counting"),
  ylab = ("Number of kmers"))
  points(kmer.hist.df[1:100, ], cex = 0.5)
  abline(v = peakX, col = "blue")
  text(peakX, peakY, pos = 4, 
       labels = paste0("x = ", peakX, "; y = ", format(peakY, big.mark = ",", scientific = F)), 
       col = "blue")
  dev.off()

  #plot frequencing counting (1 to 200) of kmers
  poisdtb = dpois(1:100, peakX)*singleC
  pdf(file = paste0(i, "mer.histo.fit.pdf"), width = 9, height = 4.5)
  plot(poisdtb, type = "l", lty = 2, col = "red",
  main = (paste0(i, "mer")),
  xlab = ("Frequency counting"),
  ylab = ("Number of kmers"))

  lines(kmer.hist.df[1:100, ], type = "l")
  points(kmer.hist.df[1:100, ], cex = 0.5)
  abline(v = peakX, col = "blue")
  text(peakX, peakY, pos = 4, 
       labels = paste0("x = ", peakX, "; y = ", format(peakY, big.mark = ",", scientific = F)), 
       col = "blue")
  dev.off()
}

colnames(sum.df) = c("Kmer_length", "Number_kmer", "Estimated_gSize", "Single_copy_region", "Percentage_single_copy")
write.table(sum.df, file = "summary_manual.txt", quote = F ,sep = "\t", col.names = T, row.names = F)
