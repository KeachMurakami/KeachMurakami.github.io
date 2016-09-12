
library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "ChamVol_cm3",
                label = "The volume of the chamber [cm3]",
                value = 56.4),
      textInput(inputId = "TimeMax_s",
                label = "The time course range shown [s]",
                value = 120),
      textInput(inputId = "FlowMin",
                label = "Minimum value of air flow rates [µmol s-1]",
                value = 300),
      textInput(inputId = "FlowMax",
                label = "Maximum value of air flow rates [µmol s-1]",
                value = 700),
      sliderInput(inputId = "FlowLevel", label = "levels of air flow rates",
                  min = 1, max = 10, value = 3),
      sliderInput(inputId = "NetPhotosynthesis", label = "Net photosynthetic rate [µmol m-2 s-1]",
                  min = -5, max = 20, value = 3)
    ),
    mainPanel(
      textOutput("test"),
      plotOutput("Decay")
    )
  )
))

server <- shinyServer(function(input, output) {
  
  output$test <- renderPrint(
    seq(as.numeric(input$FlowMin), as.numeric(input$FlowMax), length.out = as.numeric(input$FlowLevel))
    )
  output$Decay <- renderPlot({
    ChamberVolume <-
      as.numeric(input$ChamVol_cm3) / 1000 / 22.4
    TimeRangeMax <-
      input$TimeMax_s %>% as.numeric
    FlowRates <-
      seq(as.numeric(input$FlowMin), as.numeric(input$FlowMax), length.out = as.numeric(input$FlowLevel))
    Delta_conc <-
      input$NetPhotosynthesis * 6 * 10^(-4)
    
    Data_conc <-
      lapply(FlowRates, function(flow){
        data_frame(
          Time = seq(0, TimeRangeMax, TimeRangeMax / 50),
          Conc = Delta_conc * (exp(- (flow / ChamberVolume) * Time) - 1) * 10^6/ flow # ガス濃度 [µmol mol-1] を計算
        ) %>%
          mutate(Flow = paste0("FlowRate: ", sprintf(fmt = "%.0f", flow)))
      }) %>%
      rbind_all
    
    Min_concs <-
      Data_conc %>%
      group_by(Flow) %>%
      summarise(Conc = min(Conc))
    
    Label_conc <-
      data_frame(Time = TimeRangeMax,
                 Conc = Min_concs$Conc,
                 Flow = paste0("FlowRate: ", sprintf(fmt = "%.0f", FlowRates))
      )
    
    Fig_conc <-
      Data_conc %>%
      ggplot(aes(x = Time, y = Conc, group = Flow, col = Flow)) +
      geom_line() +
      xlab(paste0("Time [s]", FlowRates[2])) +
      ylab("dif. in gas conc. [µmol mol-1]") +
      xlim(c(0, TimeRangeMax * 1.2)) +
      geom_text(data = Label_conc, x = TimeRangeMax * 1.1, aes(y = Conc, label = Flow, group = Flow)) +
      guides(col = F)
      
    
    return(Fig_conc)
  })
})

# Run the application 
shinyApp(ui = ui, server = server)

