/**
 * Fix DataTables pagination button jumping issue
 *
 * This script prevents the page from jumping to the top when clicking
 * on DataTables pagination buttons by intercepting click events on
 * anchor tags and preventing their default behavior.
 */

(function() {
  'use strict';

  /**
   * Initialize pagination fix for all DataTables on the page
   */
  function initPaginationFix() {
    // Use event delegation on document to catch all pagination button clicks
    document.addEventListener('click', function(e) {
      // Check if the clicked element is a pagination button
      const target = e.target;

      // Handle clicks on pagination buttons (anchor tags with paginate_button class)
      if (target.tagName === 'A' && target.classList.contains('paginate_button')) {
        // Only prevent default if it's not disabled
        if (!target.classList.contains('disabled')) {
          e.preventDefault();
          // The DataTables library will still handle the pagination logic
          // We're just preventing the anchor from jumping the page
        }
      }
    }, true); // Use capture phase to ensure we catch it early
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initPaginationFix);
  } else {
    // DOM is already ready
    initPaginationFix();
  }
})();
