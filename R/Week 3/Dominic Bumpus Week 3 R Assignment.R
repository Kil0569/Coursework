# Load Required Libraries

library(rpart)
library(rpart.plot)
library(pROC)

# Read data
hmeq <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_Scrubbed\\HMEQ_Scrubbed.csv", stringsAsFactors = TRUE)

# Structure of the data
str(hmeq)

# Summary statistics
summary(hmeq)

# First six observations
head(hmeq)

# Remove TARGET_LOSS_AMT
class_data <- subset(hmeq, select = -TARGET_LOSS_AMT)

# Gini Index Tree
tree_gini <- rpart(
  TARGET_BAD_FLAG ~ .,
  data = class_data,
  method = "class",
  parms = list(split = "gini"),
  control = rpart.control(cp = 0.01)
)

# Entropy (Information Gain) Tree
tree_entropy <- rpart(
  TARGET_BAD_FLAG ~ .,
  data = class_data,
  method = "class",
  parms = list(split = "information"),
  control = rpart.control(cp = 0.01)
)

# Plot trees
rpart.plot(tree_gini, main = "Classification Tree - Gini Index")
rpart.plot(tree_entropy, main = "Classification Tree - Entropy")

# Important variables
tree_gini$variable.importance
tree_entropy$variable.importance

# ROC Curves
prob_gini <- predict(tree_gini, type = "prob")[,2]
prob_entropy <- predict(tree_entropy, type = "prob")[,2]

roc_gini <- roc(class_data$TARGET_BAD_FLAG, prob_gini)
roc_entropy <- roc(class_data$TARGET_BAD_FLAG, prob_entropy)

plot(roc_gini, col = "blue", main = "ROC Curve - Classification Trees")
lines(roc_entropy, col = "red")
legend("bottomright",
       legend = c("Gini", "Entropy"),
       col = c("blue", "red"),
       lwd = 2)

# Remove TARGET_BAD_FLAG
reg_data <- subset(hmeq, select = -TARGET_BAD_FLAG)

# ANOVA Tree
tree_anova <- rpart(
  TARGET_LOSS_AMT ~ .,
  data = reg_data,
  method = "anova",
  control = rpart.control(cp = 0.01)
)

# Poisson Tree
tree_poisson <- rpart(
  TARGET_LOSS_AMT ~ .,
  data = reg_data,
  method = "poisson",
  control = rpart.control(cp = 0.01)
)

# Plot trees
rpart.plot(tree_anova, main = "Regression Tree - ANOVA")
rpart.plot(tree_poisson, main = "Regression Tree - Poisson")

# Important variables
tree_anova$variable.importance
tree_poisson$variable.importance

# Predictions
pred_anova <- predict(tree_anova)
pred_poisson <- predict(tree_poisson)

# Root Mean Square Error calculation
rmse_anova <- sqrt(mean((reg_data$TARGET_LOSS_AMT - pred_anova)^2, na.rm = TRUE))
rmse_poisson <- sqrt(mean((reg_data$TARGET_LOSS_AMT - pred_poisson)^2, na.rm = TRUE))

rmse_anova
rmse_poisson


# The ANOVA regression tree produces a lower RMSE and
# more interpretable splits than the Poisson model.
# Large losses are driven by higher loan balances,
# weaker credit profiles, and prior delinquency behavior.

# Probability of Default Tree
prob_tree <- rpart(
  TARGET_BAD_FLAG ~ .,
  data = class_data,
  method = "class",
  control = rpart.control(cp = 0.01)
)

# Severity Tree (Loss Given Default)
severity_data <- subset(hmeq, TARGET_BAD_FLAG == 1)
severity_data <- subset(severity_data, select = -TARGET_BAD_FLAG)

severity_tree <- rpart(
  TARGET_LOSS_AMT ~ .,
  data = severity_data,
  method = "anova",
  control = rpart.control(cp = 0.01)
)

# Plot trees
rpart.plot(prob_tree, main = "Probability of Default Tree")
rpart.plot(severity_tree, main = "Severity (Loss Given Default) Tree")

# Important variables
prob_tree$variable.importance
severity_tree$variable.importance

# Predictions
prob_default <- predict(prob_tree, type = "prob")[,2]
pred_severity <- predict(severity_tree, newdata = hmeq)

# Expected Loss = Probability × Severity
expected_loss <- prob_default * pred_severity

# Root Mean Square Error for Probability/Severity model
rmse_ps <- sqrt(mean((hmeq$TARGET_LOSS_AMT - expected_loss)^2, na.rm = TRUE))
rmse_ps

# The Probability/Severity approach separates default risk
# from loss magnitude and generally improves performance
# over a single regression model.
# This method is recommended for credit risk modeling
# due to better accuracy.

