## ---------------------------------------------------------------------------------------------------------------
##
## Multivariate AR.R
##
## The purpose of this script is to provide a sample implementation of a multivariate AR model. This script also
## includes implementation of a univariate AR model on the same data set for comparison purposes. Also provided
## are the steps in selecting the value p for AR(p) in both the univariate and multivariate case.
##
## Author: Justin Yu, M.S. Financial Engineering, Stevens Institute of Technology
## 
## Date Created: 2020-07-14
##
## Email: 732jhy@gmail.com
##
## ---------------------------------------------------------------------------------------------------------------
##
## Notes:
##
##
## ---------------------------------------------------------------------------------------------------------------

library(dplyr)
library(quantmod)
library(forecast)
library(vars)

# Load in the data (Google and Apple stock Jan 1, 2018 to Dec 31, 2019)
getSymbols('AAPL', from='2018-1-1', to='2019-12-31')
getSymbols('GOOG', from='2018-1-1', to='2019-12-31')

# Log returns
ts1 <- AAPL$AAPL.Adjusted %>% log %>% diff %>% na.omit
ts2 <- GOOG$GOOG.Adjusted %>% log %>% diff %>% na.omit

# Univariate AR models
best_AR <- function(series){
  # Finds the best parameter p for AR model with lowest AIC
  # Returns the AR(p) model 
  p <- 1
  aic <- Arima(series,order=c(p,0,0))$aic
  for(i in 1:10){
    model <- Arima(series,order=c(i,0,0))
    if(model$aic < aic){
      aic <- model$aic
      p <- i
    }else{next}
  }
  return(Arima(series,order=c(p,0,0)))
}

best_AR(ts1) #AR(1)
best_AR(ts2) #AR(8)


# Bivariate AR model
df <- cbind(ts1, ts2) %>% data.frame

# Build a bivariate autoregressive model for the two change series
VARselect(df,lag.max=10,type="const")[["selection"]] 

#AIC suggests VAR(7) model
bivar <- VAR(df,p=7,type="const")
print(bivar)



