# Post doc pilot

# Ricardo Rodrigues da Silveira Filho
# ricardodasilveira@gmail.com
# Aug 2022


# 0) Setup ----------------------------------------------------------------

# source("R/speciesList.R") # dealinsg with species lists
Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8") # language system


# 1) Species list ---------------------------------------------------------

# Amphibia - 1188 species
amp_splist <- readr::read_csv("data/processed/amp_splist.csv")


# 2) BOLD Systems ---------------------------------------------------------

library(bold)


## 2.1) BOLD using only Class and Country ---------------------------------

# search_AmpBr <- bold::bold_specimens(taxon = "Amphibia",
# 									 geo = "Brazil")

# readr::write_csv(search_AmpBr, "data/processed/search_AmpBr.csv")

# 3808 observations


## 2.2) BOLD by species ---------------------------------------------------

# The right name should be

res <- bold::bold_specimens(taxon = a)



purrr::map(.x = "Rhinella jimi", ~{bold::bold_specimens(taxon = .x)})


a <- c("Scinax x-signatus", "Rhinella jimi", "Rhinella granulosa", "Rhinella marina")




# X) Names correction and updates -----------------------------------------

library(taxize)















