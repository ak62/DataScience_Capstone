library(shiny)
library(data.table)
library(ggplot2)
library(stringr)

shinyServer(function(input, output) {
    source("TextProcessing.R")
    load("bigrams.RData")
    load("trigrams.RData")
    load("quagrams.RData")
    bigrams <- as.data.frame(bigrams)
    trigrams <- as.data.frame(trigrams)
    quagrams <- as.data.frame(quagrams)

    Predictions <- reactive({
      if(nchar(input$InputText)!=0){
        processed_text <- TextProcessing(input$InputText, bigrams, trigrams, quagrams)
        if(sum(processed_text$npreds)==0){
          data.frame(Predictions = "Not able to predict", stringsAsFactors = FALSE)
        } else {
          tmp <- data.frame(Predictions = NULL, Source_ngrams = NULL, Prop = NULL, stringsAsFactors = FALSE)
          if(processed_text$npreds[1]!=0){
            Predictions_Quadgram <- data.frame(Predictions = processed_text$qPred$Pred, Source_ngrams = rep("Quadgram",processed_text$npreds[1]), Propbability = processed_text$qPred$Prob, stringsAsFactors = FALSE)
            tmp <- rbind.data.frame(tmp, Predictions_Quadgram)
          }  
          if(processed_text$npreds[2]!=0){
            Predictions_Trigram <- data.frame(Predictions = processed_text$triPred$Pred, Source_ngrams = rep("Trigram",processed_text$npreds[2]), Propbability = processed_text$triPred$Prob, stringsAsFactors = FALSE)
            tmp <- rbind.data.frame(tmp, Predictions_Trigram)
          }
          if(processed_text$npreds[3]!=0){
            Predictions_Bigram <- data.frame(Predictions = processed_text$biPred$Pred, Source_ngrams = rep("Bigram",processed_text$npreds[3]), Propbability = processed_text$biPred$Prob, stringsAsFactors = FALSE)
            tmp <- rbind.data.frame(tmp, Predictions_Bigram)
          }
          tmp
        }
        } else {
          data.frame(Predictions = "Input a text above", stringsAsFactors = FALSE)
          }
    })
    
  output$pred1 <- renderText({
    Predictions()[1, 1]
  })
  output$PredTable <- renderDataTable(Predictions())
})