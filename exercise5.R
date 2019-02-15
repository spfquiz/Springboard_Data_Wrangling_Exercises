# Install dplyr
library("dplyr")

# Load data file
titanic_wip <- read.csv("~/Data/exercises/titanic_original.csv", sep=";")
str(titanic_wip)

# Update port of embarcation
# Check format of blanks
levels(titanic_wip$embarked)

# Assign "S" for all blanks in embarked
levels(titanic_wip$embarked)[levels(titanic_wip$embarked) == ""] <- "S"

# Set blank Ages to the mean
# Calculate the mean (excluding blanks)
summarise(titanic_wip, avg = mean(titanic_wip$age, na.rm = TRUE))
avg_age <- summarise(titanic_wip, avg = mean(titanic_wip$age, na.rm = TRUE))
avg_age

# Update NA Ages with mean
titanic_wip$age <- as.numeric(ifelse(is.na(titanic_wip$age), avg_age, titanic_wip$age))

# What would the other options be for updating the blank Ages?

# Where sibsp > 1 we know that the person must be a child and could use this mean instead
# Where parch > 2 we know that the person must be a parent and could use this mean instead

# Alternatively we could group by "Miss", "Mrs", "Master" and "Mr" from the name field and create
# means on each of them

# Assign NA for all blank values in the boat field
levels(titanic_wip$boat)[levels(titanic_wip$boat) == ""] <- "NA"

# What does a blank cabin number mean?
# To me it doesn't make sense to replace empty cabin numbers with a value - these are discrete values
# Apparently the cabin number data either comes from a list found in the pocket of a steward showing first class 
# or from a limited number of surviving boarding cards or stubs

# Create has_cabin_number binary field
titanic_wip <- mutate(titanic_wip, has_cabin_number = ifelse(titanic_wip$cabin == "", 0, 1))
titanic_clean <- titanic_wip
titanic_clean

# Save data file
write.csv(titanic_clean, "~/Data/exercises/titanic_clean.csv")
