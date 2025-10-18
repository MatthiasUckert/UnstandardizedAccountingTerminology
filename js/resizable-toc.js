// ========================================
// RESIZABLE TOC
// Allows users to drag and resize the TOC width
// ========================================

(function() {
  'use strict';
  
  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initResizableTOC);
  } else {
    initResizableTOC();
  }
  
  function initResizableTOC() {
    const toc = document.querySelector('.sidebar.toc-left, .sidebar-navigation, #quarto-margin-sidebar');
    
    if (!toc) return; // No TOC found
    
    // Create resize handle
    const resizeHandle = document.createElement('div');
    resizeHandle.className = 'toc-resize-handle';
    resizeHandle.innerHTML = '<div class="resize-line"></div>';
    toc.appendChild(resizeHandle);
    
    let isResizing = false;
    let startX = 0;
    let startWidth = 0;
    
    // Load saved width from localStorage
    const savedWidth = localStorage.getItem('toc-width');
    if (savedWidth) {
      toc.style.width = savedWidth + 'px';
      toc.style.minWidth = savedWidth + 'px';
      toc.style.maxWidth = savedWidth + 'px';
    }
    
    // Mouse down on handle
    resizeHandle.addEventListener('mousedown', function(e) {
      isResizing = true;
      startX = e.clientX;
      startWidth = parseInt(getComputedStyle(toc).width, 10);
      
      document.body.style.cursor = 'ew-resize';
      document.body.style.userSelect = 'none';
      
      e.preventDefault();
    });
    
    // Mouse move
    document.addEventListener('mousemove', function(e) {
      if (!isResizing) return;
      
      const width = startWidth + (e.clientX - startX);
      
      // Set min and max width constraints
      const minWidth = 200;
      const maxWidth = 500;
      
      if (width >= minWidth && width <= maxWidth) {
        toc.style.width = width + 'px';
        toc.style.minWidth = width + 'px';
        toc.style.maxWidth = width + 'px';
      }
    });
    
    // Mouse up
    document.addEventListener('mouseup', function() {
      if (isResizing) {
        isResizing = false;
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
        
        // Save width to localStorage
        const currentWidth = parseInt(getComputedStyle(toc).width, 10);
        localStorage.setItem('toc-width', currentWidth);
      }
    });
    
    // Double-click to reset to default
    resizeHandle.addEventListener('dblclick', function() {
      toc.style.width = '';
      toc.style.minWidth = '';
      toc.style.maxWidth = '';
      localStorage.removeItem('toc-width');
    });
  }
})();