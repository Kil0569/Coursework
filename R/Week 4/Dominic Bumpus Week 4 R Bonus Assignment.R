# Load required libraries
library(ggplot2)
library(dplyr)

# Load the dataset
hmeq <- read.csv("C:\\Users\\Wolfh\\Downloads\\HMEQ_Scrubbed\\HMEQ_Scrubbed.csv")

# Loan Amount Distribution
# This histogram shows how loan amounts are distributed.
# Most customers request smaller loans, while fewer request large loans.
#This shows that while higher loans may have more value with interest rates
#the smaller loans can beat it with economy of scale

ggplot(hmeq, aes(x = LOAN)) +
  geom_histogram(bins = 40) +
  labs(
    title = "Distribution of Loan Amounts",
    x = "Loan Amount ($)",
    y = "Number of Customers"
  )

# Loan Amount vs Default Risk
# This boxplot compares loan sizes for customers who defaulted
# versus those who did not. This shows whether higher loan
# amounts are linked to higher risk.

ggplot(hmeq, aes(x = factor(TARGET_BAD_FLAG), y = LOAN)) +
  geom_boxplot() +
  labs(
    title = "Loan Amounts by Default Status",
    x = "Default Flag (0 = No Default, 1 = Default)",
    y = "Loan Amount ($)"
  )


# Home Value vs Mortgage Due
# This scatter plot shows the relationship between home value
# and mortgage amount due. Higher home values generally
# correspond to larger mortgage balances.

ggplot(hmeq, aes(x = IMP_VALUE, y = IMP_MORTDUE)) +
  geom_point(alpha = 0.4) +
  labs(
    title = "Mortgage Due vs Home Value",
    x = "Home Value ($)",
    y = "Mortgage Due ($)"
  )