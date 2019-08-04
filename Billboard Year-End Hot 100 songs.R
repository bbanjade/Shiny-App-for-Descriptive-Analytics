# Install Packages if not present
if(!require("shiny")) install.packages("shiny")
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("dplyr")) install.packages("dplyr")
if(!require("forcats")) install.packages("forcats")
if(!require("tm")) install.packages("tm")
if(!require("wordcloud")) install.packages("wordcloud")



# loading Libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(forcats)
library(tm)
library(wordcloud)

data <- read.csv("billboard_lyrics_1964-2015.csv", stringsAsFactors = FALSE)
 

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Q1. Number of hit per rank",
             sidebarLayout(
               sidebarPanel(
                 selectInput("rankinput", "Rank", 
                             choices = c(1:100))
               ),
               mainPanel(h1("bar chart showing the number of hits per rank"), 
                         plotOutput("coolplot", height = "1000px", width = "60%")
               )
             )
    ),
    tabPanel("Q2&3. lyrics-songs titile chart",
             sidebarLayout(
               sidebarPanel(
                 sliderInput("yearinput", "Year", 1965, 2015, c(1970, 19780))
               ),
               mainPanel(h1("histogram of top 70 most frequent words in lyrics according to changes in year"),
                         plotOutput("lyrics"),
                         h1("histogram of top 70 most frequent words in song titles according to changes in year"),
                         plotOutput("song")
               )
             )
    ),
    tabPanel("Q4. wordclouds of song title and lyrics",
             sidebarLayout(
               sidebarPanel(
                 
               ),
               mainPanel(h1("wordclouds of top 500 words in song titles during 1965-2015"),
                         plotOutput("songwords"),
                         h1("wordlclouds of top 500 words in lyric during 1965-2015"),
                         plotOutput("lyricswords")
               )
             )
    )
  )
)


server <- function(input, output) {
  output$coolplot <- renderPlot({
    filtered1 <- 
      data %>% 
      filter(Rank == input$rankinput)
    filtered1$Artist <- fct_infreq(filtered1$Artist)
    ggplot(filtered1, aes(Artist, fill = "red")) + geom_bar(stat="count") + coord_flip() + theme(legend.position = "none")
    
  })
  
 output$lyrics <- renderPlot({
    filtered2 <-
      data %>% filter(Year == input$yearinput)
    
    
    docs <- Corpus(VectorSource(filtered2$Lyrics))
    toSpace <- content_transformer(function (x, pattern) gsub(pattern, " ", x))
    docs <- tm_map(docs, content_transformer(tolower))
    docs <- tm_map(docs, removeWords, stopwords("english"))
    docs <- tm_map(docs, stripWhitespace)
    docs <- tm_map(docs, stemDocument)
    ### Build a term-document matrix
    dtm <- TermDocumentMatrix(docs)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m), decreasing=TRUE)
    d <- data.frame(word = names(v), freq=v)
    #The frequency of the first 100 frequent words are plotted:
    barplot(d[1:70,]$freq, las = 2, names.arg = d[1:70,]$word,
            col = "lightblue", main = "Most frequent words in Lyrics",
            ylab = "Word frequencies")
    
  })
  
  output$song <- renderPlot({
    filtered3 <-
      data %>% filter(Year == input$yearinput)
    
    docs1 <- Corpus(VectorSource(filtered3$Song))
    toSpace <- content_transformer(function (x, pattern) gsub(pattern, " ", x))
    docs1 <- tm_map(docs1, content_transformer(tolower))
    docs1 <- tm_map(docs1, removeWords, stopwords("english"))
    docs1 <- tm_map(docs1, stripWhitespace)
    docs1 <- tm_map(docs1, stemDocument)
    ### Build a term-document matrix
    dtm1 <- TermDocumentMatrix(docs1)
    m1 <- as.matrix(dtm1)
    v1 <- sort(rowSums(m1), decreasing=TRUE)
    d1 <- data.frame(word = names(v1), freq=v1)
    #The frequency of the first 70 frequent words are plotted:
    barplot(d1[1:70,]$freq, las = 2, names.arg = d1[1:70,]$word,
            col = "lightblue", main = "Most frequent words in song Title",
            ylab = "Word frequencies")
    
  })
  output$lyricswords <- renderPlot({
    docs <- Corpus(VectorSource(data$Lyrics))
    toSpace <- content_transformer(function (x, pattern) gsub(pattern, " ", x))
    docs <- tm_map(docs, content_transformer(tolower))
    docs <- tm_map(docs, removeWords, stopwords("english"))
    docs <- tm_map(docs, stripWhitespace)
    docs <- tm_map(docs, stemDocument)
    ### Build a term-document matrix
    dtm <- TermDocumentMatrix(docs)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m), decreasing=TRUE)
    d <- data.frame(word = names(v), freq=v)
    ### Generate the word cloud
    set.seed(1234)
    wordcloud(words = d$word, freq = d$freq, min.freq = 1,
              max.words = 500, random.order = FALSE, rot.per = 0.35,
              colors = brewer.pal(8, "Dark2"))
  })
  
  output$songwords <- renderPlot({
    docs <- Corpus(VectorSource(data$Song))
    toSpace <- content_transformer(function (x, pattern) gsub(pattern, " ", x))
    docs <- tm_map(docs, content_transformer(tolower))
    docs <- tm_map(docs, removeWords, stopwords("english"))
    docs <- tm_map(docs, stripWhitespace)
    docs <- tm_map(docs, stemDocument)
    ### Build a term-document matrix
    dtm <- TermDocumentMatrix(docs)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m), decreasing=TRUE)
    d <- data.frame(word = names(v), freq=v)
    ### Generate the word cloud
    set.seed(1234)
    wordcloud(words = d$word, freq = d$freq, min.freq = 1,
              max.words = 500, random.order = FALSE, rot.per = 0.35,
              colors = brewer.pal(8, "Dark2"))
  })
}

shinyApp(ui = ui, server = server)
