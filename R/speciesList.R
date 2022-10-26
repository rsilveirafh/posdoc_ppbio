# Species List

# Ricardo Rodrigues da Silveira Filho
# ricardodasilveira@gmail.com
# Aug 2022


# 0) Setup ----------------------------------------------------------------

library(dplyr)
library(pdftools)
library(readr)
library(stringr)


# 1) Amphibia - Brazil ----------------------------------------------------

## Article:
# Segalla, M; Berneck, B.;Canedo, C.; Caramaschi, U.; Cruz, C.A.G.; Garcia, P. C. A.; Grant, T.; Haddad, C. F. B.; Lourenço, A. C.; Mangia, S.; Mott, T.; Nascimento, L. Toledo, L. F.; Werneck, F.; Langone, J. A. (2021). List of Brazilian Amphibians. Herpetologia Brasileira, 10(1), 121–216. https://doi.org/10.5281/zenodo.4716176

## Download file:
# download.file(url = "https://zenodo.org/record/4716176/files/Segalla_et_al_2021_HB.pdf?download=1",
# 			  destfile = "data/raw/Segalla et al. 2021 - Amphibia.pdf",
# 			  mode = "wb")

# Wrangling pdf
amp_splist <- pdftools::pdf_text(here::here("data/raw/Segalla et al. 2021 - Amphibia.pdf")) %>%
	readr::read_lines(.) %>%
	dplyr::as_tibble(., .name_repair = "minimal") %>%
	dplyr::mutate(value = stringr::str_replace(value, "225", "225."),
		   value = stringr::str_replace(value, "3547", "347."),
		   value = stringr::str_replace(value, "6797", "677."),
		   value = stringr::str_replace(value, "10343", "1033.")) %>%
	dplyr::filter(stringr::str_detect(value, "^\\s{1,}\\d{1,4}\\.")) %>%
	dplyr::mutate(value = stringr::str_squish(value),
				  value = stringr::str_replace(value, "\\. ", "/")) %>%
	tidyr::separate(col = value,
					into = c("id_list", "species"),
					sep = "/") %>%
	dplyr::mutate(species = stringr::str_extract(species, "\\w+\\s\\w+\\-?\\w+")) %>%
	tidyr::separate(col = species,
					into = c("gender", "epithet"),
					sep = " ",
					remove = FALSE)

## Saving csv file
# readr::write_csv(amp_splist, here::here("data/processed/amp_splist.csv"))









