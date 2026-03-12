library(rpart)
library(rpart.plot)
library(pROC)
library(caret)

#Read Data
hmeq <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_Scrubbed\\HMEQ_Scrubbed.csv")

cat("\nData Structure\n")
str(hmeq)

cat("\nSummary Statistics\n")
summary(hmeq)

cat("\nFirst Records\n")
head(hmeq)

#Classification Trees
hmeq$TARGET_BAD_FLAG <- as.factor(hmeq$TARGET_BAD_FLAG)

#Remove TARGET_LOSS_AMT
hmeq_class <- subset(hmeq, select = -TARGET_LOSS_AMT)

#Classification
run_classification <- function(seed_value){
  
  cat("Classification Run Seed:", seed_value, "\n")
  
  set.seed(seed_value)
  
  trainIndex <- createDataPartition(
    hmeq_class$TARGET_BAD_FLAG,
    p = 0.70,
    list = FALSE
  )
  
  train <- hmeq_class[trainIndex, ]
  test  <- hmeq_class[-trainIndex, ]

  #GINI
  tree_gini <- rpart(
    TARGET_BAD_FLAG ~ .,
    data = train,
    method = "class",
    parms = list(split = "gini")
  )
  
  rpart.plot(tree_gini, main = "Classification Tree (GINI)")
  
  cat("\nVariable Importance (GINI):\n")
  print(tree_gini$variable.importance)
  
  prob_gini <- predict(tree_gini, test, type = "prob")[,2]
  roc_gini <- roc(test$TARGET_BAD_FLAG, prob_gini)
  
  plot(roc_gini, main = "ROC Curve - GINI Tree")
  cat("GINI AUC:", auc(roc_gini), "\n")

  #Entropy
  tree_entropy <- rpart(
    TARGET_BAD_FLAG ~ .,
    data = train,
    method = "class",
    parms = list(split = "information")
  )
  
  rpart.plot(tree_entropy, main = "Classification Tree (Entropy)")
  
  cat("\nVariable Importance (Entropy):\n")
  print(tree_entropy$variable.importance)
  
  prob_entropy <- predict(tree_entropy, test, type = "prob")[,2]
  roc_entropy <- roc(test$TARGET_BAD_FLAG, prob_entropy)
  
  plot(roc_entropy, main = "ROC Curve - Entropy Tree")
  cat("Entropy AUC:", auc(roc_entropy), "\n")

  #Model Comparison
  cat("\nSummary:\n")
  if (auc(roc_gini) > auc(roc_entropy)) {
    cat("GINI performed better based on AUC.\n")
  } else {
    cat("Entropy performed better based on AUC.\n")
  }
}

#Run 3 times
run_classification(100)
run_classification(200)
run_classification(300)

#Trees are optimal based on the AUC values.

#Remove TARGET_BAD_FLAG
hmeq_reg <- subset(hmeq, select = -TARGET_BAD_FLAG)

#Regression
run_regression <- function(seed_value){

  cat("Regression Run Seed:", seed_value, "\n")
  
  set.seed(seed_value)
  
  trainIndex <- createDataPartition(
    hmeq_reg$TARGET_LOSS_AMT,
    p = 0.70,
    list = FALSE
  )
  
  train <- hmeq_reg[trainIndex, ]
  test  <- hmeq_reg[-trainIndex, ]

  #ANOVA Regression Tree
  tree_anova <- rpart(
    TARGET_LOSS_AMT ~ .,
    data = train,
    method = "anova"
  )
  
  rpart.plot(tree_anova, main = "Regression Tree (ANOVA)")
  
  cat("\nVariable Importance (ANOVA):\n")
  print(tree_anova$variable.importance)
  
  pred_anova <- predict(tree_anova, test)
  rmse_anova <- sqrt(mean((pred_anova - test$TARGET_LOSS_AMT)^2))
  
  cat("ANOVA RMSE:", rmse_anova, "\n")

  #Poisson Regression Tree
  tree_poisson <- rpart(
    TARGET_LOSS_AMT ~ .,
    data = train,
    method = "poisson"
  )
  
  rpart.plot(tree_poisson, main = "Regression Tree (Poisson)")
  
  cat("\nVariable Importance (Poisson):\n")
  print(tree_poisson$variable.importance)
  
  pred_poisson <- predict(tree_poisson, test)
  rmse_poisson <- sqrt(mean((pred_poisson - test$TARGET_LOSS_AMT)^2))
  
  cat("Poisson RMSE:", rmse_poisson, "\n")
  
  #Model Comparison
  if (rmse_anova < rmse_poisson) {
    cat("ANOVA regression tree performed better (lower RMSE).\n")
  } else {
    cat("Poisson regression tree performed better (lower RMSE).\n")
  }
}

#Run 3 times
run_regression(100)
run_regression(200)
run_regression(300)

#Trees are slightly underfit based on RMSE values

#Probability/Severity Model


run_prob_severity <- function(seed_value){
  
  cat("Probability/Severity Run Seed:", seed_value, "\n")
  
  set.seed(seed_value)
  
  trainIndex <- createDataPartition(
    hmeq$TARGET_BAD_FLAG,
    p = 0.70,
    list = FALSE
  )
  
  train <- hmeq[trainIndex, ]
  test  <- hmeq[-trainIndex, ]
  
  #Probability Tree Model
  prob_tree <- rpart(
    TARGET_BAD_FLAG ~ . - TARGET_LOSS_AMT,
    data = train,
    method = "class"
  )
  
  rpart.plot(prob_tree,
             main = paste("Probability Tree - Seed", seed_value))
  
  #Predict probability of default
  prob_default <- predict(prob_tree, test, type = "prob")[,2]
  
  #Severity Tree Model (Predict Loss Amount if Default = 1)
  train_sev <- subset(train, TARGET_BAD_FLAG == 1)
  
  sev_tree <- rpart(
    TARGET_LOSS_AMT ~ . - TARGET_BAD_FLAG,
    data = train_sev,
    method = "anova"
  )
  
  rpart.plot(sev_tree,
             main = paste("Severity Tree - Seed", seed_value))
  
  #Predict loss severity
  pred_loss <- predict(sev_tree, test)
  
  # Expected Loss Calculation
  expected_loss <- prob_default * pred_loss
  
  # RMSE Calculation
  rmse_ps <- sqrt(mean((expected_loss - test$TARGET_LOSS_AMT)^2))
  
  cat("\nRMSE for Probability/Severity Model:", rmse_ps, "\n")
  
  return(rmse_ps)
}

# Run 3 times
rmse1 <- run_prob_severity(100)
rmse2 <- run_prob_severity(200)
rmse3 <- run_prob_severity(300)

# Compare RMSE
cat("Probability/Severity RMSE Results (3 Runs)\n")

cat("Seed 100 RMSE:", rmse1, "\n")
cat("Seed 200 RMSE:", rmse2, "\n")
cat("Seed 300 RMSE:", rmse3, "\n")

cat("\nAverage RMSE:",
    mean(c(rmse1, rmse2, rmse3)),
    "\n")

#Based on RMSE numbers the model is optimal
#When comparing the Regression model and the Probability/severity model,
#the Probability/Severity model performs better and is recommended.