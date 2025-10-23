library(tidyverse)
source("R/00-Utils.R")


# Transform Term/Concept Lists --------------------------------------------
## Termlists ---------------------------------------------------------------
.dir_termlists <- "data-raw/Termlists/"
tab_termlists <- utils_list_files(.dir_termlists) %>%
  dplyr::mutate(
    DocID = gsub("Final", "", DocID),
  ) %>% 
  dplyr::filter(!DocID == "TermListLAM") %>%
  dplyr::rename(PathRaw = path) %>%
  dplyr::mutate(Data = purrr::map(
    .x = PathRaw,
    .f = ~ arrow::read_parquet(.x, c("TID", "nGram", "Term"))
  )) %>% 
  tidyr::unnest(Data) %>% 
  dplyr::select(Termlist = DocID, TID, nGram, Term) %>% 
  dplyr::mutate(Termlist = dplyr::case_when(
    Termlist == "TermList10K" ~ "Bottom-Up (10-Ks)",
    Termlist == "TermList20F" ~ "Bottom-Up (20-Fs)",
    Termlist == "TermListROW" ~ "Top-Down"
  ))

arrow::write_parquet(tab_termlists, "data/Termlists.parquet")
split(tab_termlists[, -1], tab_termlists$Termlist) %>% 
  openxlsx::write.xlsx("excel-raw/Termlists.xlsx")

rm(tab_termlists)


## Conceptlists ---------------------------------------------------------------
.dir_conceptlists <- "data-raw/Conceptlists/"
tab_conceptlists <- utils_list_files(.dir_conceptlists) %>%
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
  )) %>% 
  tidyr::unnest(Data) %>% 
  dplyr::select(Conceptlist = DocID, CID, TID, nGram, Term) %>% 
  dplyr::mutate(Conceptlist = dplyr::case_when(
    Conceptlist == "ConceptList10K" ~ "Bottom-Up (10-Ks)",
    Conceptlist == "ConceptList20F" ~ "Bottom-Up (20-Fs)",
    Conceptlist == "ConceptListROW" ~ "Top-Down"
  ))

arrow::write_parquet(tab_conceptlists, "data/Conceptlists.parquet")
split(tab_conceptlists[, -1], tab_conceptlists$Conceptlist) %>% 
  openxlsx::write.xlsx("excel-raw/Conceptlists.xlsx")

rm(tab_conceptlists)


# Most Common Terms/Concepts ----------------------------------------------
.dir_most_common <- "data-raw/MostCommon/"
fils_most_common <- utils_list_files(.dir_most_common, .reg = "rds$") %>% 
  dplyr::filter(!DocID == "MostCommonConceptSelected")


## Most Common Terms -------------------------------------------------------
tab_mc_terms <- readr::read_rds("data-raw/MostCommon//MostCommonTerms.rds") %>% 
  dplyr::bind_rows(.id = "Termlist") %>% 
  dplyr::filter(SampleType == "SampleMain") %>% 
  dplyr::select(Termlist, Rank, TID, Term, Frequency = FRQ, Obs = nObs, Firms = nFirm) %>% 
  dplyr::filter(!Termlist == "TermListLAM") %>% 
  dplyr::mutate(Termlist = dplyr::case_when(
    Termlist == "TermList10K" ~ "Bottom-Up (10-Ks)",
    Termlist == "TermList20F" ~ "Bottom-Up (20-Fs)",
    Termlist == "TermListROW" ~ "Top-Down"
  ))

arrow::write_parquet(tab_mc_terms, "data/MostCommonTerms.parquet")
split(tab_mc_terms[, -1], tab_mc_terms$Termlist) %>% 
  openxlsx::write.xlsx("excel-raw/MostCommonTerms.xlsx")

rm(tab_mc_terms)

## Most Common Concepts -------------------------------------------------------
tab_mc_concepts <- readr::read_rds("data-raw/MostCommon//MostCommonConceptAll.rds") %>% 
  dplyr::bind_rows(.id = "Conceptlist") %>% 
  dplyr::filter(SampleType == "SampleMain") %>% 
  dplyr::select(Conceptlist, RankCID, RankTID, CID, TID, Term, Frequency = FRQ, Obs = nObs, Firms = nFirm) %>% 
  dplyr::mutate(Conceptlist = dplyr::case_when(
    Conceptlist == "ConceptList10K_Majority005" ~ "Bottom-Up (10-Ks)",
    Conceptlist == "ConceptList20F_Majority005" ~ "Bottom-Up (20-Fs)",
    Conceptlist == "ConceptListROW_Original" ~ "Top-Down"
  )) %>% 
  dplyr::filter(!is.na(Conceptlist))

arrow::write_parquet(tab_mc_concepts, "data/MostCommonConcepts.parquet")
split(tab_mc_concepts[, -1], tab_mc_concepts$Conceptlist) %>% 
  openxlsx::write.xlsx("excel-raw/MostCommonConcepts.xlsx")

rm(tab_mc_concepts)