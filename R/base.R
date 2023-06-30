# 0) Description ----------------------------------------------------------

# R Script with general functions to access BOLD Systems

# Created by Ricardo da Silveira Filho
# E-mail: ricardodasilveira@gmail.com
# May 25th 2022


# 1) Setup ----------------------------------------------------------------

library(bold) # Functions to access BOLD Systems db
library(taxize) # Taxonomic information tool
library(tidyverse) # Data wrangling


# 2) Access BOLD database -------------------------------------------------

# dataAmp <- bold::bold_specimens(taxon = "Amphibia")

# readr::write_csv(dataAmp, "data/raw/amphibia_bold_data.csv")

dataAmp <- readr::read_csv("data/raw/amphibia_bold_data.csv")


# 3) Data Wrangling -------------------------------------------------------

dataAmp %>%
	glimpse()

br_dataAmp <- dataAmp %>%
	filter(country == "Brazil",
		   lat < 5)



# 4) Taxonomic checking --------------------------------------------------

# List of supported db APIs
sup_api <- gnr_datasources()

# For amphibians:
# 118 - AmphibiaWeb
# 132 - ZooBank

br_dataAmpTax <- br_dataAmp$species_name %>%
	gnr_resolve(data_source_ids = c(118, 132),
				with_canonical_ranks = TRUE)






# 5) Charts ---------------------------------------------------------------

br_dataAmp %>%
	count(species_name)


A <- ggplot(count(br_dataAmp, family_name), aes(x = family_name, y = n)) +
	geom_bar(stat = "identity", width = .7,
			 position = "dodge", fill = "#FF5C00") +
	geom_text(aes(label = n), size = 4,
			  position = position_dodge2(width = .9),
			  hjust = -0.15, vjust = .5) +
	scale_x_discrete(limits = rev) +
	coord_flip() +
	xlab("Amphibian Families") +
	ylab("Total of occurrences") +
	ylim(0, 1560) +
	theme_bw() +
	theme(axis.title = element_text(size = 13, face = "bold"),
		  axis.text.x = element_text(size = 13),
		  axis.text.y = element_text(size = 13))



# 6) Maps -----------------------------------------------------------------


library(broom) # tidy() function
library(here) # fix working directory issues
library(maptools) # required for "broom"
library(patchwork) # gather the plots
library(rgdal) # readOGR() function
library(rgeos) # required for "broom"

# Change maptools, rgdal to sf/stars/terra


brazil <- readOGR(dsn = here::here("/media/ricardo/backup/Mapas/Shapes/Biomas"),
				  layer = "bioma")

brazil@proj4string <- CRS("+proj=longlat +datum=WGS84")

brazil_tidy <- tidy(brazil)

brazil_cor <- brazil_tidy %>%
	mutate(id = case_when(
		id == "0" ~ "Amazônia",
		id == "1" ~ "Caatinga",
		id == "2" ~ "Cerrado",
		id == "3" ~ "Pampa",
		id == "4" ~ "Pantanal",
		id == "5" ~ "Mata Atlântica"
	),
	colors = case_when(
		id == "Amazônia" ~ "#429238",
		id == "Caatinga" ~ "#A05C47",
		id == "Cerrado" ~ "#D7CD7A",
		id == "Pampa" ~ "#9EAFB7",
		id == "Pantanal" ~ "#C678B8",
		id == "Mata Atlântica" ~ "#9FD5C6"
	))


sa <- readOGR(dsn = here::here("/media/ricardo/backup/Mapas/Shapes/samerica"),
			  layer = "samer")

sa@proj4string <- brazil@proj4string

sa_tidy <- tidy(sa)




B <- ggplot() +
	geom_polygon(data = sa_tidy, aes(long, lat, group = group),
				 fill = "gray", color = "black", alpha = .6, size = .1) +
	geom_polygon(data = brazil_cor, aes(x = long, y = lat, group = group),
				 fill = brazil_cor$colors, color = "black", size = .2, alpha = .7) +
	geom_point(data = br_dataAmp, aes(x = lon, y = lat),
			   size = .7, colour = "#FF5C00") +
	labs(x = "Longitude", y = "Latitude") +

	theme_bw() +
	theme(panel.border = element_rect(color = "black", fill = NA),
		  panel.background = element_rect(fill = "aliceblue"),
		  axis.title = element_text(size = 13, face = "bold"),
		  axis.text.x = element_text(size = 13),
		  axis.text.y = element_text(size = 13)) +
	coord_fixed(xlim = c(-73.5, -33),
				ylim = c(-33, 5))


A + B














