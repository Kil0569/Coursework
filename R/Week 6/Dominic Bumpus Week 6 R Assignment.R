# Load Libraries
library(caret)
library(MASS)
library(randomForest)
library(gbm)
library(rpart)
library(rpart.plot)
library(pROC)

set.seed(12345)


# Load Data
hmeq <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_Scrubbed (2)\\HMEQ_Scrubbed.csv")

# Ensure data types
hmeq$TARGET_BAD_FLAG <- as.factor(hmeq$TARGET_BAD_FLAG)

# Remove rows with missing target values
hmeq <- hmeq[!is.na(hmeq$TARGET_BAD_FLAG), ]


# TRAIN/TEST SPLIT
train_index <- createDataPartition(hmeq$TARGET_BAD_FLAG, p = 0.7, list = FALSE)
train <- hmeq[train_index, ]
test  <- hmeq[-train_index, ]


# Logistic Regression
log_full <- glm(TARGET_BAD_FLAG ~ ., 
                data = train, 
                family = binomial)


# Backward Selection
log_backward <- stepAIC(log_full, 
                        direction = "backward", 
                        trace = FALSE)

# Forward Selection
log_null <- glm(TARGET_BAD_FLAG ~ 1, 
                data = train, 
                family = binomial)

log_forward <- stepAIC(log_null,
                       scope = list(lower = log_null, upper = log_full),
                       direction = "forward",
                       trace = FALSE)

# Display Important Variables
summary(log_backward)
summary(log_forward)

# Random Forest (Classification)
rf_class <- randomForest(TARGET_BAD_FLAG ~ ., 
                         data = train,
                         ntree = 300,
                         importance = TRUE)

varImpPlot(rf_class)

# Gradient Boosting
train_gbm <- train
train_gbm$TARGET_BAD_FLAG <- as.numeric(as.character(train_gbm$TARGET_BAD_FLAG))

gbm_class <- gbm(TARGET_BAD_FLAG ~ .,
                 data = train_gbm,
                 distribution = "bernoulli",
                 n.trees = 300,
                 interaction.depth = 3,
                 shrinkage = 0.05,
                 verbose = FALSE)

# ROC Curves
log_prob <- predict(log_backward, test, type = "response")
rf_prob  <- predict(rf_class, test, type = "prob")[,2]
gbm_prob <- predict(gbm_class, test, n.trees = 300, type = "response")

roc_log <- roc(test$TARGET_BAD_FLAG, log_prob)
roc_rf  <- roc(test$TARGET_BAD_FLAG, rf_prob)
roc_gbm <- roc(test$TARGET_BAD_FLAG, gbm_prob)

plot(roc_log, col="blue", lwd=2, main="ROC Curves")
plot(roc_rf, col="red", add=TRUE, lwd=2)
plot(roc_gbm, col="green", add=TRUE, lwd=2)

legend("bottomright",
       legend=c("Logistic","Random Forest","GBM"),
       col=c("blue","red","green"),
       lwd=2)

auc_log <- auc(roc_log)
auc_rf  <- auc(roc_rf)
auc_gbm <- auc(roc_gbm)

print(auc_log)
print(auc_rf)
print(auc_gbm)

# LINEAR REGRESSION

# Use only defaults
train_sev <- subset(train, TARGET_BAD_FLAG == 1)
test_sev  <- subset(test, TARGET_BAD_FLAG == 1)

train_sev$TARGET_BAD_FLAG <- NULL
test_sev$TARGET_BAD_FLAG  <- NULL

# Remove rows with missing loss
train_sev <- train_sev[!is.na(train_sev$TARGET_LOSS_AMT), ]
test_sev  <- test_sev[!is.na(test_sev$TARGET_LOSS_AMT), ]


# Linear Regression (Full)
lm_full <- lm(TARGET_LOSS_AMT ~ ., data=train_sev)


# Backward Selection
lm_backward <- stepAIC(lm_full, 
                       direction="backward", 
                       trace=FALSE)


# Forward Selection
lm_null <- lm(TARGET_LOSS_AMT ~ 1, data=train_sev)

lm_forward <- stepAIC(lm_null,
                      scope=list(lower=lm_null, upper=lm_full),
                      direction="forward",
                      trace=FALSE)

summary(lm_backward)
summary(lm_forward)


# RMSE Function
rmse <- function(actual, predicted){
  sqrt(mean((actual - predicted)^2))
}

# Predictions
pred_full <- predict(lm_full, test_sev)
pred_back <- predict(lm_backward, test_sev)
pred_forw <- predict(lm_forward, test_sev)

rmse_full <- rmse(test_sev$TARGET_LOSS_AMT, pred_full)
rmse_back <- rmse(test_sev$TARGET_LOSS_AMT, pred_back)
rmse_forw <- rmse(test_sev$TARGET_LOSS_AMT, pred_forw)

print(rmse_full)
print(rmse_back)
print(rmse_forw)


# PROBABILITY / SEVERITY MODEL

# Probability of Default
prob_default <- predict(log_backward, test, type="response")
summary(log_backward)

# Severity Prediction (Linear model)
sev_pred <- predict(lm_backward, test)

sev_pred[is.na(sev_pred)] <- 0
summary(log_backward)

# Expected Loss
expected_loss <- prob_default * sev_pred

# RMSE for Probability/Severity Model
rmse_ps <- rmse(test$TARGET_LOSS_AMT, expected_loss)

print(rmse_ps)