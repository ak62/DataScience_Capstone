TextProcessing <- function(inptext, bigrams, trigrams, quagrams) {
    # Requires stringr package
    
    # Cleaning input text data
    cleantext <- gsub(pattern = "[^[:alpha:][:space:]]*", "", inptext)
    cleantext <- gsub(pattern = "http[^[:space:]]*", "", cleantext)
    cleantext <- tolower(cleantext)
    cleantext <- gsub(pattern = "\\b(\\w+) \\1\\b" , "\\1", cleantext)
    cleantext <- str_squish(cleantext)
    split_words <- strsplit(cleantext, split = " ")
    split_words <- split_words[[1]]
    
    # Number of words in the input
    nwords <- length(split_words)
    
    npreds_by_quadgrams <- 0
    predictions_by_quagrams <- NA
    if(nwords>=3){
       last3words <- split_words[(nwords-2):nwords]
       predictions_by_quagrams <- subset(quagrams, (word1==last3words[1])&(word2==last3words[2])&(word3==last3words[3]))
       npreds_by_quadgrams <- nrow(predictions_by_quagrams)
       setnames(predictions_by_quagrams, "word4", "Pred")
       predictions_by_quagrams$Prob <- predictions_by_quagrams$n/sum(predictions_by_quagrams$n) 
       predictions_by_quagrams <- predictions_by_quagrams[,c("Pred", "n", "Prob")]
    }
    
    npreds_by_trigrams <-0
    predictions_by_trigrams <- NA
    if(nwords>=2){
        last2words <- split_words[(nwords-1):nwords]  
        predictions_by_trigrams <- subset(trigrams, (word1==last2words[1])&(word2==last2words[2]))
        npreds_by_trigrams <- nrow(predictions_by_trigrams)
        setnames(predictions_by_trigrams, "word3", "Pred")
        predictions_by_trigrams$Prob <- predictions_by_trigrams$n/sum(predictions_by_trigrams$n)
        predictions_by_trigrams <- predictions_by_trigrams[,c("Pred", "n", "Prob")]
    }
    
    npreds_by_bigrams <- 0
    predictions_by_bigrams <- NA
    if(nwords>=1){
        last1words <- split_words[nwords]
        predictions_by_bigrams <- subset(bigrams, word1==last1words[1])
        npreds_by_bigrams <- nrow(predictions_by_bigrams)
        setnames(predictions_by_bigrams, "word2", "Pred")
        predictions_by_bigrams$Prob <- predictions_by_bigrams$n/sum(predictions_by_bigrams$n)
        predictions_by_bigrams <- predictions_by_bigrams[,c("Pred", "n", "Prob")]
    }

    if((npreds_by_quadgrams == 0) & (npreds_by_trigrams == 0) & (npreds_by_bigrams == 0)){
        list(qPred = NA, triPred = NA, biPred = NA, npreds = c(0,0,0))
    } else {
        list(qPred = predictions_by_quagrams, triPred = predictions_by_trigrams, biPred = predictions_by_bigrams, npreds = c(npreds_by_quadgrams, npreds_by_trigrams, npreds_by_bigrams))
    }
  
}