library(shiny)
shinyUI(fluidPage(
    titlePanel("Text Prediction Application"),
    sidebarLayout(
        sidebarPanel(
            h4("App description:"),
            p("This application is designed to predict the next word based on the input text by the user. The application takes advatage of a set of data previously processed using corpus n-gram analysis."), 
            h4("Output Description:"),
            p("The application provides the two following outputs:"),
            p(strong(span("1. Text predictions:", style="color:blue")),"In this section, the most likey next word is presented."),
            p(strong(span("2. Further Analytics:", style="color:blue")),"In this section, a searchable table with all possible outcomes, their ngram source of prediction, and the probability of the words (within that ngram) is presented."),
            h4("Note:"),
            h6("Please allow", strong(span("5-15 seconds", style="color:red")), "for the app to load the supporting datasets!"),
            h3("Aman Karamlou, Oct 2019")
        ),
        mainPanel(
            h3("Text prediction panel"),
            textInput("InputText", "Input the text in the box bellow", value = ""),
            h3("Text predictions:"),
            textOutput("pred1"),
            h3("Further Analytics:"),
            dataTableOutput("PredTable")
        )
    )
))