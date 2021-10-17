# ArtOfResilience
Analysis Art of Resilience Evaluation

# data
c_feedback <- read.csv("c_feedbacks.csv")
View(c_feedback)

# packages
library(ggplot2)
library(ggplot)
library(viridis)
library(ggthemes)
library(showtext)
library(tidyverse)
library(hrbrthemes)
library(grid)

# heatmap
ggp_2 <-ggplot(c_feedback, aes(x=week, y=name, fill=enjoyment_l)) + 
        geom_tile(color="white", size=0.4) +
        geom_text(aes(label=enjoyment_l), size=5, color="white") +
        scale_fill_viridis_b(name="Enjoyment level", option = "D") +
        coord_equal() +
        labs(x = "Sessions", y = "Pupils", 
        title = "Pupils' levels of enjoyment along the 6 workshop sessions", 
        caption = "Feedback: elena.damiano@manchester.gov.uk (Performance, Research and Intelligence, Manchester City Council)") +
        theme_tufte(base_family = "Calibri Light") +
        theme(plot.title = element_text(hjust=0.5, size=23, face="bold.italic")) + 
        theme(legend.title = element_text(size=15, face="bold.italic")) + 
        theme(axis.title.x = element_text(size=15, face="bold")) + 
        theme(axis.title.y = element_text(size=15, face="bold")) + 
        theme(plot.caption = element_text(size=10, colour = "chocolate4", hjust = 1))
        

ggp_2

# Statistics

summary(c_feedback$enjoyment_l)

# histogram

hist <- c_feedback %>%
       ggplot(aes(x=enjoyment_l)) +
       geom_histogram(binwidth=1, fill="royalblue3", color="#e9ecef", alpha=0.9) + 
        labs(x = "Enjoyment levels", y = "Counts", 
             title = "Frequency of different enjoyment levels", 
             caption = "Feedback: elena.damiano@manchester.gov.uk (Performance, Research and Intelligence, Manchester City Council)") +
        theme_tufte(base_family = "Calibri Light") +
        theme(plot.title = element_text(hjust=0.5, size=23, face="bold.italic")) + 
        theme(legend.title = element_text(size=15, face="bold.italic")) + 
        theme(axis.title.x = element_text(size=15, face="bold")) + 
        theme(axis.title.y = element_text(size=15, face="bold")) + 
        theme(plot.caption = element_text(size=10, colour = "chocolate4", hjust = 1)) +
        annotate(geom="text", x=8.4, y=10, label="mean = 7.778",
                 color="red4") + 
        annotate(geom="text", x=8.6, y=8, label="median = 8",
                 color="orange4") + 
        geom_vline(aes(xintercept=mean(enjoyment_l)),
                   color="red4", linetype="dashed", size=1)
     
hist

# WordCloud

library(wordcloud2)
library(tm)
library(extrafont)

# create corpus
medium.corpus <- Corpus(VectorSource(c_feedback$feelings_d))

# text cleaning 

medium.corpus <- medium.corpus %>% 
        tm_map(removeNumbers) %>%
        tm_map(removePunctuation) %>% 
        tm_map(stripWhitespace) %>%
        tm_map(content_transformer(tolower)) %>%
        tm_map(removeWords, stopwords("english")) %>%
        tm_map(removeWords, stopwords("SMART"))

tdm <- TermDocumentMatrix(medium.corpus) %>%
as.matrix()
words <- sort(rowSums(tdm), decreasing = TRUE)
df <- data.frame(word <- names(words), freq = words)

uxc.colors <- c("#E69F00", "#56B4E9", "#009E73",
                "#F0E442", "#0072B2", "#999999", "#D55E00", "#CC79A7")

wordcloud2(df, color = uxc.colors,
           rotateRatio = 0, fontFamily = "SimSun")
