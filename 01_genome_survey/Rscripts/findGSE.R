## 08/01/2010
## Zhipeng

library(findGSE)
files = list.files(path = "./", pattern = "mer.histo$")

for(k in 1:length(files)){
  i = gsub("mer.histo$", "", files[k])
  if(i >= 15){
    findGSE(histo = files[k], sizek = i, outdir = paste0("findGSE_", i, "mer"))
  }
}
