library(ggplot2); library(grid)
library(dplyr) ;library(tidyr) #library(Hmisc); library(reshape2); 
library(shiny); 

babyNames<- readRDS('./data/babyNames.rds')
topNamesFM2K<- readRDS('./data/topNamesFM2K.rds')

#topNamesFM2K: unisex names from top 500 girl names + top 500 boy names from 2000 to 2014
# topNames<- c("Riley",  "Jackie", "Peyton", "Casey",  "Jessie", "Avery",  "Angel", "Leslie", 
#           "Marion", "Jordan", "Taylor", "Willie", "Jamie",  "Lynn", "Dana", "Lee", "Tracy",
#           "Terry", "Morgan", "Alexis", "Shannon", "Kelly",  "Robin" )

baby<- function (a, b) {
  byName<- filter(babyNames, name==a, year>=b)
  g1<- ggplot(byName, aes(x=year, y=count, fill=sex)) + 
    geom_bar(stat = "identity", width=.7) + #coord_flip() + 
    labs(title = paste('Number of Baby Name over Time - "', a, '"'), x = "Year", y = 'Number of Name') + 
    scale_fill_discrete("", labels=c("Female","Male"), guide = guide_legend(reverse=TRUE)) +
    scale_x_continuous(limits=c(b,2015), breaks=seq(b,2014,ceiling((2014-b)/18))) + 
    theme_bw() + 
    theme(title = element_text(size=16, face="bold"), axis.title=element_text(size=14, face="bold"), 
          panel.grid.major.x = element_line(colour="gray50", size=0.3, linetype="dotted"),
          panel.grid.major.y = element_blank(), legend.position='bottom') #, legend.position=c(0.05,0.9)
  
  byNameGender<- spread(byName, sex, count)
  if (sum(byName$sex=="M")==0) {
    byNameGender<- mutate(byNameGender, M=0)
  }
  byNameGender[is.na(byNameGender)]<- 0
  byNameGender<- mutate(byNameGender, Mperc=round(M/(F+M)*100,2))
  #mutate(byNameGender, total=F+M, Fperc=round(F/total*100,2), Mperc=round(M/total*100,2), unisexScore=round(Fperc*Mperc,0))
  g2<- ggplot(byNameGender, aes(x=year, y=Mperc)) + 
    geom_rect(data=NULL, aes(xmin=-Inf,xmax=Inf,ymin=0,ymax=50, fill="lightgreen"), alpha = 0.01)+
    geom_rect(data=NULL, aes(xmin=-Inf,xmax=Inf,ymin=50,ymax=100, fill="orange"), alpha = 0.01)+
    geom_line(colour='blue', size=1.5) +
    labs(title = paste('Name Gender Polarity over Time - "', a, '"'), x = "Year", y = "Gender Polarity") + 
    scale_y_continuous(limits=c(0,100), breaks=c(0, 50, 100), 
                       labels=c('100% Female', 'Unisex', '100% Male')) + 
    scale_x_continuous(limits=c(b,2015), breaks=seq(b,2014,ceiling((2014-b)/18))) +
    theme_bw() + 
    theme(title = element_text(size=16, face="bold"), axis.title=element_text(size=14, face="bold"), 
          panel.grid.major.x = element_line(colour="gray50", size=0.3, linetype="dotted"),
          panel.grid.major.y = element_line(colour="gray50", size=0.3, linetype="dotted"), legend.position='None') #panel.grid.major.y = element_blank(), legend.position=c(0.2,0.8)
  
  forPie<- as.data.frame(summarise(group_by(byName, sex), count=sum(count)))
  forPie$perc<- round(forPie$count/sum(forPie$count)*100,0)
  g3<- ggplot(forPie, aes(x=1, y=perc, fill=sex)) + 
    geom_bar(stat = "identity", width = 1, color='gray50') + 
    coord_polar(theta="y") + 
    labs(title = paste('Total Gender Polarity Year', b, 'to 2014\n"', a, '"'), x = '', y= '') +
    geom_text(aes(y=cumsum(forPie$perc)-forPie$perc/2, label=paste(forPie$sex, '=', forPie$perc, '%')), size=6) +
    theme_bw() + 
    theme(title = element_text(size=13, face="bold"), legend.position="none", axis.ticks=element_blank(), 
          axis.title=element_blank(), axis.text=element_blank())
  charts<- list(g1, g2, g3)
}

shinyServer(
  function(input, output, session) {
    output$table1<- renderTable({
      topNamesFM2K
    })
    observeEvent(input$goButton, {
      charts<- reactive({
        baby(input$nameInput, input$fromYr)
      })
      output$plot1<- renderPlot({
        charts()[[1]]
      })
      output$plot2<- renderPlot({
        charts()[[2]]
      })
      output$plot3<- renderPlot({
        charts()[[3]]
      })
    })
    
    observeEvent(input$showButton, {
      k<- input$showButton-floor(input$showButton/(nrow(topNamesFM2K)+0.5))*nrow(topNamesFM2K)
      n<-topNamesFM2K$name[k]
      charts<- reactive({
        baby(n, 1880)
      })
      output$plot1<- renderPlot({
        charts()[[1]]
      })
      output$plot2<- renderPlot({
        charts()[[2]]
      })
      output$plot3<- renderPlot({
        charts()[[3]]
      })
    })    
  }
)


