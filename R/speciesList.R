# Species List

# Ricardo Rodrigues da Silveira Filho
# ricardodasilveira@gmail.com



# 0) Setup ----------------------------------------------------------------

# library(dplyr)
# library(here)
# library(janitor)
# library(readr)
# library(readxl)



# 1) Anfíbios -------------------------------------------------------------

# Segalla, M; Berneck, B.;Canedo, C.; Caramaschi, U.; Cruz, C.A.G.; Garcia, P. C. A.; Grant, T.; Haddad, C. F. B.; Lourenço, A. C.; Mangia, S.; Mott, T.; Nascimento, L. Toledo, L. F.; Werneck, F.; Langone, J. A. (2021). List of Brazilian Amphibians. Herpetologia Brasileira, 10(1), 121–216. https://doi.org/10.5281/zenodo.4716176

# Package {amphiBR}
# devtools::install_github('paulobarros/amphiBR')

amphibians_splist <- amphiBR::segalla2021 |> 
    dplyr::mutate(species_id = paste0("amp_", 1:length(species_id))) |>
    dplyr::select(species_id, 
                  species,
                  order, 
                  family, 
                  subfamily, 
                  genus, 
                  epithet, 
                  author, 
                  common_name_br, 
                  category_iucn = category, 
                  endemic_br)

# readr::write_csv(amphibians_splist, here::here("data/processed/amphibians_splist.csv"))



# 2) Aves -----------------------------------------------------------------

## Comitê Brasileiro de Registros Ornitológicos
# Pacheco, J.F., Silveira, L.F., Aleixo, A. et al. 2021. Annotated checklist of the birds of Brazil by the Brazilian Ornithological Records Committee—second edition. Ornithol. Res. 29, 94–105. https://doi.org/10.1007/s43388-021-00058-x
## http://www.cbro.org.br/listas/

# Download do arquivo
# download.file(url = "https://zenodo.org/record/5138368/files/2021.07.26%20CBRO%202021%20Zenodo%20Release.xlsx?download=1",
#               destfile = "data/raw/2021_birds_brazil.xlsx")

birds_raw <- readxl::read_xlsx(here::here("data/raw/2021_birds_brazil.xlsx"),
                                  sheet = "Lista Primária")

birds_splist <- birds_raw |>
    janitor::clean_names() |> 
    dplyr::filter(!categoria %in% c("Parvordem", "Ordem", "Subordem", 
                                    "Infraordem", "Superfamília", "Família", 
                                    "Subfamília", "Gênero", "Subespécie")) |> 
    dplyr::mutate(species_id = paste0("bir_", 1:length(number)),
                  author = stringr::str_remove(nome_do_taxon_com_autoria, "^\\w+\\s\\w+\\s")) |>
    tibble::add_column(endemic_br = NA_character_) |> 
    dplyr::select(species_id,
                  species = nome_do_taxon_sem_autoria, 
                  order = ordem, 
                  family = familia, 
                  subfamily = subfamilia, 
                  genus = genero, 
                  epithet = especie, 
                  author, 
                  common_name_br = nome_em_portugues, 
                  category_iucn = status, # a modificar 
                  endemic_br) # a modificar
    
# readr::write_csv(birds_splist, here::here("data/processed/birds_splist.csv"))



# 3) Mamíferos ------------------------------------------------------------

## Sociedade Brasileira de Mastozoologia
# Abreu EF, Casali D, Costa-Araújo R, Garbino GST, Libardi GS, Loretto D, Loss AC, Marmontel M, Moras LM, Nascimento MC, Oliveira ML, Pavan SE, & Tirelli FP. 2022. Lista de Mamíferos do Brasil (2022-1) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.7469767
## https://sbmz.org/mamiferos-do-brasil/

# download.file(url = "https://zenodo.org/record/7469767/files/Mammalia_SBMz_v2022-1_Dez.xlsx?download=1",
#               destfile = "data/raw/2022_mammals_brazil.xlsx")

mammals_raw <- readxl::read_xlsx(here::here("data/raw/2022_mammals_brazil.xlsx"))

mammals_splist <- mammals_raw |> 
    janitor::clean_names() |> 
    dplyr::mutate(species_id = paste0("mam_", 1:length(ordem)),
                  author = stringr::str_squish(binomio_autor),
                  author = stringr::str_extract(author, paste0(especie, ".*")),
                  author = stringr::str_remove(author, "\\w+\\s")) |> 
    tibble::add_column(category_iucn = NA_character_,
                       endemic_br = NA_character_) |> 
    dplyr::select(species_id, 
                  species = binomio,
                  order = ordem, 
                  family = familia, 
                  subfamily = subfamilia, 
                  genus = genero, 
                  epithet = especie, 
                  author, 
                  common_name_br = nome_comum, 
                  category_iucn, # a modificar
                  endemic_br) # a modificar  

# readr::write_csv(mammals_splist, here::here("data/processed/mammals_splist.csv"))



# 4) Peixes ---------------------------------------------------------------

## https://www.fishbase.se/search.php
## https://github.com/ropensci/rfishbase

library(rfishbase)

fish <- rfishbase::load_taxa(server = "fishbase")
fishsea <- rfishbase::load_taxa(server = "sealifebase")

fish_species <- rfishbase::species(server = "fishbase")
fishsea_species <- rfishbase::species(server = "sealifebase")

fish_br <- rfishbase::country(server = "fishbase") |> 
    dplyr::filter(country == "Brazil")
fishsea_br <- rfishbase::country(server = "sealifebase") |> 
    dplyr::filter(country == "Brazil")

location <- rfishbase::sci_to_common(Language = "Portuguese")





# 4) Répteis --------------------------------------------------------------

## Guedes, T. B., Entiauspe-Neto, O. M., & Costa, H. C. (2023). Lista de répteis do Brasil: atualização de 2022. https://doi.org/10.5281/zenodo.7829013

# download.file(url = "https://zenodo.org/record/7829013/files/Guedes2023_HB12-01_Lista%20de%20repteis.pdf?download=1",
#               destfile = "data/raw/2023_reptiles_brazil.pdf")






# 5) Unindo os dados ------------------------------------------------------

splist <- dplyr::bind_rows(amphibians_splist,
                           birds_splist,
                           mammals_splist)

# readr::write_csv(splist, here::here("data/processed/splist.csv"))

splist <- readr::read_csv("data/processed/splist.csv")





# 6) BOLD -----------------------------------------------------------------

source(here::here("R/bold_onebyone.R"))

# sp_bold <- bold_onebyone(data = splist, 
#                          species = "species")

readr::write_csv(sp_bold, "data/processed/amp_bir_mam_bold.csv")







