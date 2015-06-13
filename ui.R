shinyUI(pageWithSidebar(
        headerPanel("Age for maternity?"),
        sidebarPanel(
                sliderInput(
                        'birthdate', 
                        'When did you born?',
                        value = 1982, min = 1965, max = 2015, step = 1),
                selectInput('current_country', 'Where do you live?', countries)
                ,
                numericInput('expected_age', 'What age do you expect to have your first child?', 29)
        ),
        mainPanel(
                plotOutput('new_plot'),
                textOutput('predicted_age')
        )
))
