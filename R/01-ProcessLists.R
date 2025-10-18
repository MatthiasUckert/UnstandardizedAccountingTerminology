library(tidyverse)
source("R/00-Utils.R")


# Transform Term/Concept Lists --------------------------------------------
## Termlists ---------------------------------------------------------------
.dir_termlists <- "data-raw/TermConceptlists/Termlists/"
fils_termlists <- utils_list_files(.dir_termlists) %>%
  dplyr::mutate(
    DocID = gsub("Final", "", DocID),
    PathData = file.path("data/Termlists/", paste0(DocID, ".parquet"))
  ) %>%
  dplyr::rename(PathRaw = path) %>%
  dplyr::mutate(Data = purrr::map(
    .x = PathRaw,
    .f = ~ arrow::read_parquet(.x, c("TID", "nGram", "Term"))
  )) %>% 
  dplyr::filter(!DocID == "TermListLAM")

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
