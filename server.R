
library(ggplot2)

#
# view initialized data in global.R
#

createModel <- function(current_country){
        country_chosen_age <- df_ages[current_country,]
        
        age <- seq(
                from=country_chosen_age$min_age*100, 
                to = country_chosen_age$max_age*100, 
                by = round((country_chosen_age$max_age-country_chosen_age$min_age)*100 / length(dates)))/100 + rnorm(length(dates), mean = 0, sd=0.3)
        
        dat <- data.frame(dates, age)
        
        lm(age ~ dates, data=dat)
        
}

calculate_year_first_birth <- function(birthdate, expected_age){
        birthdate + expected_age
}

create_prediction <- function(country, birthdate, expected_age){
        year_first_birth <- calculate_year_first_birth(birthdate, expected_age)
        model <- createModel(country)
        predicted_age <- predict(
                                model, 
                                type = "response",
                                data.frame(dates = year_first_birth)
                        )
        list(year_first_birth = year_first_birth, predicted_age = predicted_age, model = model)    
}

shinyServer(
        
        function(input, output) {
        
                output$new_plot <- renderPlot({
                        prediction <-  create_prediction(input$current_country, input$birthdate, input$expected_age)      
                        g <- ggplot(data.frame(prediction$model$model), aes(x=dates, y=age), environment = environment())
                        g <- g + geom_point()
                        g <- g + geom_point(aes(x=prediction$year_first_birth, y=prediction$predicted_age), colour="red", size = 3)
                        g <- g + geom_abline(
                                intercept = prediction$model$coeff[1],
                                slope = prediction$model$coeff[2])
                        g <- g + geom_vline(xintercept = prediction$year_first_birth, colour="red")
                        g <- g + geom_hline(yintercept = prediction$predicted_age, colour="red")
                        g

                        
                })
                
                output$predicted_age <- renderText({
                        year_first_birth <- calculate_year_first_birth(input$birthdate, input$expected_age)
                        model <- createModel(input$current_country)
                        predicted_age <- predict(
                                model, 
                                type = "response",
                                data.frame(dates = year_first_birth)
                        )
                        paste(
                                "When you will be / was ", input$expected_age,
                                " in ", year_first_birth,
                                " the predicted mean should be ",
                                predicted_age
                        )
                })
                        
                
    
                
        }
)