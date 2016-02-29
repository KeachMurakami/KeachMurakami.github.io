
library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)

ui <-
  shinyUI(
    pageWithSidebar(
      headerPanel(title="Scatter plot drawer"),
      sidebarPanel(
        fileInput("file", label="Input File:"),
        downloadLink('downloadData', 'Download')),
      mainPanel(
        h4("File Information:"),
        verbatimTextOutput("info"),
        h4("Figure"),
        plotOutput("plot")
      )
    ))

# server.R
server <-
  function(input, output) {
    output$info <- reactiveText(function(){
      file <- input$file
      if(is.null(file)) {
        "please upload file"
      } else {
        name <- paste("File Name: ", iconv(file$name, from="latin1", to="UTF-8"))
        size <- paste("File Size: ", file$size, "B")
        type <- paste("File Type: ", file$type)
        paste(name, size, type, sep="\n")
      }
    })
    output$plot <- reactivePlot(function() {
      file <- input$file
      if(is.null(file)) {
        "please upload file"
      } else {
        filepath <- file$datapath
        data <-
          read.csv(filepath) 
        data %>%
          melt(id.vars = colnames(data)[1]) %>%
          ggplot(aes_string(x = colnames(data)[1], y = "value", col = "variable")) +
          geom_line()
      }
    })
    output$downloadData <- downloadHandler(
      filename = function() {paste0(Sys.Date(), 'data.pdf')},
      content = function(file){
        pdf(file)
        csv_file <- input$file
        filepath <- csv_file$datapath
        data <-
          read.csv(filepath) 
        fig <-
          data %>%
          melt(id.vars = colnames(data)[1]) %>%
          ggplot(aes_string(x = colnames(data)[1], y = "value", col = "variable")) +
          geom_line()
          print(fig)
        dev.off()
      },
      contentType = "image/pdf"
    )
  }
