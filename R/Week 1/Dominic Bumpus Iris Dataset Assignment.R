# Iris Dataset
data(iris)

# Dataset Structure
str(iris)

# Iris Summary
summary(iris)

# Records
head(iris)

# Box plot of Sepal Length by Species
boxplot(
  Sepal.Length ~ Species,
  data = iris,
  main = "Dominic Bumpus",
  xlab = "Species",
  ylab = "Sepal Length",
  notch = TRUE, 
  col = c("lightblue", "lightgreen", "lightpink")
)


# Histogram
hist(
  iris$Sepal.Length,
  breaks = 15,
  probability = TRUE,
  col = "purple",
  border = "black",
  main = "Histogram of Sepal Length",
  xlab = "Sepal Length"
)

# Density curve
lines(
  density(iris$Sepal.Length),
  lwd = 2
)

# Assign colors
species_colors <- c("red", "blue", "darkgreen")

# Scatter plot
plot(
  iris$Sepal.Length,
  iris$Sepal.Width,
  col = species_colors[iris$Species],
  pch = 16,
  main = "Sepal Length vs Sepal Width",
  xlab = "Sepal Length",
  ylab = "Sepal Width"
)

# Legend
legend(
  "topright",
  legend = levels(iris$Species),
  col = species_colors,
  pch = 16
)

# Mean of Sepal Length
mean(iris$Sepal.Length)

# Median of Sepal Length
median(iris$Sepal.Length)

# Minimum of Sepal Length
min(iris$Sepal.Length)

# Maximum of Sepal Length
max(iris$Sepal.Length)

# Standard Deviation of Sepal Length
sd(iris$Sepal.Length)

# Median Sepal Length for each Species
species_medians <- aggregate(
  Sepal.Length ~ Species,
  data = iris,
  FUN = median
)

# Sort medians
species_medians[order(-species_medians$Sepal.Length), ]
