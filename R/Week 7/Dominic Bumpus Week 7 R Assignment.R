library(caret)
library(MASS)
library(randomForest)
library(gbm)
library(rpart)
library(rpart.plot)
library(pROC)
library(Rtsne)

set.seed(12345)

# LOAD DATA
hmeq <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_Scrubbed (2)\\HMEQ_Scrubbed.csv")

hmeq$TARGET_BAD_FLAG <- as.factor(hmeq$TARGET_BAD_FLAG)
hmeq <- hmeq[!is.na(hmeq$TARGET_BAD_FLAG), ]

# PCA ANALYSIS
# Use only continuous variables
cont_vars <- hmeq[, sapply(hmeq, is.numeric)]

# Remove target variables
cont_vars$TARGET_BAD_FLAG <- NULL
cont_vars$TARGET_LOSS_AMT <- NULL

# Remove missing values
cont_vars <- na.omit(cont_vars)

# PCA
pca_model <- prcomp(cont_vars, scale = TRUE)

# Scree Plot
plot(pca_model, type="l", main="Scree Plot")

# Print PCA Weights
summary(pca_model)
print(pca_model$rotation)

# Use first 2 principal components
pca_data <- as.data.frame(pca_model$x[,1:2])
colnames(pca_data) <- c("PC1","PC2")

# Merge target flag
pca_data$TARGET_BAD_FLAG <- hmeq$TARGET_BAD_FLAG[rownames(pca_data)]

# Scatter Plot
plot(pca_data$PC1, pca_data$PC2,
     col=as.numeric(pca_data$TARGET_BAD_FLAG)+1,
     pch=19,
     main="PCA Plot")


# tSNE ANALYSIS
# Perplexity = 30
tsne_30 <- Rtsne(cont_vars, dims=2, perplexity=30, verbose=TRUE)

# Perplexity > 30
tsne_high <- Rtsne(cont_vars, dims=2, perplexity=50, verbose=TRUE)

# Perplexity < 30
tsne_low <- Rtsne(cont_vars, dims=2, perplexity=10, verbose=TRUE)

# Plot tSNE (30)
plot(tsne_30$Y,
     col=as.numeric(hmeq$TARGET_BAD_FLAG[rownames(cont_vars)])+1,
     pch=19,
     main="tSNE Perplexity 30")

# Append best tSNE (choose visually best — example uses 30)
hmeq$TSNE1 <- tsne_30$Y[,1]
hmeq$TSNE2 <- tsne_30$Y[,2]

# Random Forest predicting tSNE values
rf_tsne1 <- randomForest(TSNE1 ~ ., data=hmeq)
rf_tsne2 <- randomForest(TSNE2 ~ ., data=hmeq)


#TREE + LOGISTIC ON ORIGINAL DATA
# Decision Tree
tree_model <- rpart(TARGET_BAD_FLAG ~ ., data=hmeq, method="class")
rpart.plot(tree_model)

# Logistic Regression
log_full <- glm(TARGET_BAD_FLAG ~ ., data=hmeq, family=binomial)
log_step <- stepAIC(log_full, direction="both", trace=FALSE)

summary(log_step)

# ROC + AUC
log_prob <- predict(log_step, hmeq, type="response")
roc_log <- roc(hmeq$TARGET_BAD_FLAG, log_prob)
plot(roc_log, col="blue", main="ROC Original Data")
auc_original <- auc(roc_log)
print(auc_original)


# TREE + LOGISTIC ON PCA/tSNE DATA
# Append PCA components
hmeq$PC1 <- pca_model$x[,1]
hmeq$PC2 <- pca_model$x[,2]

# Remove original continuous variables
hmeq_reduced <- hmeq
hmeq_reduced[, sapply(hmeq_reduced, is.numeric)] <- NULL

# Keep target + flags + PC + TSNE
hmeq_reduced$TARGET_BAD_FLAG <- hmeq$TARGET_BAD_FLAG
hmeq_reduced$PC1 <- hmeq$PC1
hmeq_reduced$PC2 <- hmeq$PC2
hmeq_reduced$TSNE1 <- hmeq$TSNE1
hmeq_reduced$TSNE2 <- hmeq$TSNE2

# Decision Tree
tree_pca <- rpart(TARGET_BAD_FLAG ~ ., data=hmeq_reduced, method="class")
rpart.plot(tree_pca)

# Logistic Regression
log_pca <- glm(TARGET_BAD_FLAG ~ ., data=hmeq_reduced, family=binomial)
log_pca_step <- stepAIC(log_pca, direction="both", trace=FALSE)

summary(log_pca_step)

# ROC + AUC
log_pca_prob <- predict(log_pca_step, hmeq_reduced, type="response")
roc_pca <- roc(hmeq_reduced$TARGET_BAD_FLAG, log_pca_prob)
plot(roc_pca, col="red", main="ROC PCA/tSNE Data")
auc_pca <- auc(roc_pca)
print(auc_pca)


# COMMENT 

cat("AUC Original Data:", auc_original, "\n")
cat("AUC PCA/tSNE Data:", auc_pca, "\n")