# 02_response_bias_analysis.R
# Response bias analysis for left/right responses

library(dplyr)

data <- read.csv("data/sample_data.csv")

response_bias_summary <- data %>%
  group_by(subject, modeSeq) %>%
  summarise(
    total_responses = n(),
    left_responses = sum(response == "L", na.rm = TRUE),
    right_responses = sum(response == "R", na.rm = TRUE),
    left_percentage = left_responses / total_responses * 100,
    right_percentage = right_responses / total_responses * 100,
    .groups = "drop"
  )

print(response_bias_summary)

write.csv(
  response_bias_summary,
  "results/response_bias_summary.csv",
  row.names = FALSE
)
