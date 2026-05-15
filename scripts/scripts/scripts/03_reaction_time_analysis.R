# 03_reaction_time_analysis.R
# Reaction time analysis for vibrotactile motion perception

library(dplyr)

data <- read.csv("data/sample_data.csv")

reaction_time_summary <- data %>%
  filter(!is.na(reactionTime)) %>%
  group_by(subject, modeSeq, absPhaseSeq) %>%
  summarise(
    mean_reaction_time = mean(reactionTime, na.rm = TRUE),
    sd_reaction_time = sd(reactionTime, na.rm = TRUE),
    n_trials = n(),
    .groups = "drop"
  )

print(reaction_time_summary)

write.csv(
  reaction_time_summary,
  "results/reaction_time_summary.csv",
  row.names = FALSE
)
