utils_list_files <- function(.dirs, .reg = NULL, .id = "DocID", .rec = FALSE) {
  purrr::map(
    .x = .dirs,
    .f = ~ tibble::tibble(path = list.files(.x, .reg, FALSE, TRUE, .rec))
  ) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(
      !!dplyr::sym(.id) := fs::path_ext_remove(basename(path)),
      path = purrr::set_names(path, !!dplyr::sym(.id))
    ) %>%
    dplyr::select(!!dplyr::sym(.id), path)
}


plot_get_research_palette <- function() {
  c(
    "#bfd7ed", # Baby Blue
    "#60a3d9", # Blue Grotto
    "#0074b7", # Royal Blue
    "#003b73", # Navy Blue
    "#007fff", # Azure
    "#0047ab", # Cobalt Blue
    "#4682b4", # Steel Blue
    "#003153", # Prussian Blue
    "#00416a", # Indigo Dye
    "#002147" # Oxford Blue
  )
}

plot_add_theme <- function(.plot) {
  .plot +
    ggplot2::theme_classic(base_size = 12, base_family = "Times New Roman", base_line_size = 0.2) +
    ggplot2::theme(
      strip.background = ggplot2::element_rect(fill = "white", color = "black", linewidth = 0.2),
      text = ggplot2::element_text(family = "Times New Roman"),
      axis.title = ggplot2::element_text(family = "Times New Roman", face = "plain", size = 12),
      axis.text = ggplot2::element_text(family = "Times New Roman", color = "black"),
      strip.text = ggplot2::element_text(family = "Times New Roman", face = "bold"),
      axis.line = ggplot2::element_line(linewidth = 0.2, color = "black"),
      axis.ticks = ggplot2::element_line(linewidth = 0.2, color = "black"),
      axis.ticks.length = ggplot2::unit(0.2, "cm"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.spacing = ggplot2::unit(0.5, "cm"),
      panel.border = ggplot2::element_blank(),
      plot.margin = ggplot2::margin(0.8, 0.8, 0.8, 0.8, "cm"),
      plot.title = ggplot2::element_text(family = "Times New Roman", face = "bold", hjust = 0.5),
      legend.position = "bottom",
      legend.title = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(family = "Times New Roman"),
      legend.key.size = ggplot2::unit(0.8, "cm"),
      legend.margin = ggplot2::margin(0.2, 0, 0.2, 0, "cm")
    )
}


save_ggplot <- function(.gg, .path_out, .w = 10, .h = 8, .dpi = 300, .overwrite = FALSE) {
  if (.overwrite) {
    ggplot2::ggsave(
      filename = .path_out,
      plot = .gg,
      width = .w,
      height = .h,
      dpi = .dpi,
      bg = "white"
    )
    return(invisible(NULL))
  }

  if (file.exists(.path_out)) {
    return(invisible(NULL))
  } else {
    ggplot2::ggsave(
      filename = .path_out,
      plot = .gg,
      width = .w,
      height = .h,
      dpi = .dpi,
      bg = "white"
    )
    return(invisible(NULL))
  }
}
