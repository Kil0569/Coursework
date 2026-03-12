# Read data
hmeq <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_WK02\\HMEQ_Loss.csv")

# View structure
str(hmeq)

# Summary
summary(hmeq)

# Print first six records
head(hmeq)

# Identify numeric variables
num_vars <- names(hmeq)[sapply(hmeq, is.numeric)]

# Remove target variable from numeric list
num_vars <- setdiff(num_vars, c("TARGET_BAD_FLAG", "TARGET_LOSS_AMT"))

# Create boxplot
par(mfrow = c(2, 3))
for (var in num_vars) {
  boxplot(
    hmeq[[var]] ~ hmeq$TARGET_BAD_FLAG,
    main = "Dominic Bumpus",
    xlab = "TARGET_BAD_FLAG",
    ylab = var,
    col = c("lightblue", "lightgreen")
  )
}

# Several numeric variables show noticeable differences between
# TARGET_BAD_FLAG groups, specifically in medians and spread.

# Histogram for LOAN
hist(
  hmeq$LOAN,
  breaks = 30,
  probability = TRUE,
  col = "lightgray",
  main = "Histogram of LOAN Amount",
  xlab = "LOAN"
)

# Density line
lines(density(hmeq$LOAN, na.rm = TRUE), col = "blue", lwd = 2)

# Set missing TARGET values to zero
hmeq$TARGET_BAD_FLAG[is.na(hmeq$TARGET_BAD_FLAG)] <- 0
hmeq$TARGET_LOSS_AMT[is.na(hmeq$TARGET_LOSS_AMT)] <- 0

# Identify numeric predictor variables
num_vars <- names(hmeq)[sapply(hmeq, is.numeric)]
num_vars <- setdiff(num_vars, c("TARGET_BAD_FLAG", "TARGET_LOSS_AMT"))

# Impute numeric predictor variables
for (var in num_vars) {
  
  if (any(is.na(hmeq[[var]]))) {
    
    # Create missing indicator variable
    hmeq[[paste0("M_", var)]] <- ifelse(is.na(hmeq[[var]]), 1, 0)
    
    # Median imputation
    median_value <- median(hmeq[[var]], na.rm = TRUE)
    hmeq[[paste0("IMP_", var)]] <- ifelse(
      is.na(hmeq[[var]]),
      median_value,
      hmeq[[var]]
    )
    
    # Remove original variable
    hmeq[[var]] <- NULL
  }
}

# Summary
summary(hmeq)

# Verify missing indicator counts
m_vars <- names(hmeq)[grepl("^M_", names(hmeq))]
sapply(hmeq[m_vars], sum)

# Identify character variables
cat_vars <- names(hmeq)[sapply(hmeq, is.character)]

for (var in cat_vars) {
  
  # Get unique categories
  categories <- unique(hmeq[[var]])
  
  # Create dummy variables
  for (cat in categories) {
    new_var <- paste(var, cat, sep = "_")
    hmeq[[new_var]] <- ifelse(hmeq[[var]] == cat, 1, 0)
  }
  
  # Remove original categorical variable
  hmeq[[var]] <- NULL
}

# Summary
summary(hmeq)

# Final structure verification
str(hmeq)
