# Load Libraries
library(ggplot2)
library(dplyr)
library(caret)
library(cluster)
library(factoextra)
library(rpart)
library(rpart.plot)

set.seed(12345)

# Load Data
hmeq <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_Scrubbed (2)\\HMEQ_Scrubbed.csv")

# Remove target variables
hmeq_input <- hmeq %>%
  select(-TARGET_BAD_FLAG, -TARGET_LOSS_AMT)

# Keep only numeric continuous variables
hmeq_input <- hmeq_input %>%
  select(where(is.numeric))

# PCA Analysis
# Scale the data
hmeq_scaled <- scale(hmeq_input)

# Run PCA
pca_model <- prcomp(hmeq_scaled, center = TRUE, scale. = TRUE)

# Summary
summary(pca_model)

# Scree Plot
fviz_eig(pca_model)

# Print PCA loadings
print(pca_model$rotation)

# Extract first two PCs
pca_data <- as.data.frame(pca_model$x[,1:2])
colnames(pca_data) <- c("PC1", "PC2")

# Plot PCA
ggplot(pca_data, aes(x=PC1, y=PC2)) +
  geom_point(color="black") +
  ggtitle("PCA Plot (PC1 vs PC2)")


# Find Optimal Number of Clusters
wss <- vector()

for (i in 1:10) {
  kmeans_model <- kmeans(pca_data, centers=i, nstart=25)
  wss[i] <- kmeans_model$tot.withinss
}

plot(1:10, wss, type="b", pch=19,
     xlab="Number of Clusters",
     ylab="Within Sum of Squares")

# Cluster Analysis
# Choose optimal clusters (example: 3)
k_optimal <- 3

kmeans_final <- kmeans(pca_data, centers=k_optimal, nstart=25)

# Add cluster to data
pca_data$cluster <- as.factor(kmeans_final$cluster)

# Print cluster sizes
print(table(pca_data$cluster))

# Plot clusters
ggplot(pca_data, aes(x=PC1, y=PC2, color=cluster)) +
  geom_point() +
  ggtitle("Cluster Plot using PC1 and PC2")


# Determine if clusters predict default
cluster_default <- data.frame(
  cluster = pca_data$cluster,
  default = hmeq$TARGET_BAD_FLAG
)

print(table(cluster_default$cluster, cluster_default$default))


# Decision Tree to Predict Cluster
hmeq_for_tree <- hmeq_input
hmeq_for_tree$cluster <- pca_data$cluster

tree_model <- rpart(cluster ~ ., data=hmeq_for_tree, method="class")

rpart.plot(tree_model)