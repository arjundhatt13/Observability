library(zoo)
library(readxl)
library(dplyr)
library(tidyr)


########################## Import Study Data
study_data = read_excel("C:/Users/arjun/Documents/Work/USRA/Final Package/Empirical Study Data/Empirical Study Data.xlsx", sheet = "SA Comparison - Data")
study_data = as.matrix(study_data)

# Extract Variables
num_assets =  as.numeric(study_data[, 2])
period_length =  as.numeric(study_data[, 3])
start_date = as.numeric(study_data[, 4])
end_date =  start_date + period_length
SPY_k_score =  as.numeric(study_data[, 5])
IVV_k_score =  as.numeric(study_data[, 6])
VOO_k_score =  as.numeric(study_data[, 7])
VTI_k_score =  as.numeric(study_data[, 8])


############ ANOVA test
anova_data <- data.frame(
  SPY_k_score = SPY_k_score,
  IVV_k_score = IVV_k_score,
  VOO_k_score = VOO_k_score,
  VTI_k_score = VTI_k_score
)

# Reshape data for ANOVA (from wide to long format)
anova_data_long <- anova_data %>%
  pivot_longer(cols = everything(), names_to = "Asset", values_to = "K_Score")

# Run ANOVA test
aov_model <- aov(K_Score ~ Asset, data = anova_data_long)
anova_results <- summary(aov_model)

# Display ANOVA results
print(anova_results)