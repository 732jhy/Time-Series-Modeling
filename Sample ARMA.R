## ---------------------------------------------------------------------------------------------------------------
##
## Sample ARMA.R
##
## This script is made to demonstrate the steps for building an ARMA style model for a time series (in this case,
## stock returns). The time series data utilized in this script is obtained from Yahoo Finance via the quantmod 
## package.
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

library(quantmod)
library(TSA)

# Get daily price data for Google stock (10 years daily)
getSymbols('GOOG',src='yahoo',from='2010-1-1',to='2019-12-31')
r = GOOG$GOOG.Adjusted %>% log %>% diff %>% na.omit

# Summary statistics - mean, standard deviation, skewness, kurtosis
mean(r)
sqrt(var(r))
skewness(r)
kurtosis(r)

# ADF test for stationarity
adf.test(GOOG$GOOG.Adjusted) # p-value = 0.2799 -> not stationary
adf.test(r, alternative = 'stationary') # p-value < 0.01 -> probably is stationary

# Run this for visual inspection of stationarity
plot(GOOG$GOOG.Adjusted) 
plot(r)


# Build ARIMA model
# Check EACF for p, q parameters
eacf(r) # Suggests MA(1), ARMA(1,1), ARMA(3,1), or AR(5)

# Alternative p, q estimation --> Find p, q to minimize AIC
min_AIC <- 0
p <- 0
q <- 0
for(i in 0:5){
  for(j in 0:5){
    temp = arima(r,order=c(i,0,j))
    if(temp$aic < min_AIC){
      best = temp$aic
      p=i
      q=j
    }
  }
}

c(p, q) %>% print # suggests ARMA(5,5)

model = arima(r, order=c(1,0,1))
print(model)




