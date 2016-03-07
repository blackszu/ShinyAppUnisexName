# Data processing for Social Security's "babynames" dataset from Data.gov
#Author: S. Wu

# Check and load required R packages
pkg<-c("knitr", "ggplot2", "grid", "dplyr", "tidyr", "shiny", "slidify", "rCharts", "googleVis")
pkgCheck<-pkg %in% rownames(installed.packages())
for(i in 1:length(pkg)) {
  if(pkgCheck[i]==FALSE) {
    install.packages(pkg[i])
  } 
  library(pkg[i],character.only = TRUE)
}

# Download data
url<- "https://www.ssa.gov/oact/babynames/names.zip"
zip<- "names.zip"
if (!file.exists(zip)) { download.file(url,destfile=zip) }
unzip(zip)
yr<- c(1880:2014)

babyNames<- data.frame()
for (i in 1:length(yr)) {
  fid<- paste0('yob',yr[i],'.txt')
  fTemp<- read.table(fid, header=FALSE, sep=",") #, colClasses=c("character", "factor", "integer")
  fTemp$year<- yr[i]
  babyNames<- rbind(babyNames, fTemp)
}
names(babyNames)[1:3]<- c("name", "sex", "count")


# spread data to separate F/M numbers
## Unisex score = F percent * M percent (ex. for 95% F and 5% M, score=475, for 50%F and 50%M, score=2500)
### The higher the unisex score, the higher "unisex-ness" the name is

byGenderYear<- spread(babyNames, sex, count)
byGenderYear[is.na(byGenderYear)]<- 0
byGenderYear<- mutate(byGenderYear, name=as.character(name), total=F+M, Fperc=round(F/total*100,2),
                      Mperc=round(M/total*100,2), unisexScore=round(Fperc*Mperc,0))

#-----------------------------------------------------------

## All data
# Summarize data across years
byGenderSum<- byGenderYear %>%
  group_by(name) %>%
  summarize(F=sum(F), M=sum(M)) %>%
  mutate(total= F+M, unisexScore=round(((F*M)/total^2)*10000,2),
         main= colnames(byGenderYear)[ifelse(F>M,3,4)])
byGenderSum<- as.data.frame(byGenderSum)

#-----------------------------------------------------------

## 2000-2014 Data
# Summarize data across years
byGenderSum2K<- byGenderYear %>%
  filter(year>=2000) %>%
  group_by(name) %>%
  summarize(F=sum(F), M=sum(M)) %>%
  mutate(total= F+M, unisexScore=round(((F*M)/total^2)*10000,2),
         main= colnames(byGenderYear)[ifelse(F>M,3,4)])
byGenderSum2K<- as.data.frame(byGenderSum2K)

# top 500 female / top 5000 male
topNamesF2K<-head(byGenderSum2K[order(byGenderSum2K$F, decreasing = TRUE),],500)
topNamesM2K<-head(byGenderSum2K[order(byGenderSum2K$M, decreasing = TRUE),],500)

  # unisex names from top 500
  namesIntersect2K<- intersect(topNamesF2K$name, topNamesM2K$name)
  topNamesFM2K<- arrange(byGenderSum2K[byGenderSum2K$name %in% namesIntersect2K,], desc(total))
  # topNamesFM2K<- mutate(topNamesFM2K, F.Percent=paste0(round(F/total*100,0),'%'),
  # M.Percent=paste0(round(M/total*100,0),'%'),New.Babies.2000to2014=total)
  topNamesFM2K<- mutate(topNamesFM2K, fperc=round(F/total*100,0), mPerc=round(M/total*100,0))
  # topNamesFM2K<- select(topNamesFM2K, name, F.Percent, M.Percent, New.Babies.2000to2014)
  for (i in 1:nrow(topNamesFM2K)) {
    topNamesFM2K$fRank[i]<- which(topNamesF2K$name==topNamesFM2K$name[i])
    topNamesFM2K$mRank[i]<- which(topNamesM2K$name==topNamesFM2K$name[i])
  }
  
  ## top 10 by unisex-ness
  top10Name<- head(arrange(
    byGenderSum2K[byGenderSum2K$name %in% namesIntersect2K,], desc(unisexScore))$name,10)
  babyNamesUnisex10<- babyNames[babyNames$name %in% top10Name,]
  byGenderYearUnisex10<- byGenderYear[byGenderYear$name %in% top10Name,]
  
    ## top 5 by unisex-ness
  top5Name<- head(arrange(
    byGenderSum2K[byGenderSum2K$name %in% namesIntersect2K,], desc(unisexScore))$name,5)
  babyNamesUnisex5<- babyNames[babyNames$name %in% top5Name,]
  byGenderYearUnisex5<- byGenderYear[byGenderYear$name %in% top5Name,]
    
    ## for app
  topNamesFM2K<- arrange(byGenderSum2K[byGenderSum2K$name %in% namesIntersect,], desc(total))
  topNamesFM2K<- mutate(topNamesFM2K, F.Percent=paste0(round(F/total*100,0),'%'), M.Percent=paste0(round(M/total*100,0),'%'),New.Babies.2000to2014=total)
  topNamesFM2K<- select(topNamesFM2K, name, F.Percent, M.Percent, New.Babies.2000to2014)
  for (i in 1:nrow(topNamesFM2K)) {
    topNamesFM2K$Rank.in.Girls.Name[i]<- which(topNamesF2K$name==topNamesFM2K$name[i])
    topNamesFM2K$Rank.in.Boys.Name[i]<- which(topNamesM2K$name==topNamesFM2K$name[i])
  }


# Save R data
saveRDS(babyNames, './data/babyNames.rds')
saveRDS(byGenderYear, './data/byGenderYear.rds')
saveRDS(byGenderSum, './data/byGenderSum.rds')
saveRDS(byGenderSum2K, './data/byGenderSum2K.rds')
saveRDS(byGenderYearUnisex10, './data/byGenderYearUnisex10.rds')
saveRDS(byGenderYearUnisex5, './data/byGenderYearUnisex5.rds')
