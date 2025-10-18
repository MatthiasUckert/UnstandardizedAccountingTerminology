(function () {
  'use strict';

  let isDragging = false, startX = 0, startWidth = 0;
  let container = null, tocNav = null, handle = null;

  function findTOCContainer() {
    tocNav = document.querySelector("nav[role='doc-toc']") || document.getElementById('TOC');
    if (!tocNav) return null;
    // Prefer the margin sidebar if it exists; otherwise resize the nearest column-like parent
    return document.querySelector('#quarto-margin-sidebar') ||
           tocNav.closest('aside, .sidebar, #quarto-sidebar, .column-left, .page-left') ||
           tocNav.parentElement;
  }

  function positionHandle() {
    const r = container.getBoundingClientRect();
    handle.style.left = (r.right - 5) + 'px';
    handle.style.top = r.top + 'px';
    handle.style.height = r.height + 'px';
  }

  function startDrag(e) {
    isDragging = true;
    startX = e.clientX;
    startWidth = container.offsetWidth;
    e.preventDefault();
    document.body.style.cursor = 'ew-resize';
    document.body.style.userSelect = 'none';
    document.addEventListener('mousemove', onDrag);
    document.addEventListener('mouseup', stopDrag);
  }

  function onDrag(e) {
    if (!isDragging) return;
    const w = Math.min(600, Math.max(220, startWidth + (e.clientX - startX)));
    container.style.width = w + 'px';
    container.style.minWidth = w + 'px';
    container.style.maxWidth = w + 'px';
    positionHandle();
    localStorage.setItem('toc-width', w);
  }

  function stopDrag() {
    if (!isDragging) return;
    isDragging = false;
    document.body.style.cursor = '';
    document.body.style.userSelect = '';
    document.removeEventListener('mousemove', onDrag);
    document.removeEventListener('mouseup', stopDrag);
  }

  function init() {
    container = findTOCContainer();
    if (!container) { console.log('TOC container not found'); return; }

    handle = document.createElement('div');
    handle.className = 'toc-resize-handle';
    handle.innerHTML = '<div class="resize-line"></div>';
    document.body.appendChild(handle);

    const saved = localStorage.getItem('toc-width');
    if (saved) {
      ['width','minWidth','maxWidth'].forEach(p => container.style[p] = saved + 'px');
    }

    positionHandle();
    window.addEventListener('scroll', positionHandle);
    window.addEventListener('resize', positionHandle);
    const obs = new MutationObserver(positionHandle);
    obs.observe(container, { childList: true, subtree: true });

    handle.addEventListener('mousedown', startDrag);
    handle.addEventListener('dblclick', () => {
      ['width','minWidth','maxWidth'].forEach(p => container.style[p] = '');
      localStorage.removeItem('toc-width');
      setTimeout(positionHandle, 100);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();