# Install dplyr
library("dplyr")

# Load data file
refine_original <- read.csv("~/Data/refine_original.csv", sep=";")
colnames(refine_original) <- c("Input_company", "Product_Code_Number", "Address", "City", "Country", "Name")

# Correct company names
# Get distinct list of input company spellings
comp_spells <- levels(refine_original$Input_company)
comp_spells

# Make dataframe of correction values
corr_spells <- c("akzo", "akzo", "akzo", "akzo", "akzo", 
                 "philips", "philips", "philips", "philips", "philips", "philips", "philips", "philips", 
                 "unilever", "unilever", "unilever",
                 "van houten", "van houten", "van houten")
corr_comps <- data.frame(comp_spells, corr_spells)
# Check that the correspondence is right
colnames(corr_comps) <- c("Input_company", "Company")
corr_comps

# Add new company field with correct spelling
refine_wip <- left_join(refine_original, corr_comps, by = "Input_company")

# Add product_code column and product_number column
refine_wip <- mutate(refine_wip, Product_Code = substr(refine_wip$Product_Code_Number, 1, 1), 
                     Product_Number = substr(refine_wip$Product_Code_Number, 3, 5))


# Add product_category column
prod_cat <- data.frame( c("p", "q", "v", "x"), c("Smartphone", "Tablet", "TV", "Laptop"))
colnames(prod_cat) <- c("Product_Code", "Product_Category")
refine_wip <- left_join(refine_wip, prod_cat, by = "Product_Code")


# Add full_address column
refine_wip <- mutate(refine_wip, Full_Address = paste(refine_wip$Address, refine_wip$City, refine_wip$Country, sep = ", "))

# Set binary fields for Company
refine_wip <- mutate(refine_wip, company_akzo = ifelse(refine_wip$Company == "akzo", 1, 0),
                     company_philips = ifelse(refine_wip$Company == "philips", 1, 0),
                     company_unilever = ifelse(refine_wip$Company == "unilever", 1, 0),
                     company_vanhouten = ifelse(refine_wip$Company == "van houten", 1, 0))

# Set binary fields for Product Category
refine_wip <- mutate(refine_wip, product_smartphone = ifelse(refine_wip$Product_Category == "Smartphone", 1, 0),
                     product_tv = ifelse(refine_wip$Product_Category == "TV", 1, 0),
                     product_laptop = ifelse(refine_wip$Product_Category == "Laptop", 1, 0),
                     product_tablet = ifelse(refine_wip$Product_Category == "Tablet", 1, 0))
refine_clean <- refine_wip
refine_clean

# Save data file
write.csv(refine_clean, "~/Data/refine_clean.csv")



