# Post doc pilot

# Ricardo Rodrigues da Silveira Filho
# ricardodasilveira@gmail.com
# Aug 2022


# 0) Setup ----------------------------------------------------------------

# source("R/speciesList.R") # dealing with species lists
Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8") # language system

# packages
library(bold)
library(tidyverse)


# 1) Species list ---------------------------------------------------------

# Amphibia - 1188 species
source("R/insert_amp.R")
amp_splist <- readr::read_csv("data/processed/amp_splist.csv") |> 
    rows_insert(x = _, insert_amp, by = "id_list")


# 2) BOLD Systems ---------------------------------------------------------

library(bold)


## 2.1) BOLD using only Class and Country ---------------------------------

# search_amp_br <- bold::bold_specimens(taxon = "Amphibia",
#                                       geo = "Brazil")

# readr::write_csv(search_amp_br, "data/processed/search_amp_br.csv")

# 3808 observations

search_amp_br <- readr::read_csv("data/processed/search_amp_br.csv")


## 2.2) BOLD by species ---------------------------------------------------

source("R/bold_onebyone.R")

# search_amp_spp <- bold_onebyone(amp_splist, species = "species")

# readr::write_csv(search_amp_spp, "data/processed/search_amp_spp.csv")

# 4214 observations

search_amp_spp <- readr::read_csv("data/processed/search_amp_spp.csv")

search_amp_spp |> 
    count(species_name) |> 
    arrange(desc(n)) |> 
    View()


# X) Names correction and updates -----------------------------------------

library(taxize)















