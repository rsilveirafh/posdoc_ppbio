#Ricardo Silveira-Filho (ricardodasilveira@gmail.com)
#Abril de 2019

#Instalando o pacote (tambem o dplyr, para manipulacao dos dados)
install.packages("taxize", dependencies = TRUE)
install.packages("dplyr", dependencies = TRUE)

library(taxize)
library(dplyr)

#Modifiquei uma lista de especies do laboratorio (tinha 240 especies)
#Diminui para 60 especies e adicionei erros propositalmente
especies <- read.csv("dados/species_list.csv", h = T)

#Mostrando como fiz uma subamostra da tabela inicial:
#ps.: caso rode o comando abaixo novamente, outros dados serao reamostrados
especies <- especies %>%
	sample_n(60) %>% #Sorteia X valores aleatoriamente
	arrange(spp) #Organizando por ordem alfabetica

#Salvando o objeto em um arquivo
write.csv(especies, "dados/lista_especies.csv")

#Editei os nomes manualmente no Excel

#Carregando o novo arquivo
especies60 <- read.csv("dados/lista_especies_editada.csv", h = T)
especies60

####################################
#Comecando a trabalhar com o taxize#
####################################

#Lista das fontes disponiveis no GNR (Global Names Resolver)
gnr_datasources()

#Especificando as fontes a serem usadas. Caso nao seja especificado, GNR vai procurar em todas as fontes disponiveis
src.title <- c("Catalogue of Life", #1
			   "ITIS", #3
			   "EOL", #12
			   "Tropicos - Missouri Botanical Garden", #165
			   "The International Plant Names Index") #167

#Ou colocando os numeros de identificacao
src.id <- c(1, 3, 12, 165, 167)

#Checando os bancos de dados selecionados
subset(gnr_datasources(), title %in% src.title) #Com nomes
#Ou
subset(gnr_datasources(), id %in% src.id) #Com numeros


##Checar com Global Names Resolver (GNR)
#Argumentos: ver ?gnr_resolve
# canonical = FALSE: retorna especie + nome dos autores (autoridades taxonomicas)
# with_canonical_ranks: retorna nomes com rankings infraespecificos
resultado.longo <- as.character(especies60$spp) %>%
	gnr_resolve(data_source_ids = c(165, 167),
				with_canonical_ranks = TRUE)

resultado_longo2 <- gnr_resolve(as.character(especies60$spp), data_source_ids = c(165, 167), with_canonical_ranks = FALSE)

#Checando:
# user_supplied_name: nomes fornecidos pelo usuario
# submitted_name: nomes pre-corrigidos
# data_source_title: nome da database de referencia
# score: 1.0 = melhor
# matched_name2: taxons que coincidiram com o GNR
resultado.longo
View(resultado.longo)

#Criando um data.frame resumido
#Vou selecionar somente os resultados do Tropicos
resultado.curto <- resultado.longo %>%
	filter(grepl("^Tropicos", data_source_title)) %>%
	select(submitted_name, matched_name2, score)

antigoEnovo <- data.frame(cbind(especies60, resultado.curto))

#Exportando os resultados
write.csv(antigoEnovo, "dados/lista_final.csv", row.names = F, quote = F)

