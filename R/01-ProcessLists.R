library(tidyverse)
source("R/00-Utils.R")


# Transform Term/Concept Lists --------------------------------------------
## Termlists ---------------------------------------------------------------
.dir_termlists <- "data-raw/Termlists/"
fils_termlists <- utils_list_files(.dir_termlists) %>%
  dplyr::mutate(
    DocID = gsub("Final", "", DocID),
    PathData = file.path("data/Termlists/", paste0(DocID, ".parquet"))
  ) %>% 
  dplyr::filter(!DocID == "TermListLAM") %>%
  dplyr::rename(PathRaw = path) %>%
  dplyr::mutate(Data = purrr::map(
    .x = PathRaw,
    .f = ~ arrow::read_parquet(.x, c("TID", "nGram", "Term"))
  )) 

for (i in seq_len(nrow(fils_termlists))) {
  fil_parquet <- fils_termlists$PathData[i]
  if (!file.exists(fil_parquet)) {
    data <- fils_termlists$Data[[i]]
    fs::dir_create(dirname(fil_parquet))
    arrow::write_parquet(data, fil_parquet)
    rm(data)
  }
  rm(fil_parquet, i)
}

fil_termlist_excel <- file.path("excel-raw/Termlists.xlsx")

if (!file.exists(fil_termlist_excel)) {
  purrr::set_names(fils_termlists$Data, fils_termlists$DocID) %>% 
    openxlsx2::write_xlsx(fil_termlist_excel, as_table = TRUE)
}

rm(fils_termlists, fil_termlist_excel)

## Conceptlists ---------------------------------------------------------------
.dir_conceptlists <- "data-raw/Conceptlists/"
fils_conceptlists <- utils_list_files(.dir_conceptlists) %>%
  dplyr::filter(DocID %in% c(
    "ConceptList10K_Majority005",
    "ConceptList20F_Majority005",
    "ConceptListROW_Original"
    )) %>% 
  dplyr::mutate(
    DocID = gsub("_.+", "", DocID),
    PathData = file.path("data/Conceptlists/", paste0(DocID, ".parquet"))
  ) %>%
  dplyr::rename(PathRaw = path) %>%
  dplyr::mutate(Data = purrr::map(
    .x = PathRaw,
    .f = ~ arrow::read_parquet(.x, c("TID", "CID", "nGram", "Term"))
  ))

for (i in seq_len(nrow(fils_conceptlists))) {
  fil_parquet <- fils_conceptlists$PathData[i]
  if (!file.exists(fil_parquet)) {
    data <- fils_conceptlists$Data[[i]]
    fs::dir_create(dirname(fil_parquet))
    arrow::write_parquet(data, fil_parquet)
    rm(data)
  }
  rm(fil_parquet, i)
}


fil_conceptlist_excel <- file.path("excel-raw/Conceptlists.xlsx")

if (!file.exists(fil_conceptlist_excel)) {
  purrr::set_names(fils_conceptlists$Data, fils_conceptlists$DocID) %>% 
    openxlsx2::write_xlsx(fil_conceptlist_excel, as_table = TRUE)
}

rm(fils_conceptlists, fil_conceptlist_excel)