---
title       : Introducing the Unisex Name App
subtitle    : A Look into the Gender Polarity of Names
author      : S. Wu
job         : Coursera Course Assignment
logo        : gender.png
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : solarized_light      # tomorrow...
url         : 
    assets  : ./assets
    lib     : ./libraries
widgets     : [bootstrap, quiz]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
--- 






## Why Unisex Names Matter

- A 2012 study of job applications suggested that applicants with identical qualifications are judged more harshly if their name is identifiably female ([Moss-Racusin et al., 2012][1]).  

- A similar study of college professors found that online teachers were given lower ratings if they used an identifiable female name ([Boring, Ottoboni, & Stark, 2016][2]). 

- [Fortune Magazine][3] has discussed the potential benefits of removing gender information from job applications.  Children with more unisex names may be better able to avoid such prejudgement. 

-  Further, as society becomes increasingly accepting of nonpolar gender roles and sexuality, parents may increasingly wish to give their newborn children unisex names. Such names allow the child more freedom in choosing their own gender identity.


[1]: http://www.pnas.org/content/109/41/16474.short
[2]: https://www.scienceopen.com/document/vid?id=0bc459de-6f8f-487f-b925-863834a74048
[3]: http://fortune.com/2014/10/07/race-gender-sexual-orientation-job-applications/

--- .class #id

## The Unisex Name App Functionality

- [The Unisex Name App][4] provides quick lookup the historical gender association of names.

  - One graphic shows the prevalence of the name over a span of time(1880 to 2014).  
  
  - Another shows the absolute gender-polarity of the name over time, male or female.  
  
  - The final graph shows the overall divide of the name between babies recorded as male and babies recorded as female.  
  
- The resultant data visualization shows some fascinating trends in gender distribution of names over time.

  - Check out the green **"Show Me A Unisex Name"** button, which will guide you through some of these.

- The "Table" tab shows a list of recent popular unisex names and their numbers.



[4]: https://blackszu.shinyapps.io/ioUnisexNameApp/


---.class #id

## Navigating the Unisex Name App

<img class=center src=./assets/img/ioAppGraph1.png height=300>

--- .class #id

## Resources


- The data (name, year of birth, sex and number) are from a 100 percent sample of Social Security card applications spanning 1880 to 2014. See [Social Security website][5] for more detail.

- The dataset was obtained from the [Data.gov][6] website and was downloaded in the form of comma-delimited text files(.txt) compressed in the zip(.zip) algorithm. Each text file contained data from one year.

- ui.R / server.R of this app and the raw data processing R code can be found on [here][7].


```r
# Year 2000 to 2014 Data
topNamesFM2K<- readRDS('./data/topNamesFM2K.rds')
names(topNamesFM2K)[c(4:6)]<-c('new.Babies', 'F.Rank', 'M.Rank'); head(topNamesFM2K,5)
```

```
##     name F.Percent M.Percent new.Babies F.Rank M.Rank
## 1  Logan        6%       94%     211003    395     21
## 2 Alexis       82%       18%     194772     12    166
## 3 Jordan       27%       73%     189520     98     42
## 4 Jayden       10%       90%     184872    266     31
## 5  Angel       20%       80%     162383    153     50
```



[5]: https://www.ssa.gov/oact/babynames/background.html
[6]: https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data
[7]: https://github.com/blackszu/DevDataProduct_Shiny






