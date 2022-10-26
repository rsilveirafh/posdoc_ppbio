# Post doc pilot

# Ricardo Rodrigues da Silveira Filho
# ricardodasilveira@gmail.com
# Aug 2022


# 0) Setup ----------------------------------------------------------------

# source("R/speciesList.R") # dealing with species lists
Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8") # language system


# 1) Species list ---------------------------------------------------------

# Amphibia - 1188 species
amp_splist <- readr::read_csv("data/processed/amp_splist.csv")


# 2) BOLD Systems ---------------------------------------------------------

library(bold)


## 2.1) BOLD using only Class and Country ---------------------------------

# search_amp_br <- bold::bold_specimens(taxon = "Amphibia",
#                                       geo = "Brazil")

# readr::write_csv(search_amp_br, "data/processed/search_amp_br.csv")

# 3808 observations


## 2.2) BOLD by species ---------------------------------------------------

source("R/bold_onebyone.R")

search_amp_spp <- bold_onebyone(amp_splist, speciesvar = "species")



# X) Names correction and updates -----------------------------------------

library(taxize)















