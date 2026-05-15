# 04_permutation_tests.R
# Permutation-based significance testing for one-hand vs two-hand accuracy

library(dplyr)
library(tidyr)

set.seed(123)

data <- read.csv("data/sample_data.csv")

summary_data <- data %>%
  group_by(subject, modeSeq, absPhaseSeq) %>%
  summarise(
    accuracy = mean(isCorrect, na.rm = TRUE),
    .groups = "drop"
  )

wide_data <- summary_data %>%
  pivot_wider(
    names_from = modeSeq,
    values_from = accuracy,
    names_prefix = "mode_"
  ) %>%
  filter(!is.na(mode_1), !is.na(mode_2))

permutation_test <- function(x, y, n_permutations = 10000) {
  observed_diff <- mean(y, na.rm = TRUE) - mean(x, na.rm = TRUE)
  combined <- c(x, y)

  perm_diffs <- replicate(n_permutations, {
    permuted <- sample(combined)
    mean(permuted[1:length(x)], na.rm = TRUE) -
      mean(permuted[(length(x) + 1):length(combined)], na.rm = TRUE)
  })

  p_value <- mean(abs(perm_diffs) >= abs(observed_diff))

  data.frame(
    observed_difference = observed_diff,
    p_value = p_value
  )
}

permutation_results <- wide_data %>%
  group_by(absPhaseSeq) %>%
  summarise(
    result = list(permutation_test(mode_1, mode_2)),
    .groups = "drop"
  ) %>%
  tidyr::unnest(result)

print(permutation_results)

write.csv(
  permutation_results,
  "results/permutation_results.csv",
  row.names = FALSE
)
