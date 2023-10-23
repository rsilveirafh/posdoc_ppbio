# Resultados Pós Doc PPBIO
# Ricardo da Silveira Filho
# ricardodasilveira@gmail.com
# 19 out 2023


# 0) Setup ----------------------------------------------------------------

library(tidyverse)



# 1) Data -----------------------------------------------------------------

barcode <- read_csv("data/processed/amp_bir_rep_mam_bold.csv",
                    show_col_types = FALSE)


barcode_brazil <- barcode |> 
    filter(country == "Brazil")



















































