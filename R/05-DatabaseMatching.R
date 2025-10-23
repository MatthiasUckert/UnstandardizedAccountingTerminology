library(tidyverse)

arrow::read_parquet("data-raw/DataBaseMatching.parquet") %>% 
  dplyr::distinct(Database, DatabaseVar, TagMod) %>% 
  dplyr::filter(!is.na(TagMod)) %>% 
  dplyr::filter(!TagMod == "NA") %>% 
  dplyr::group_by(Database, DatabaseVar) %>% 
  dplyr::summarise(TagMod = paste(TagMod, collapse = "\n"), .groups = "drop") %>% 
  openxlsx::write.xlsx("excel-raw/DatabaseAndTags.xlsx")


arrow::read_parquet("data-raw/DataBaseMatching.parquet") %>% 
  dplyr::distinct(Termlist, Database, DatabaseVar, CID) %>% 
  dplyr::group_by(Termlist, Database, DatabaseVar) %>% 
  dplyr::summarise(CID = paste(CID, collapse = "\n"), .groups = "drop") %>% 
  tidyr::pivot_wider(names_from = Termlist, values_from = CID) %>% 
  openxlsx::write.xlsx("excel-raw/DatabaseAndCIDs.xlsx")