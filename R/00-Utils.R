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
