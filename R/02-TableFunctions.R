#' Create a professional interactive DT datatable with modern styling
#'
#' Follows UX best practices for data tables:
#' - Clean, minimalist design
#' - Proper spacing and typography
#' - Sticky headers
#' - Custom alignment options
#' - Compact, efficient display
#'
#' @param .data Data frame or tibble to display
#' @param .page_length Number of rows per page (default: 25)
#' @param .column_align Character vector specifying alignment for each column ('left', 'center', 'right')
#' @param .header_align Single character specifying header alignment: 'left', 'center', or 'right' (default: 'center')
#' @param .filter Show column filters - 'top', 'bottom', or 'none' (default: 'top')
#' @param .font_size Font size in px (default: 12)
#' @param .row_padding Vertical padding for rows in px (default: 6)
#' @param ... Additional arguments passed to datatable()
#'
#' @return A DT datatable object with professional styling
create_interactive_table <- function(.data,
                                     .page_length = 25,
                                     .column_align = NULL,
                                     .header_align = 'center',
                                     .filter = 'top',
                                     .font_size = 12,
                                     .row_padding = 6,
                                     ...) {
  
  # Determine column classes for alignment
  col_defs <- list()
  
  # Apply custom alignment if specified
  if (!is.null(.column_align)) {
    for (i in seq_along(.column_align)) {
      align_class <- switch(.column_align[i],
                            "left" = "dt-body-left",
                            "center" = "dt-body-center",
                            "right" = "dt-body-right",
                            "dt-body-left"  # default to left
      )
      col_defs <- append(col_defs, list(
        list(className = align_class, targets = i - 1)  # JS uses 0-based indexing
      ))
    }
  }
  
  # Configure table options
  dt_options <- list(
    pageLength = .page_length,
    scrollX = TRUE,
    autoWidth = FALSE,
    searching = FALSE,  # Remove global search
    lengthChange = FALSE,  # Remove "Show ... rows" dropdown
    fixedHeader = TRUE,  # Sticky header
    language = list(
      info = "Showing _START_ to _END_ of _TOTAL_ entries",
      paginate = list(
        first = "First",
        last = "Last",
        `next` = "Next",
        previous = "Prev"
      )
    ),
    columnDefs = col_defs,
    initComplete = DT::JS(sprintf(
      "function(settings, json) {
        $(this.api().table().header()).css({
          'background-color': '#f8f9fa',
          'border-bottom': '2px solid #dee2e6',
          'font-weight': '600',
          'text-align': '%s'
        });
      }",
      .header_align
    ))
  )
  
  # Create the datatable - no buttons, clean white background
  dt <- DT::datatable(
    .data,
    filter = .filter,
    extensions = 'FixedHeader',
    options = dt_options,
    class = 'hover',  # Only hover effect, no stripes
    rownames = FALSE,
    style = 'bootstrap4',
    ...
  )
  
  # Apply custom CSS with user-specified sizing
  css_font <- paste0(.font_size, "px")
  
  # Apply formatting to all columns
  for (i in seq_len(ncol(.data))) {
    dt <- DT::formatStyle(
      dt,
      columns = i,
      fontSize = css_font
    )
  }
  
  return(dt)
}
