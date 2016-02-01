library(ggplot2); library(grid)
library(dplyr) ;library(tidyr) #library(Hmisc); library(reshape2); 
library(shiny);

babyNames<- readRDS('./data/babyNames.rds')

shinyUI(fluidPage(
  titlePanel("The Unisex Name App"),
  fluidRow(
    column(4,
           h5(em(span('(This site works best on Google Chrome. It may experience problems on other browsers. Please wait untill the site is fully downloaded. Thank you for your patience.)',
                      style = "color:red")))
           ),
    column(8,
           h5(strong(span('Graph', style = "color:blue"), 'tab: graphic output.',
                     span('Table', style = "color:blue"), 'tab: a list of popular unisex names.',
                     span('Introduction', style = "color:blue"), 'tab: user instruction.'))
           )
  ),
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        helpText('Type / select a name and set the "from year" by dragging the slider bar, Click "Go" button.'),
        selectInput('nameInput', 'Name : ', as.character(unique(babyNames$name))),
        br(),
        sliderInput('fromYr', label='From Year :', 1880, 2014, 1880, step=1, sep=''),
        actionButton('goButton','Go', class="btn-primary")
      ),
      wellPanel(
        helpText('Or, press the "Show Me A Unisex Name" botton. A different name will be demonstrated with each button press.'),
        actionButton("showButton", "Show Me A Unisex Name", class="btn-success")
      ),
      
      wellPanel(
        plotOutput('plot3')
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('Graph',
                 em(a('Source: Data.gov - Baby Names from Social Security Card Applications-National Level Data', 
                   href='https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data')),
                 br(),
                 plotOutput('plot1'),
                 br(),
                 plotOutput('plot2')
        ),
        tabPanel('Table',
                 h3('Popular Unisex Names from Year 2000 to Year 2014'),
                 br(),
                 tableOutput('table1')
        ),
        tabPanel('Introduction',
                 h4('As society becomes increasingly accepting of nonpolar gender roles and 
                    sexuality, parents may increasingly wish to give their newborn children 
                    unisex names. Such names allow the child more freedom in choosing their 
                    own gender identity. 
                    Further, there have been studies[1][2] and discussions[3][4] regarding 
                    how children with more unisex names may be better able to avoid prejudgement 
                    on job applications and performance evaluation.'),
                 p('Link:', a('[1]', href='http://www.pnas.org/content/109/41/16474.short'), 
                   a('[2]', href='https://www.scienceopen.com/document/vid?id=0bc459de-6f8f-487f-b925-863834a74048'),
                   a('[3]', href='http://fortune.com/2014/10/07/race-gender-sexual-orientation-job-applications/'),
                   a('[4]', href='http://www.npr.org/sections/ed/2016/01/25/463846130/why-women-professors-get-lower-ratings')),
                 br(),
                 h4('This app provides quick lookup the historical gender association of names :'),
                 h5('- Type or select a name from the drop down list. 
                    Drag the slider bar to set the "from Year". Then press blue "Go" button.'),
                 h5('- Alternatively, press the green "Show Me A Unisex Name" button to see demonstrations 
                    of popular unisex names. A different name will be displayed with each button press.'),
                 h5('- The "Graph" tab shows graphic output. 
                    The "Table" tab shows a list of popular unisex names. 
                    And the "Introduction" tab provides user instruction.'),
                 br(),
                 h4('Data is obtained from', 
                    em(a('data.gov', href='https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-level-data')),
                    'The data (name, year of birth, sex and number) are from a 100 percent sample of Social Security card 
                    applications spanning 1880 to 2014.',
                    a('Social Security website', href='https://www.ssa.gov/oact/babynames/background.html'),
                    'also provides some interesting graphs looking at name popularity over time by US state.'),
                 br(),
                 p(''),
                 h4('The codes(ui.R and server.R) of this app can be found on',a('here.', href='https://github.com/blackszu/ShinyAppUnisexName')),
                 h4('For more information, please see the',a('introduction slides.', href='https://blackszu.github.io/ShinyAppUnisexName'))
        )

      )
    )
  )
))

