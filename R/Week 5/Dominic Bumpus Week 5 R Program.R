library(rpart)
library(rpart.plot)
library(randomForest)
library(gbm)
library(pROC)
library(caret)

# READ DATA
data <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_Scrubbed (2)\\HMEQ_Scrubbed.csv")

cat("STRUCTURE OF DATA\n")
print(str(data))

cat("\nSUMMARY OF DATA\n")
print(summary(data))

cat("\nFIRST 6 ROWS\n")
print(head(data))

# CLASSIFICATION MODEL
cat("\nCLASSIFICATION\n")

# Convert TARGET_BAD_FLAG to factor for classification
data$TARGET_BAD_FLAG_FACTOR <- as.factor(data$TARGET_BAD_FLAG)

# Store results
results_class <- data.frame(
  Run = integer(),
  Tree_AUC = numeric(),
  RF_AUC = numeric(),
  GBM_AUC = numeric()
)

for(i in 1:3){
  set.seed(100 + i)
  
  # Split data differently for each run
  trainIndex <- createDataPartition(data$TARGET_BAD_FLAG_FACTOR, p=0.7, list=FALSE)
  train_class <- data[trainIndex, ]
  test_class  <- data[-trainIndex, ]
  
  # Decision Tree
  tree_class <- rpart(TARGET_BAD_FLAG_FACTOR ~ . - TARGET_BAD_FLAG, data=train_class, method="class")
  tree_imp <- tree_class$variable.importance
  cat("\nDecision Tree Variable Importance (Run", i, "):\n")
  print(tree_imp)
  
  # Random Forest
  rf_class <- randomForest(TARGET_BAD_FLAG_FACTOR ~ . - TARGET_BAD_FLAG, data=train_class, importance=TRUE)
  rf_imp <- importance(rf_class)
  cat("\nRandom Forest Variable Importance (Run", i, "):\n")
  print(rf_imp)
  
  # Gradient Boosting
  gbm_class <- gbm(
    as.numeric(as.character(TARGET_BAD_FLAG_FACTOR)) ~ . - TARGET_BAD_FLAG,
    data=train_class,
    distribution="bernoulli",
    n.trees=200,
    interaction.depth=3,
    shrinkage=0.05,
    verbose=FALSE
  )
  gbm_imp <- summary(gbm_class, plotit = FALSE)
  cat("\nGBM Variable Importance (Run", i, "):\n")
  print(gbm_imp)
  
  # Predictions
  tree_prob <- predict(tree_class, test_class, type="prob")[, "1"]
  rf_prob   <- predict(rf_class, test_class, type="prob")[, "1"]
  gbm_prob  <- predict(gbm_class, test_class, n.trees=200, type="response")
  
  # ROC & AUC
  roc_tree <- roc(test_class$TARGET_BAD_FLAG, tree_prob)
  roc_rf   <- roc(test_class$TARGET_BAD_FLAG, rf_prob)
  roc_gbm  <- roc(test_class$TARGET_BAD_FLAG, gbm_prob)
  
  # Store results
  results_class <- rbind(results_class, data.frame(
    Run = i,
    Tree_AUC = auc(roc_tree),
    RF_AUC   = auc(roc_rf),
    GBM_AUC  = auc(roc_gbm)
  ))
  
  # Plot ROC
  if(i==1){
    plot(roc_tree, col="blue", main="ROC Curves Run 1")
    plot(roc_rf, col="red", add=TRUE)
    plot(roc_gbm, col="green", add=TRUE)
    legend("bottomright", legend=c("Tree","Random Forest","GBM"), col=c("blue","red","green"), lwd=2)
  }
}

cat("\nCLASSIFICATION RESULTS:\n")
print(results_class)
cat("\nAverage AUCs across runs:\n")
print(colMeans(results_class[,2:4]))

# REGRESSION MODELS
cat("\nREGRESSION\n")
results_reg <- data.frame(
  Run = integer(),
  Tree_RMSE = numeric(),
  RF_RMSE = numeric(),
  GBM_RMSE = numeric()
)

for(i in 1:3){
  set.seed(200 + i)
  
  # Regression target is numeric
  trainIndex <- createDataPartition(data$TARGET_LOSS_AMT, p=0.7, list=FALSE)
  train_reg <- data[trainIndex, ]
  test_reg  <- data[-trainIndex, ]
  
  # Decision Tree Regression
  tree_reg <- rpart(TARGET_LOSS_AMT ~ . - TARGET_BAD_FLAG - TARGET_BAD_FLAG_FACTOR, data=train_reg, method="anova")
  tree_pred <- predict(tree_reg, test_reg)
  
  # Random Forest Regression
  rf_reg <- randomForest(TARGET_LOSS_AMT ~ . - TARGET_BAD_FLAG - TARGET_BAD_FLAG_FACTOR, data=train_reg)
  rf_pred <- predict(rf_reg, test_reg)
  
  # GBM Regression
  gbm_reg <- gbm(TARGET_LOSS_AMT ~ . - TARGET_BAD_FLAG - TARGET_BAD_FLAG_FACTOR,
                 data=train_reg, distribution="gaussian",
                 n.trees=200, interaction.depth=3, shrinkage=0.05, verbose=FALSE)
  gbm_pred <- predict(gbm_reg, test_reg, n.trees=200)
  
  # RMSE
  tree_rmse <- sqrt(mean((test_reg$TARGET_LOSS_AMT - tree_pred)^2))
  rf_rmse   <- sqrt(mean((test_reg$TARGET_LOSS_AMT - rf_pred)^2))
  gbm_rmse  <- sqrt(mean((test_reg$TARGET_LOSS_AMT - gbm_pred)^2))
  
  results_reg <- rbind(results_reg, data.frame(
    Run=i, Tree_RMSE=tree_rmse, RF_RMSE=rf_rmse, GBM_RMSE=gbm_rmse
  ))
}

print(results_reg)
cat("\nAVERAGE REGRESSION RMSE:\n")
print(colMeans(results_reg[,2:4]))

# PROBABILITY × SEVERITY MODEL
cat("\nPROBABILITY / SEVERITY MODEL\n")
results_ps <- data.frame(
  Run = integer(),
  Tree_Severity_RMSE = numeric(),
  RF_Severity_RMSE = numeric(),
  GBM_Severity_RMSE = numeric(),
  PS_Model_RMSE = numeric()
)

for(i in 1:3){
  set.seed(400 + i)
  
  # Split data
  trainIndex <- createDataPartition(data$TARGET_BAD_FLAG_FACTOR, p=0.7, list=FALSE)
  train <- data[trainIndex, ]
  test  <- data[-trainIndex, ]
  
  # Probability Model (classification)
  prob_model <- randomForest(TARGET_BAD_FLAG_FACTOR ~ . - TARGET_LOSS_AMT - TARGET_BAD_FLAG, data=train, importance=TRUE)
  prob_scores <- predict(prob_model, test, type="prob")[, "1"]
  
  # Severity Models (subset where default occurs)
  train_sev <- subset(train, TARGET_BAD_FLAG == 1)
  test_sev  <- subset(test, TARGET_BAD_FLAG == 1)
  
  # Decision Tree Severity
  tree_sev <- rpart(TARGET_LOSS_AMT ~ . - TARGET_BAD_FLAG - TARGET_BAD_FLAG_FACTOR, data=train_sev, method="anova")
  tree_pred <- predict(tree_sev, test_sev)
  tree_rmse <- sqrt(mean((test_sev$TARGET_LOSS_AMT - tree_pred)^2))
  
  # Random Forest Severity
  rf_sev <- randomForest(TARGET_LOSS_AMT ~ . - TARGET_BAD_FLAG - TARGET_BAD_FLAG_FACTOR, data=train_sev)
  rf_pred <- predict(rf_sev, test_sev)
  rf_rmse <- sqrt(mean((test_sev$TARGET_LOSS_AMT - rf_pred)^2))
  
  # GBM Severity
  gbm_sev <- gbm(TARGET_LOSS_AMT ~ . - TARGET_BAD_FLAG - TARGET_BAD_FLAG_FACTOR, data=train_sev,
                 distribution="gaussian", n.trees=200, interaction.depth=3, shrinkage=0.05, verbose=FALSE)
  gbm_pred <- predict(gbm_sev, test_sev, n.trees=200)
  gbm_rmse <- sqrt(mean((test_sev$TARGET_LOSS_AMT - gbm_pred)^2))
  
  # Choose best severity model
  rmse_values <- c(tree_rmse, rf_rmse, gbm_rmse)
  best_index <- which.min(rmse_values)
  
  if(best_index == 1){ sev_scores <- predict(tree_sev, test) }
  if(best_index == 2){ sev_scores <- predict(rf_sev, test) }
  if(best_index == 3){ sev_scores <- predict(gbm_sev, test, n.trees=200) }
  
  # Probability × Severity
  expected_loss <- prob_scores * sev_scores
  ps_rmse <- sqrt(mean((test$TARGET_LOSS_AMT - expected_loss)^2))
  
  results_ps <- rbind(results_ps, data.frame(
    Run=i,
    Tree_Severity_RMSE=tree_rmse,
    RF_Severity_RMSE=rf_rmse,
    GBM_Severity_RMSE=gbm_rmse,
    PS_Model_RMSE=ps_rmse
  ))
}

cat("FINAL RESULTS\n")
print(results_ps)
cat("\nAVERAGE Probability × Severity RMSE:\n")
print(mean(results_ps$PS_Model_RMSE))
