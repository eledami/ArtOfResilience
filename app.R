library(shiny)
library(shinydashboard)
library(sf)
library(remotes)
library(leaflet)
library(rgdal)
library(rgeos)
library(RColorBrewer)
library(wesanderson)
library(htmlwidgets)
library(rmarkdown)
library(knitr)
library(DT)
library(tmaptools)
library(tidyverse)
library(ggmap)

# ui

header <- dashboardHeader(title = "Trauma informed Manchester - dashboard", titleWidth = 425, 
                          tags$li(a(href = 'http://www.manchester.gov.uk',
                                    img(src = 'company_logo.png',
                                        title = "Manchester City Council Home Page", height = "40px"),
                                        style = "padding-top:5px; padding-bottom:5px;"),
                                        class = "dropdown"))

sidebar <- dashboardSidebar(sidebarMenu(menuItem("Home", icon = icon("home", lib = "font-awesome"), tabName ="home", selected = TRUE),
                                        menuItem("Map", icon = icon("map-marked-alt", lib = "font-awesome"), tabName ="map"),
                                        menuItem("List", icon = icon("list-ul", lib = "font-awesome"), tabName ="list"),
                                        menuItem("Stories", icon = icon("seedling", lib = "font-awesome"), tabName = "stories"),
                                        menuItem("Charts", icon = icon("chart-bar", lib = "font-awesome"), tabName = "charts"),
                                        menuItem("BST neighbourhoods", icon = icon("city", lib = "font-awesome"), tabName = "neigh"),
                                        menuItem("Survey and Contacts", icon = icon("pen", lib = "font-awesome"), tabName = "contact_us"),
                                        menuItem("Developer, Data and Codes", icon = icon("copyright", lib = "font-awesome"), tabName = "copyright"),
                                        id = "dashboard"), width = 425)
                                        
body <- dashboardBody(
    tabItems(
        tabItem(tabName = "home", fluidPage(
                                       fluidRow(a(href = 'https://democracy.manchester.gov.uk/documents/s10614/ACE%20aware%20city.pdf', img(src ="policy.png", title = "Click here to read the strategy document", height = 340, width = 220)),  
                                       box(height = 345, width = 8, title = tags$strong("ACEs aware and trauma informed Manchester"), "A 12 month place based pilot was delivered in Harpurhey, North Manchester seeking to test whether development 
                                               of an ACE (Adverse Childhood Experience) aware, trauma informed workforce allows for engagement with service users/people with lived ACEs on a deeper level, leading to more effective interventions and 
                                               better outcomes for the individual, family and community. As a result of the project being received positively and starting to evidence impact, this approach 
                                               and way of working is being extended to other areas of the City. An agreed partnership funding model is in place with contributions from Manchester Health and Care 
                                               Commissioning (Population Health and Mental Health Commissioning), Manchester City Council (Adult Social Care and Children’s Services) and Manchester Local care Organisation. 
                                               This has been committed until April 2020 initially, with further funding to be secured dependant on continued positive evaluation. Our loner term plan is to work with all 13 
                                               neighbourhoods in Manchester over the coming years, funding permitting.", tags$strong("Click on the picture for reading the full strategy document."))),
                                       fluidRow(box(width = 12, title = tags$strong("Research and Dashboard"), 
                                            tags$h4(tags$em("Aim")), "This dashboard was created for", 
                                            tags$strong("presenting intelligence and evidence-based practice as well as assessing the impact of activity around 
                                               some key objectives of the expansion of the ACEs project across Manchester:"), 
                                            tags$br(),
                                            tags$ol(tags$li("All practitioners working in Manchester to be trauma informed and able to apply an ACE ‘lens’ to ensure their practice is informed by trauma"),
                                               tags$li("Support the workforce to implement trauma informed approaches into daily practice"), 
                                               tags$li("Implement and approved model of trauma informed supervision to support the health and wellbeing of the workforce working with people of all ages"), 
                                               tags$li("Maintain and grow a robust network of connections to ensure that Manchester use emerging research and practice to be at the cutting edge of trauma informed approaches")),
                                           tags$h4(tags$em("Methodology")),"The methodology used for gathering the data is inspired by a social research interdisciplinary mixed method approach giving particular attention on research ethics and reflexivity. In practice, the research was carried out by analysing existing data recorded during the project, local data publically available, GIS, a survey for the practionnaires and ethnographic case studies.
                                           The dashboard has been created with the softwares RStudio and Shiny and written with a mix of R, html and CSS code. R is the most innovative software for manipulating and presenting data in the world of research.  
                                           RStudio is a free and open resource promoting transparent, flexible, reproduciable, efficient, clean and automated research.", 
                                           tags$h4(tags$em("Structure")), "The data are presented in", 
                                           tags$strong("5 sections:"), 
                                           tags$br(), 
                                           tags$ol(tags$li(tags$code("Map:"),"This is a mapping tool realised for visualising various organisations using a trauma informed approach spacially in Manchester. 
                                                           Each organisation on the map has a label, pop-up displaying various information including organisation profiles and markers (colours depend on the organisation's sector). The purple borders show the territory of Manchester City Council divided along BST neighbourhoods. 
                                                           The aim is to show how a trauma imformed approach is spreading in the city due to staff training. In addition, the tool can be used by organisations to communicate, signpost and network."),
                                           tags$li(tags$code("List:"), "The list showes the organisations and relevant information in a table as alternative form of visualisation to the map. The 'Search' space at the top right corner helps to search organisation along key words (e.g. neighbourhood, names, postcodes)."), 
                                           tags$li(tags$code("Stories:"), "This section contains key qualitative findings in forms of narrative and case analysis showing practitioners voices, their achievements and expereinces around trauma informed training, practice, support and weelbeing. 
                                                                          This is a short cohesive analysis covering the whole city, organisation profiles hosted in the (WWW) containing more specific details and data related to each organisations."),  
                                           tags$li(tags$code("Charts:"), "This section contains key quantitative findings in form of charts showing numerical data in regards to trainings carried out in the city."), 
                                           tags$li(tags$code("BST neighbourhoods:"), "This is an analysis of neighbourhood specific data relevant to the topic of trauma and resiliance in the communities (e.g. health, deprivation, housing, standard of leaving, leisure activities). This data are fundamental to monitor the social context in which organisations operate and can inform practioners and their interventions."))
                                           )))),
        tabItem(tabName = "map", tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"), fluidPage(leafletOutput("map"))),
        tabItem(tabName = "list", fluidPage(DT::dataTableOutput('olist'))),
        
        tabItem(tabName = "stories", fluidPage(fluidRow(box(width = 6, title = "Trainings and Practice", 
                                                  tags$strong("Analysis:"), "The majority of staff members who participated to trainings feel like they learned how to understand emotions better and now are keen to apply a trauma informed approach in practice.", tags$br(), tags$br(), 
                                                  tags$strong("Evidence:"),"'The training gave staff an understanding of the complex emotions that many of our tenants are dealing with on a daily basis. We are now aware that the people we work with were exposed to adverse and stressful 
                                                  experiences as children, leaving them with a long term lasting inability on their ability to think, interact with others and learn.'", 
                                                  tags$em("- Claire Tyrell, Head of Neighbourhood Services - Wilton, Northwards Housing"), 
                                                  status="warning"), 
                                              box(width = 6, title = "Staff support and Weelbeing", 
                                                  tags$strong("Analysis:"), "Majority of staff felt supported through the process of implementing an ACEs aware approach and trauma informed practice.", tags$br(), tags$br(), 
                                                  tags$strong("Evidence:"),"'Our staff went trhough some weelbeing and mental health challenges...but this event/this type of support/the trainer helped them to overcome this challenges'",
                                                  tags$em("- Mr. Smith, Head of XX School - "),
                                                  status="info")), 
                                     fluidRow(box(width = 6, title = "Output and Impact", 
                                                  "Trainings as well as the work carried out by organisations in Manchester produced various positive outputs:", tags$br(), tags$br(), 
                                                  tags$strong("The most common are:"), tags$br(),
                                                  tags$ol(tags$li("Tailored intervention packages"), 
                                                          tags$li("Use of creative methods"), 
                                                          tags$li("Award winning frameworks"), 
                                                          tags$li("Sharing positive stories with partners"), 
                                                          tags$li("Improving the office environment of the services")), 
                                                  status= "danger"),
                                         box(width = 6, title = "Case analysis", 
                                                  tags$strong("Analysis:"), "Many residents who expereinced ACEs are supported in building resiliance by the work of different organisations in Manchester. Joe's journey is an example.", tags$br(), tags$br(), 
                                                  tags$strong("Resident story:"), "Joe is a young person with amazing resilience. 
                                                              He has experienced 9/10 of the original ACES on multiple occasions, which don't include his experience of a street homeless parent, 
                                                              being a trafficked child exposed to serious violence, being a looked after child. He is now 16 years old. 
                                                              In November 2019, Joe appeared in Court charged with a firearms offence, and aggravated burglary (having been coerced into participating by adults). 
                                                              Whilst not taking part, he was present, and therefore ‘involved’. The Judge discussed the gravity of the offence having a sentence of 3 years. 
                                                              However, having been made aware (by Manchester Youth Justice) of the trauma and neglect Joe had experienced, 
                                                              the Judge then stated", tags$em("A child should never have to experience the life you have"), "and gave him a community sentence. 
                                                              The Judge said that he owed this decision to the YJ Officer, Senior Social Worker, Drama Therapy Practitioner and Joe’s care home for believing in him. 
                                                              He praised the multi-agency, specialist approach to understanding exploitation and building on strengths and giving Joe a chance to succeed. 
                                                              Joe is now in full time employment. This outcome shows the significant shift in terms of the Court’s understanding of the reasons for young people’s presenting behaviours.", 
                                                  status= "success") 
                                              ))), 
        tabItem(tabName = "charts", "Relevant quantitative data based on the objectives of the project covering Manchester"),
        tabItem(tabName = "neigh", tags$h4("Analysis at BST neighbourhood level"), "for a more specific neighbourhood analysis please look at the Neighbourhood Intelligence dashbaord", 
                                   tags$h4("Analysis of neighbourhood specific data", "building resiliance in the communities (health, deprivation, housing, standard of leaving, leisure activties)")),
        tabItem(tabName = "contact_us", 
                fluidPage(fluidRow(box(width = 12, title = "Research, data and dashboard", tags$strong("Elena Damiano"), tags$br(), "elena.damiano@manchester.gov.uk", tags$br(), "Performance, Research and Intelligence Directorate", tags$br(), "Manchester City Council", background = "green")),
                                   fluidRow(box(width = 12, title = "Survey", "Please fill this survey if your organisation is based in Manchester and use a trauma informed or ACEs aware approach. >>>", 
                                       tags$a(href = "www.google.com", "Call for organsiations using an ACEs aware and trauma informed approach in Manchester"),
                                       "<<< We can support you and connect you to others and you will help us support the project with evidence.", background = "yellow")),
                          fluidRow(box(width = 12, title = "Project Management, implementation and trainings", tags$strong("Gareth Nixon"), tags$br(), "gareth.nixon@manchester.gov.uk", tags$br(), "Public Health Directorate", tags$br(), "Manchester City Council", background = "blue")), 
                          )),
        tabItem(tabName = "copyright", 
                fluidPage(fluidRow(box(width = 12, title = "Developer", "", tags$a(href = "https://www.linkedin.com/in/elena-damiano-a168b51b7/", "Elena Damiano"), 
                "I work at the Performance, Research and Intelligence Directorate at Manchester City Council. Something about me and my role, something about PRI, something about dashboard. Aknowledgements.")), 
                          fluidRow(box(width = 12, title = "Data", "Data sources")), 
                          fluidRow(box(width= 12, title = "Code", "Github or other websites references")))
                )))

ui <- dashboardPage(skin = "purple", header, sidebar, body) 

# server 

server <- function(input, output) {
    
    # import data
    Data_survey <- read.csv("organisation_survey_raw.csv")
    Data_hyperlinks <- read.csv("organisation_profiles_hyperlinks.csv")
    vlookups <- read.csv("BST_vlookups.csv")
    
    # add hyperlinks and BST N. 
    Data_survey_HTML <- mutate(Data_survey, Website = paste0("<a href='https://", Data_survey$Website,"/'>click here</a>"))
    Data_hyperlinks_HTML <- mutate(Data_hyperlinks, Profile = paste0("<a href='https://", Data_hyperlinks$Profile,"/'>find out more data here</a>"))
    cleaning_data_hyper <- merge(Data_survey_HTML,  Data_hyperlinks_HTML, by = "Name")
    cleaning_data_BST <- merge(cleaning_data_hyper, vlookups, by = "Ward")
    
    # Geocoding
    addresses_tmaptools <- geocode_OSM(cleaning_data_BST$Postcode, as.data.frame = TRUE)
    addresses_tmaptools_cleaned <- select(addresses_tmaptools, query, lat, lon)
    data_cleanse_final_m <- merge(cleaning_data_BST, addresses_tmaptools_cleaned, by.x = "Postcode", by.y = "query")
    data_cleanse_final_l <- select(data_cleanse_final_m, Name, Headline, BST_Neighbourhood, Sector, Profile, Website)
    
    # Import data
    organisation_data <- data_cleanse_final_m
    organisation_data$lon <- as.numeric(organisation_data$lon)
    organisation_data$lat <- as.numeric(organisation_data$lat)
    
    manchester_shapefiles <- readOGR(dsn = ".", layer = "BST_13_NHOODS")
    manchester_shapefiles <- spTransform(manchester_shapefiles, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
    
    # Icons
    icons_colors <- icons(iconUrl = ifelse(organisation_data$Sector == "Health", "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png", 
                                           ifelse(organisation_data$Sector == "VCSE", "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png", 
                                                  ifelse(organisation_data$Sector == "Education", "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-green.png",
                                                         ifelse(organisation_data$Sector == "Housing", "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-orange.png",   
                                                                ifelse(organisation_data$Sector != "Health" || "VCSE" || "Education" || "Council", "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-gold.png",
                                                                       ifelse(organisation_data$Sector == "Council", "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-violet.png", "0")))))), 
                          iconWidth = 23*215/230, iconHeight = 31, 
                          iconAnchorX=23*215/230/2, iconAnchorY = 16)
    
    # Map
    m_manchester <- leaflet() %>% 
        addTiles()  %>% 
        setView(lng = -2.2440502, lat = 53.442865, zoom = 11) %>% 
        addProviderTiles(providers$CartoDB.Voyager)  %>%
        addMarkers(data = organisation_data, lng = ~lon, lat = ~lat, label = ~Name, icon = icons_colors, popup = 
                       ~paste("<h3 style ='color: DarkSlateBlue'> Organisation profile </h3>", 
                              "<b> Name: </b>", Name, "<br>",
                              "<br>", "<b>Headline: </b>", Headline, "<br>",
                              "<br>", "<b>Profile (narratives, case study and impact): </b>", Profile, "<br>",
                              "<br>", "<b>Contact details</b>", "<br>", 
                              Road, "<br>", BST_Neighbourhood, "<br>", Postcode, "<br>", Email, "<br>", "<br>", 
                              "<b>Website: </b>", Website, "<br>", "<br>",
                              sep =" ")) %>% 
        addPolygons(data = manchester_shapefiles, weight=1, col= 'blueviolet', smoothFactor = 1, opacity = 1,  fillOpacity = 0.1) %>% 
        addLegend(position = "bottomright",
                  colors = brewer.pal(n = 6, name = "Set1"),
                  labels = c("VCSE", "Health", "Education", "Council", "Housing", "Other"), opacity = 0.7,
                  title = "Sector")
    
    output$map <- renderLeaflet(m_manchester)
    output$olist <- DT::renderDataTable(data_cleanse_final_l, escape =3)
}

# Run the application 
shinyApp(ui = ui, server = server)
