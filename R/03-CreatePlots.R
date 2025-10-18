library(tidyverse)
source("R/00-Utils.R")

# Functions ---------------------------------------------------------------
read_data <- function(.path_tsne, .dir_concepts) {
  arrow::open_dataset(.path_tsne) %>%
    dplyr::left_join(
      y = arrow::open_dataset(.dir_concepts) %>%
        dplyr::distinct(CID, TID),
      by = dplyr::join_by(TID)
    ) %>%
    dplyr::select(CID, TID, X, Y) %>%
    dplyr::collect() %>%
    tidyr::nest(.by = CID) %>%
    head()
}

plot_embedding_tsne_single <- function(.tab) {
  dat_ <- .tab %>%
    dplyr::mutate(
      X = scales::rescale(X, to = c(-100, 100)),
      Y = scales::rescale(Y, to = c(-100, 100))
    )

  gg_ <- ggplot2::ggplot(dat_, ggplot2::aes(X, Y)) +
    ggplot2::geom_point(size = 2, color = "blue") +
    ggplot2::scale_x_continuous(name = NULL, limits = c(-100, 100)) +
    ggplot2::scale_y_continuous(name = NULL, limits = c(-100, 100)) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", linewidth = 0.1) +
    ggplot2::geom_vline(xintercept = 0, linetype = "dashed", linewidth = 0.1) +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::guides(color = ggplot2::guide_colorbar(
      barwidth = 20,
      barheight = 0.8,
      title.position = "top",
      title.hjust = 0.5
    ))

  plot_add_theme(gg_)
}


.dir_concepts <- "data-raw/Conceptlists/"
.dir_src_tsne <- "data-raw/EmbeddingTSNE/"
.dir_out_tsne <- fs::dir_create("images/tsne")
fils_tsne <- utils_list_files(.dir_src_tsne) %>%
  tidyr::separate(DocID, c("Model", "List"), sep = "--") %>%
  dplyr::mutate(
    # Standardize names for web
    Model = dplyr::case_when(
      Model == "FinBERT" ~ "FinBert",
      Model == "Oai3Large" ~ "OpenAI (Large)"
    ),
    List = case_when(
      List == "ConceptList10K_Majority005" ~ "BottomUp (10-K)",
      List == "ConceptList20F_Majority005" ~ "BottomUp (20-F)",
      List == "ConceptListROW_Original" ~ "TopDown"
    )
  ) %>%
  dplyr::filter(!is.na(Model), !is.na(List)) %>%
  dplyr::mutate(Data = purrr::map(path, .f = ~ read_data(.x, .dir_concepts))) %>%
  tidyr::unnest(Data) %>%
  dplyr::mutate(
    NameShow = paste0(CID, "_", List, "_", Model),
    NameOut = gsub("[\\(\\) ]", "", NameShow),
    PathOut = file.path(.dir_out_tsne, paste0(NameOut, ".png")),
  ) %>%
  dplyr::mutate(Plots = purrr::map(
    .x = data,
    .f = plot_embedding_tsne_single,
    .progress = TRUE
  )) %>%
  dplyr::select(Model, List, CID, NameShow, Plots, PathOut)

purrr::walk2(
  .x = fils_tsne$Plots,
  .y = fils_tsne$PathOut,
  .f = ~ save_ggplot(.x, .y, 10, 8, 300),
  .progress = TRUE
)

fils_tsne <- dplyr::select(fils_tsne, -Plots)
# Save metadata for website
arrow::write_parquet(fils_tsne, "data/tsne_plots_metadata.parquet")
