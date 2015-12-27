library(shiny)

shinyServer(
    function(input, output) {
        sampleVector <- reactive({
            df <- NULL
            v <- rep(0, input$samples)
            
            for (i in 1:input$samples) {
                r <- runif(n = input$groupingSize, min = 1, max = input$maxValue + 1)
                c <- trunc(r)
                df <- rbind(df, c)
            }
                
            
            for (i in 1:input$samples) {
                v[i] <- mean(df[i, ])
            }
            
            v
        })
        
        histBins <- reactive({
            # Constrain histogram bins from 12-25, somewhat variable with number of
            # samples (as more samples usually makes a finer-grained display meaningful);
            # but also cap at the max number of distinct values available from the
            # roll of the dice (e.g., 3-18 = 16 distinct values from 3 6-sided dice)
            distinctValues <- (input$maxValue - 1) * input$groupingSize + 1
            
            bins <- round(sqrt(input$samples))
            bins <- max(bins, 12)
            bins <- min(bins, 25)
            bins <- min(bins, distinctValues)
            
            bins
        })
        
        xLabel <- reactive({
            paste("Mean roll of a ", input$maxValue, "-sided die", sep = "")
        })
        mainLabel <- reactive({
            diceWord <- ifelse(input$groupingSize == 1, "die", "dice")
            rollsWord <- ifelse(input$samples == 1, "roll", "rolls")
            paste("Mean values for", input$samples, rollsWord, "of", input$groupingSize, diceWord, sep = " ")
        })
        
        output$hist <- renderPlot({
            if ((input$groupingSize <= 2) || (input$samples == 1)) {
                # Special handling for one or two dice, or just a single rolls:
                # keeps it from looking funny  by having spaces between what we know
                # are just discrete values.
                breaks <- seq(from = 0.5, to = input$maxValue + 0.5, by = 1)
                hist <- hist(sampleVector(), xlab=xLabel(), ylab='Frequency', col='lightblue', main=mainLabel(), histBins(), breaks=breaks)
                
            } else {
                hist <- hist(sampleVector(), xlab=xLabel(), ylab='Frequency', col='lightblue', main=mainLabel(), histBins())
            }
            
            hist
        })
    }
)