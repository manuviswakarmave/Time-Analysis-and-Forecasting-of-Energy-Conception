install.packages("tidyverse")
install.packages("lubridate")
install.packages("forecast")
install.packages("tseries")

library(tidyverse)
library(lubridate)
library(forecast)
library(tseries)

## RESEARCH QUESTION : HOW CAN HISTORICAL ENERGY CONSUMPTION DATA BE USED TO
##                     MODEL AND FORECAST FUTURE DEMANDS AND WHAT SEASONAL PATTERNS INFLUENCE
##                     CONSUMPTION OVER TIME

df <- read.csv("household_power_consumption.txt", sep= ";")
head(df)
str(df)

##PREPROCESSING

df[df == "?"] <- NA

df$Datetime <- as.POSIXct(
  paste(df$Date, df$Time),
  format = "%d/%m/%Y %H:%M:%S"
)


df$Global_active_power <- as.numeric(df$Global_active_power)
df <- na.omit(df)

str(df)

##Convert to time series

ts_data <- ts(df$Global_active_power, frequency = 24)
plot(ts_data, main = "Energy Consumption Over Time")

## The plot describes Global active power (consumption) vs time .. For now it looks messy but still one
## can observe values fluctuate between 0 and 10(high variability) with frequent spikes. however due to large 
## number of observations patterns are not clearly visible needs further decomposition and aggregation.

## Aggregation of data by hour

library(dplyr)
df_small <- df %>%
  mutate(Hour = format(Datetime, "%Y-%m-%d %H")) %>%
  group_by(Hour) %>%
  summarise(Global_active_power = mean(Global_active_power, na.rm = TRUE))
ts_small <- ts(df_small$Global_active_power, frequency = 24)

plot(ts_small, main = "Hourly Energy Consumption")
  
## After aggregating the data to hourly averages, the time series exhibits clearer patterns with reduced noise. 
## The plot reveals significant variability in energy consumption along with recurring fluctuations, indicating
## potential seasonal behavior. However, due to the density of the data, underlying trend and seasonal components
## require further decomposition for clearer interpretation.

plot(ts_small[1:200], type = "l", main="Hourly Energy Consumption (Zoomed)")
 
## The zoomed-in time series reveals clear cyclical patterns in energy consumption, indicating the presence of daily seasonality.
## Peaks and troughs correspond to periods of high and low usage, respectively, likely reflecting household activity patterns.
## Despite this, the data exhibits significant short-term variability, suggesting the presence of noise. No strong trend is observed in this short window,
## indicating that longer-term patterns require further analysis.

## DECOMPOSITION
decomp <- decompose(ts_data)
plot(decomp)

decomp2 <-decompose(ts_small)
plot(decomp2)

## The decomposition reveals a clear trend component with gradual variations over time. The seasonal component, while not visually distinct due to overplotting, 
## reflects recurring daily consumption patterns. The residual component captures significant variability, indicating the presence of irregular fluctuations in energy usage.
## Overall, the time series exhibits both structured temporal behavior and stochastic variation.

plot(decomp$seasonal[1:24], type="l", main="One Daily Seasonal Cycle")

## The seasonal component reveals a clear daily consumption pattern. Energy usage is lowest during early morning hours, increases throughout the day, and peaks in the evening,
## reflecting typical household activity. 
## This confirms the presence of strong daily seasonality driven by human behavior. 

##STATIONARY cHECK
adf.test(ts_data)
adf.test(ts_small)

##An Augmented Dickey-Fuller (ADF) test was performed on the aggregated time series data to assess stationarity. The test produced a statistically significant result (p < 0.01), leading to rejection of the null hypothesis of non-stationarity. This confirms that the time series is stationary and suitable for time series modeling without the need for differencing.

##ARIMA MODEL
model_arima <- auto.arima(ts_small)
summary(model_arima)

##An ARIMA(5,1,0)(2,0,0)[24] model was fitted to the time series, capturing both short-term dependencies and daily seasonal patterns. The inclusion of seasonal autoregressive terms with a period of 24 confirms strong daily seasonality in energy consumption. Model evaluation shows moderate prediction accuracy (RMSE ≈ 0.63), and residual diagnostics indicate minimal autocorrelation, suggesting a well-fitted model.


##FORECAST
forecast_arima <- forecast(model_arima, h=48)
plot(forecast_arima)

plot(forecast_arima, main="Energy Consumption Forecast (Next 48 Hours)",
     include = 200)

## The ARIMA model was used to forecast energy consumption for the next 48 hours. The forecast exhibits clear cyclical patterns, reflecting the daily seasonality observed in the data. The predictions remain stable and within a realistic range, indicating that the model captures the underlying temporal structure effectively. The widening confidence intervals highlight increasing uncertainty over time, which is expected in time series forecasting.
##ETS MODEL
model_ets <- ets(ts_small)
forecast_ets <- forecast(model_ets, h=48)
plot(forecast_ets)
plot(forecast(model_ets, h = 48),
     main="ETS Forecast (Next 48 Hours)",
     include = 200)

##MODEL COMPARISON

## Both ARIMA and ETS models were applied to forecast energy consumption. The ARIMA model captures short-term dependencies and produces more reactive forecasts, while the ETS model generates smoother predictions by focusing on underlying trend and seasonal components. The ETS model also exhibits wider confidence intervals, reflecting greater uncertainty in long-term predictions. Based on evaluation metrics such as RMSE and MAE, [insert result], indicating that [chosen model] provides better forecasting performance for this dataset.

accuracy(forecast_arima)
accuracy(forecast_ets)
