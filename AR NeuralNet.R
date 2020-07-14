## ---------------------------------------------------------------------------------------------------------------
##
## AR NeuralNet.R
##
## This script is made to demonstrate an example implementation of a 3-2-1 feed forward time-series based
## Neural Network model using the 1, 2, and 3 period lagged series as inputs for modeling the contemporaneuos
## series. Visual representation of the model is easily plotted, and model performance measures (single period
## comparison, SSE, and MSE) are also provided.
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


#install.packages('neuralnet')
library(neuralnet)
library(quantmod)
library(dplyr)
library(plyr)

# Get Data (MSFT stock, weekly, 20 years)

getSymbols('MSFT',src='yahoo',from='2000-1-1',to='2019-12-31',periodicity='weekly')

l = MSFT$MSFT.Close %>% length

r = MSFT$MSFT.Adjusted[4:l] %>% log %>%diff %>% na.omit
names(r)[names(r)=='MSFT.Adjusted'] <- 'rt'


# Lag the series 1,2,3 weeks

rt_1 = MSFT$MSFT.Adjusted[3:(l-1), drop = TRUE] %>% as.numeric %>% log %>% diff %>% na.omit
rt_2 = MSFT$MSFT.Adjusted[2:(l-2), drop = TRUE] %>% as.numeric %>% log %>% diff %>% na.omit
rt_3 = MSFT$MSFT.Adjusted[1:(l-3), drop = TRUE] %>% as.numeric %>% log %>% diff %>% na.omit

r$Lag.1 <- rt_1
r$Lag.2 <- rt_2
r$Lag.3 <- rt_3

r %>% head %>% print


# split into training and testing sets
train = r['2000-01-01::2017-12-31'] # 18 years training
test = r['2018-01-01::2019-12-31'] # 2 years testing

# Train the model on training set
nn = neuralnet(rt~Lag.1+Lag.2+Lag.3, data=train, hidden=2,linear.output = TRUE, err.fct='sse',act.fct='tanh')

# print NN visual representation
print(plot(nn,rep="best"))


# Feed the model the test data
pred = predict(nn,test)

# 1-step ahead prediction
print('1-step ahead prediction:')
pred[1]
# Actual Value
print('1-step ahead actual value:')
as.numeric(test$rt[1])

# squared error terms
se =c()
for(i in 1:length(test$rt)){se <- c(se, (as.numeric(test$rt[i])-pred[i])^2)}

# Mean squared error
print('Mean squared error:')
mean(se)

# Sum of squared errors
print('Sum of squared errors:')
sum(se)







