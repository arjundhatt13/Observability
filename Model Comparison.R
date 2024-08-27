library(zoo)
library(readxl)
library(dplyr)
library(tidyr)

########################## Import Study Data
study_data = read_excel("C:/Users/arjun/Documents/Work/USRA/Final Package/Empirical Study Data/Empirical Study Data.xlsx", sheet = "Model Comparison - Data")
study_data = as.matrix(study_data)

# Extract Variables
num_assets =  as.numeric(study_data[, 2])
period_length =  as.numeric(study_data[, 3])
start_date = as.numeric(study_data[, 4])
end_date =  start_date + period_length
k_score =  as.numeric(study_data[, 5])
OBS_computation_time = as.numeric(study_data[, 6])
UNOBS_computation_time = as.numeric(study_data[, 7])
OBS_k_score = as.numeric(study_data[, 8]) 
UNOBS_k_score = as.numeric(study_data[, 9])

########################## Import Market Condition Data
market_data = read_excel("C:/Users/arjun/Documents/Work/USRA/Final Package/Empirical Study Data/Empirical Study Data.xlsx", sheet = "Market Conditions")
market_data = as.matrix(market_data)
VIX_prices = as.numeric(market_data[,4])
Condition = as.numeric(market_data[,3])
market_df = data.frame(Days = as.numeric(market_data[,2]), Condition = Condition, VIX_Price =  VIX_prices)

# Initialize Arrays
market_condition = c(length(num_assets), 1)
mean_VIX = c(length(num_assets), 1)

### Calculates amount of Bull and Bear days as well as mean VIX price
for (i in 1:length(num_assets)) {

# Filter data based on the specified range
filtered_data = market_df[market_df$Days >= start_date[i] & market_df$Days <= end_date[i],]

# Calculate mean VIX Price
mean_VIX[i] = mean(filtered_data$VIX_Price)

# Count days in bull and bear markets
bull_days = sum(filtered_data$Condition == 1)
bear_days = sum(filtered_data$Condition == 0)

# Standardize the Market Condition Variable
market_condition[i] = bull_days

}


########################## Linear Regression

###### Standardize the Independent Variables (market_condition is already standardized)

### Market Volatility
# Initialize an empty list to store the results
market_vol_mean_vol <- list()

# Loop through each window size from 182 to 750
for (period in 182:750) {
  
  # Calculate the rolling average (mean) for the current period
  rolling_avg = zoo::rollapply(market_df$VIX_Price, width = period, FUN = mean, fill = NA, align = "right")

  # Calculate mean and volatility (standard deviation) for the period with the maximum average
  mean_avg <- mean(rolling_avg, na.rm = TRUE)
  mean_vol <- sd(rolling_avg, na.rm = TRUE)
  
  # Store the result in the list
  market_vol_mean_vol[[as.character(period)]] <- data.frame(
    Period = period,
    Mean_VIX = mean_avg,
    Volatility_VIX = mean_vol
  )
}

# Convert the list of results to a data frame
market_vol_mean_vol_df <- bind_rows(market_vol_mean_vol)

### Market Volatility
std_market_vol = c(length(num_assets), 1)

for (i in 1:length(num_assets)) {
  
  std_market_vol[i] = (mean_VIX[i] - market_vol_mean_vol_df[period_length[i] - 181,2]) / (market_vol_mean_vol_df[period_length[i] - 181,3])
  
}


### Market Conditions
# Initialize an empty list to store the results
market_condition_mean_vol <- list()

# Loop through each window size from 182 to 750
for (period in 182:750) {
  
  # Calculate the rolling average (mean) for the current period
  rolling_avg = zoo::rollapply(market_df$Condition, width = period, FUN = mean, fill = NA, align = "right")

  # Calculate mean and volatility (standard deviation) for the period with the maximum average
  mean_avg <- mean(rolling_avg, na.rm = TRUE)
  mean_vol <- sd(rolling_avg, na.rm = TRUE)
  
  # Store the result in the list
  market_condition_mean_vol[[as.character(period)]] <- data.frame(
    Period = period,
    Mean_Condition = mean_avg,
    Volatility_Condition = mean_vol
  )
}

# Convert the list of results to a data frame
market_condition_mean_vol_df <- bind_rows(market_condition_mean_vol)

### Market Volatility
std_market_condition = c(length(num_assets), 1)

for (i in 1:length(num_assets)) {
  
  std_market_condition[i] = (market_condition[i]/period_length[i] - market_condition_mean_vol_df[period_length[i] - 181,2]) / (market_condition_mean_vol_df[period_length[i] - 181,3])
  
}


### Number of Ordinary Assets
std_num_assets = (num_assets - mean(num_assets)) / sd(num_assets)

### Period Length
std_period_length = (period_length - mean(period_length)) / sd(period_length)



###### Run Linear Regression
regression_data <- data.frame(
  k_score = UNOBS_k_score,
  num_assets = std_num_assets,
  period_length = std_period_length,
  market_condition = std_market_condition,
  market_vol = std_market_vol)

# Fit the linear regression model again
model <- lm(k_score ~ std_market_condition + std_num_assets + std_period_length + std_market_vol, data = regression_data)

# Show the summary of the model
summary(model)



############ T-tests
t.test(OBS_k_score, UNOBS_k_score, paired = TRUE, alternative = "less")
t.test(OBS_computation_time, UNOBS_computation_time, paired = TRUE, alternative = "greater")

