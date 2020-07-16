# Time-Series-Models
This repository contains example implementations of several popular time series models, including, but not limited to, univariate, multivariate, some Machine Learning, and ARCH style volatility models. The R scripts here demonstrate the model building process, going from raw time series data to a working model. All model implementations use the quantmod package to obtain time series data from Yahoo Finance.

## Neural-Network models
This implementation uses the neuralnet (v1.44.2) package to generate the model and its parameters.
Visual representation of a 3-2-1 feed forward neural network:
![](images/Sample_NN.png)

## Univariate ARMA models:
This model implementation uses functions of the TSA (v1.2) package. Standard stationarity tests and order selection are provided as part of the model building process.

## Multivariate AR models:
The model implementation provided here in Multivariate AR.R uses the forecast (v8.4) package for the implementation of univariate AR models. The bivariate AR model generated in this file uses functions from the vars (v1.5-3) package for model order and parameter estimation.
