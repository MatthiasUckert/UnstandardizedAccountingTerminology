#' Create a professional interactive DT datatable with modern styling
#'
#' Follows UX best practices for data tables:
#' - Clean, minimalist design
#' - Zebra striping for readability
#' - Proper spacing and typography
#' - Sticky headers
#' - Right-aligned numbers
#' - Clear search and filter UI
#'
#' @param .data Data frame or tibble to display
#' @param .page_length Number of rows per page (default: 25)
#' @param .show_buttons Include copy/csv/excel buttons (default: TRUE)
#' @param .right_align_cols Column indices or names to right-align (typically numeric columns)
#' @param .bold_cols Column indices or names to make bold (e.g., first column as identifier)
#' @param .filter Show column filters - 'top', 'bottom', or 'none' (default: 'top')
#' @param .compact Use compact row height (default: FALSE)
#' @param ... Additional arguments passed to datatable()
#'
#' @return A DT datatable object with professional styling
create_interactive_table <- function(.data,
                                     .page_length = 25,
                                     .show_buttons = TRUE,
                                     .right_align_cols = NULL,
                                     .bold_cols = NULL,
                                     .filter = 'top',
                                     .compact = FALSE,
                                     ...) {
  
  # Determine column classes for alignment
  col_defs <- list()
  
  # Auto-detect numeric columns for right alignment if not specified
  if (is.null(.right_align_cols)) {
    numeric_cols <- which(sapply(.data, is.numeric)) - 1  # JS uses 0-based indexing
    if (length(numeric_cols) > 0) {
      col_defs <- append(col_defs, list(
        list(className = 'dt-right', targets = numeric_cols)
      ))
    }
  } else {
    # Convert column names to indices if needed
    if (is.character(.right_align_cols)) {
      .right_align_cols <- which(names(.data) %in% .right_align_cols) - 1
    }
    col_defs <- append(col_defs, list(
      list(className = 'dt-right', targets = .right_align_cols)
    ))
  }
  
  # Add bold styling to specified columns
  if (!is.null(.bold_cols)) {
    if (is.character(.bold_cols)) {
      .bold_cols <- which(names(.data) %in% .bold_cols) - 1
    }
    col_defs <- append(col_defs, list(
      list(className = 'dt-bold', targets = .bold_cols)
    ))
  }
  
  # Configure table options
  dt_options <- list(
    pageLength = .page_length,
    lengthMenu = c(10, 25, 50, 100),
    scrollX = TRUE,
    autoWidth = FALSE,
    fixedHeader = TRUE,  # Sticky header
    language = list(
      search = "Search:",
      lengthMenu = "Show _MENU_ rows",
      info = "Showing _START_ to _END_ of _TOTAL_ entries",
      paginate = list(
        first = "First",
        last = "Last",
        `next` = "Next",
        previous = "Prev"
      )
    ),
    columnDefs = col_defs,
    initComplete = DT::JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({",
      "'background-color': '#f8f9fa',",
      "'border-bottom': '2px solid #dee2e6',",
      "'font-weight': '600'",
      "});",
      "}"
    )
  )
  
  # Add export buttons if requested
  if (.show_buttons) {
    dt_options$dom <- 'Bfrtip'
    dt_options$buttons <- list(
      list(extend = 'copy', text = '<i class="fa fa-copy"></i> Copy'),
      list(extend = 'csv', text = '<i class="fa fa-file-csv"></i> CSV'),
      list(extend = 'excel', text = '<i class="fa fa-file-excel"></i> Excel')
    )
  }
  
  # Choose table class based on compact option
  table_class <- if (.compact) {
    'stripe hover compact'
  } else {
    'stripe hover'
  }
  
  # Create the datatable
  dt <- DT::datatable(
    .data,
    filter = .filter,
    extensions = if (.show_buttons) c('Buttons', 'FixedHeader') else 'FixedHeader',
    options = dt_options,
    class = table_class,
    rownames = FALSE,
    style = 'bootstrap4',
    ...
  )
  
  # Apply custom CSS for better spacing and typography
  css_styles <- "
    .dataTables_wrapper {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      font-size: 14px;
    }
    .dataTables_wrapper table {
      border-collapse: separate;
      border-spacing: 0;
    }
    .dataTables_wrapper thead th {
      padding: 12px 16px;
      font-weight: 600;
      text-align: left;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: #495057;
    }
    .dataTables_wrapper tbody td {
      padding: 10px 16px;
      vertical-align: middle;
    }
    .dt-bold {
      font-weight: 600;
    }
    .dt-right {
      text-align: right !important;
    }
    .dataTables_wrapper .dataTables_filter input {
      border: 1px solid #ced4da;
      border-radius: 4px;
      padding: 6px 12px;
      margin-left: 8px;
    }
    .dataTables_wrapper .dataTables_length select {
      border: 1px solid #ced4da;
      border-radius: 4px;
      padding: 4px 8px;
      margin: 0 8px;
    }
    div.dt-buttons {
      margin-bottom: 12px;
    }
    div.dt-buttons .dt-button {
      background-color: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 4px;
      padding: 6px 12px;
      margin-right: 6px;
      font-size: 13px;
      color: #495057;
      cursor: pointer;
    }
    div.dt-buttons .dt-button:hover {
      background-color: #e9ecef;
      border-color: #adb5bd;
    }
  "
  
  return(dt)
}


#' Read and display a parquet file as an interactive table
#'
#' @param .path Path to the parquet file
#' @param ... Additional arguments passed to create_interactive_table()
#'
#' @return A DT datatable object
display_parquet_table <- function(.path, ...) {
  .data <- arrow::read_parquet(.path)
  create_interactive_table(.data, ...)
}