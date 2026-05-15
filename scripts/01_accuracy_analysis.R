# 01_accuracy_analysis.R
# Accuracy analysis for the Vibrotactile Motion Perception project

library(dplyr)

# Load behavioural dataset
# Replace this with your local file path if running locally
data <- read.csv("data/sample_data.csv")

accuracy_summary <- data %>%
  group_by(subject, modeSeq, absPhaseSeq) %>%
  summarise(
    total_trials = n(),
    correct_responses = sum(isCorrect == 1, na.rm = TRUE),
    accuracy = mean(isCorrect, na.rm = TRUE),
    .groups = "drop"
  )

print(accuracy_summary)

write.csv(
  accuracy_summary,
  "results/accuracy_summary.csv",
  row.names = FALSE
)
