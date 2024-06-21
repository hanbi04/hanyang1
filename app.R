library(shiny)
library(palmerpenguins)
library(ggplot2)
library(dplyr)
library(DT)
ui = fluidPage(
  
  titlePanel("펭귄 데이터 분석"),
  sidebarLayout(
    
    sidebarPanel(
      checkboxGroupInput("species", label = '펭귄 종류를 선택하세요',
                         choices = list("Adelie", "Gentoo", "Chinstrap"),
                         selected ="Adelie" ),
      selectInput("x_axis",
                  label = "x축을 선택하세요.",
                  choices = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                  selected = "bill_length_mm"),
      selectInput("y_axis",
                  label = "y축을 선택하세요.",
                  choices = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                  selected = "body_mass_g"),
      sliderInput("point_size",
                  label = "점크기를 선택하세요",
                  min = 1, max = 10, value = 5)),
    mainPanel(
      DTOutput('penguins_table'),
      plotOutput('penguins_plot')
    )
  )
)

server = function(input, output, session) {
  
  filtered_data=reactive({
    penguins %>%
      filter(species %in% input$species)
  })
  
  
  output$penguins_table = renderDT({
    filtered_data()
  })
  
  
  output$penguins_plot = renderPlot({
    ggplot(filtered_data(), aes_string(x = input$x_axis, y = input$y_axis,color = "species", shape = "sex")) +
      geom_point(aes(size = input$point_size)) +
      scale_size_continuous(range = c(1, input$point_size),guide="none")+
      labs(
        x = input$x_axis,
        y = input$y_axis
      )
    
  })
  
}
shinyApp(ui, server)
