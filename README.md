# Time Series Analysis and Forecasting of Energy Consumption

## Overview

This project focuses on analyzing and forecasting household energy consumption using time series methods. The dataset contains high-frequency measurements of electrical power usage, and the goal is to identify temporal patterns and build predictive models for short-term forecasting.

---

## Objectives

- Perform data cleaning and preprocessing on raw time series data  
- Aggregate high-frequency data to improve interpretability  
- Identify and analyze trend and seasonal patterns  
- Test stationarity using statistical methods  
- Build and compare time series forecasting models  
- Generate short-term forecasts with uncertainty estimates  

---

## Dataset

- **Source**: UCI Machine Learning Repository  
- **Dataset**: Individual Household Electric Power Consumption  
- **Samples**: ~2 million observations (minute-level data)  

### Features Used

- Global Active Power  
- Global Reactive Power  
- Voltage  
- Global Intensity  
- Sub-metering variables  
- Date and Time  

---

## Data Preprocessing

- Combined `Date` and `Time` into a unified `Datetime` variable  
- Replaced invalid values (`?`) with `NA`  
- Removed missing values  
- Converted numerical columns to appropriate types  
- Aggregated data to **hourly averages** to reduce noise  

---

## Exploratory Analysis

- Visualized raw and aggregated time series  
- Observed high variability and periodic fluctuations  
- Identified repeating patterns indicating daily seasonality  

---

## Time Series Decomposition

- Applied additive decomposition to separate:
  - Trend component  
  - Seasonal component  
  - Random noise  

- Extracted and visualized a single daily seasonal cycle  
- Confirmed strong daily consumption patterns:
  - Low usage in early morning  
  - Increasing usage during the day  
  - Peak usage in the evening  

---

## Stationarity Testing

- Conducted Augmented Dickey-Fuller (ADF) test  
- Results indicated that the aggregated time series is **stationary**  
- No additional differencing required for modeling  

---

## Models Implemented

### 1. ARIMA Model

- Model: `ARIMA(5,1,0)(2,0,0)[24]`  
- Captures:
  - Short-term dependencies  
  - Daily seasonal patterns (24-hour cycle)  

### 2. ETS Model

- Model: `ETS(M, A, M)`  
- Captures:
  - Additive trend  
  - Multiplicative seasonality  
  - Smooth underlying structure  

---

## Model Comparison

| Aspect | ARIMA | ETS |
|------|------|-----|
| Captures autocorrelation | Yes | No |
| Captures seasonality | Yes | Yes |
| Forecast behavior | Reactive | Smooth |
| Uncertainty | Lower | Higher |

- ARIMA provides more responsive forecasts  
- ETS produces smoother predictions with wider confidence intervals  

---

## Forecasting

- Generated forecasts for the next **48 hours**  
- Observations:
  - Both models preserve daily seasonality  
  - Forecast uncertainty increases over time  
  - Predictions remain within realistic ranges  

---

## Key Findings

- Energy consumption exhibits strong **daily seasonality**  
- Aggregation is essential for reducing noise in high-frequency data  
- Both ARIMA and ETS models effectively capture temporal patterns  
- Short-term forecasts are reliable, while long-term uncertainty increases  

---

## Technologies Used

- R  
- tidyverse  
- forecast  
- tseries  
- lubridate  

---

## How to Run

1. Install required packages:
   ```r
   install.packages(c("tidyverse", "forecast", "tseries", "lubridate"))
