/**
 * HCMUTE Thesis Portal — Enterprise UI helpers v4.0
 * Academic Futuristic 3D Micro-interactions & Core Services
 */
(function (window) {
  'use strict';

  const CTX = document.body?.dataset?.contextPath || '';

  function refreshIcons() {
    if (typeof lucide !== 'undefined') {
      lucide.createIcons();
    }
  }

  /* ──────────────────────────────────────────────────────────────────
     TOAST NOTIFICATIONS (Enhanced with SweetAlert2 & Fallback)
     ────────────────────────────────────────────────────────────────── */
  function toast(icon, title, text) {
    if (typeof Swal !== 'undefined') {
      return Swal.fire({
        toast: true,
        position: 'top-end',
        icon: icon || 'info',
        title: title || '',
        text: text || undefined,
        timer: 3500,
        timerProgressBar: true,
        showConfirmButton: false,
        background: '#ffffff',
        color: '#0f233a',
        customClass: {
          popup: 'rounded-2xl shadow-xl border border-slate-100 font-sans'
        }
      });
    } else {
      console.log(`[Toast ${icon}] ${title}: ${text || ''}`);
    }
  }

  function confirmDialog(opts) {
    if (typeof Swal !== 'undefined') {
      return Swal.fire({
        icon: opts.icon || 'warning',
        title: opts.title || 'Xác nhận hành động',
        text: opts.text || '',
        showCancelButton: true,
        confirmButtonColor: opts.confirmColor || '#006da8',
        cancelButtonColor: '#64748b',
        confirmButtonText: opts.confirmText || 'Đồng ý thực hiện',
        cancelButtonText: opts.cancelText || 'Hủy bỏ',
        reverseButtons: true,
        customClass: {
          popup: 'rounded-3xl shadow-2xl border border-slate-100'
        }
      });
    }
    return Promise.resolve({ isConfirmed: window.confirm(opts.title + (opts.text ? '\n' + opts.text : '')) });
  }

  async function postForm(url, data) {
    const body = new URLSearchParams();
    Object.entries(data || {}).forEach(([k, v]) => {
      if (v !== undefined && v !== null) body.append(k, v);
    });
    try {
      const res = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
        body: body.toString()
      });
      const contentType = res.headers.get('content-type') || '';
      if (contentType.includes('application/json')) return res.json();
      return { success: res.ok, message: res.ok ? 'Thành công' : 'Có lỗi xảy ra' };
    } catch (e) {
      return { success: false, message: 'Lỗi kết nối mạng: ' + e.message };
    }
  }

  /* ──────────────────────────────────────────────────────────────────
     SIDEBAR COLLAPSE & MOBILE DRAWER
     ────────────────────────────────────────────────────────────────── */
  function initSidebar() {
    const wrapper = document.querySelector('.app-wrapper');
    const sidebar = document.querySelector('.app-sidebar');
    const toggleBtn = document.getElementById('sidebarToggleBtn');
    const overlay = document.getElementById('sidebarOverlay');
    if (!wrapper || !sidebar || !toggleBtn) return;

    const KEY = 'hcmute_sidebar_collapsed';
    const isDesktop = () => window.matchMedia('(min-width: 1025px)').matches;

    if (isDesktop() && localStorage.getItem(KEY) === '1') {
      wrapper.classList.add('sidebar-collapsed');
    }

    toggleBtn.addEventListener('click', () => {
      if (isDesktop()) {
        wrapper.classList.toggle('sidebar-collapsed');
        localStorage.setItem(KEY, wrapper.classList.contains('sidebar-collapsed') ? '1' : '0');
      } else {
        sidebar.classList.toggle('show');
        if (overlay) overlay.classList.toggle('show');
      }
      setTimeout(refreshIcons, 60);
    });

    if (overlay) {
      overlay.addEventListener('click', () => {
        sidebar.classList.remove('show');
        overlay.classList.remove('show');
      });
    }
  }

  /* ──────────────────────────────────────────────────────────────────
     SUBTLE 3D MOUSE PARALLAX FOR HERO SECTIONS (MAX ±5 DEGREES)
     ────────────────────────────────────────────────────────────────── */
  function initParallax() {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

    const heroes = document.querySelectorAll('.dashboard-hero, .landing-hero, .login-visual-container, .register-visual-card');
    if (!heroes || heroes.length === 0) return;

    heroes.forEach((hero) => {
      const orbit = hero.querySelector('.hero-orbit, .login-3d-sphere');
      const cube = hero.querySelector('.hero-3d-cube');
      const cube3d = hero.querySelector('.hero-cube-3d');
      const badges = hero.querySelectorAll('.academic-badge-float');

      hero.addEventListener('mousemove', (e) => {
        const rect = hero.getBoundingClientRect();
        const x = (e.clientX - rect.left) / rect.width - 0.5;
        const y = (e.clientY - rect.top) / rect.height - 0.5;

        // Strict clamp: max ±5 degrees
        const tiltX = Math.max(-5, Math.min(5, y * -10));
        const tiltY = Math.max(-5, Math.min(5, x * 10));

        if (orbit) {
          orbit.style.transform = `translateY(-50%) rotate(${-20 + tiltY}deg) perspective(800px) rotateX(${tiltX}deg) translateZ(20px)`;
        }
        if (cube) {
          cube.style.transform = `rotate(${26 + tiltY * 0.6}deg) perspective(600px) rotateX(${16 + tiltX}deg) translateZ(40px)`;
        }
        if (cube3d) {
          cube3d.style.transform = `rotateX(${15 + tiltX}deg) rotateY(${tiltY * 1.2}deg)`;
        }
        if (badges && badges.length > 0) {
          badges.forEach((b, idx) => {
            const factor = (idx % 2 === 0 ? 1 : -1);
            b.style.transform = `perspective(600px) translateY(${tiltX * factor}px) translateZ(${30 + Math.abs(tiltY)}px) rotate(${tiltY * 0.5}deg)`;
          });
        }
      });

      hero.addEventListener('mouseleave', () => {
        if (orbit) orbit.style.transform = '';
        if (cube) cube.style.transform = '';
        if (cube3d) cube3d.style.transform = '';
        if (badges && badges.length > 0) {
          badges.forEach((b) => { b.style.transform = ''; });
        }
      });
    });
  }

  /* ──────────────────────────────────────────────────────────────────
     ACCORDION & LIVE SEARCH
     ────────────────────────────────────────────────────────────────── */
  function initAccordion(root) {
    (root || document).querySelectorAll('[data-accordion-trigger]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const panel = btn.closest('[data-accordion-item]')?.querySelector('[data-accordion-panel]');
        const open = panel?.classList.contains('hidden');
        const group = btn.closest('[data-accordion]');
        if (group) {
          group.querySelectorAll('[data-accordion-panel]').forEach((p) => p.classList.add('hidden'));
          group.querySelectorAll('[data-accordion-trigger] i[data-lucide="chevron-down"]').forEach((i) => {
            i.style.transform = '';
          });
        }
        if (panel && open) {
          panel.classList.remove('hidden');
          const chevron = btn.querySelector('i[data-lucide="chevron-down"]');
          if (chevron) chevron.style.transform = 'rotate(180deg)';
        }
        refreshIcons();
      });
    });
  }

  function bindLiveSearch(inputId, rowSelector) {
    const input = document.getElementById(inputId);
    if (!input) return;
    input.addEventListener('input', () => {
      const q = input.value.toLowerCase().trim();
      document.querySelectorAll(rowSelector).forEach((row) => {
        const matches = !q || row.innerText.toLowerCase().includes(q);
        row.dataset.searchHidden = matches ? 'false' : 'true';
        row.style.display = matches ? '' : 'none';
      });

      // Re-trigger pagination if table or list has pagination
      const firstRow = document.querySelector(rowSelector);
      if (firstRow) {
        const table = firstRow.closest('table');
        if (table && typeof table._renderPagination === 'function') {
          table._renderPagination();
        }
        const list = firstRow.closest('[data-pagination-list]');
        if (list && typeof list._renderPagination === 'function') {
          list._renderPagination();
        }
      }
    });
  }

  /* ──────────────────────────────────────────────────────────────────
     FORM SUBMIT LOADING STATES
     ────────────────────────────────────────────────────────────────── */
  function initFormStates() {
    document.querySelectorAll('form').forEach((form) => {
      if (form.dataset.loadingBound === '1') return;
      form.dataset.loadingBound = '1';
      form.addEventListener('submit', () => {
        if (form.dataset.preventLoading === '1' || form.hasAttribute('onsubmit')) return;
        window.setTimeout(() => {
          form.querySelectorAll('button[type="submit"], input[type="submit"]').forEach((button) => {
            if (button.disabled) return;
            button.disabled = true;
            button.dataset.originalLabel = button.innerHTML || button.value || '';
            if (button.tagName === 'BUTTON') {
              button.innerHTML = '<span class="inline-flex items-center gap-2"><i data-lucide="loader-2" class="w-4 h-4 animate-spin"></i><span>Đang xử lý...</span></span>';
              refreshIcons();
            } else {
              button.value = 'Đang xử lý...';
            }
          });
        }, 0);
      });
    });
  }

  /* ──────────────────────────────────────────────────────────────────
     CLIENT-SIDE PAGINATION (TABLES & CARD LISTS) - 10 ITEMS / PAGE
     ────────────────────────────────────────────────────────────────── */
  function initPagination(tableSelector, rowsPerPage = 10) {
    const table = typeof tableSelector === 'string' ? document.querySelector(tableSelector) : tableSelector;
    if (!table || table.dataset.paginated === '1') return;

    const tbody = table.querySelector('tbody');
    if (!tbody) return;

    const allRows = Array.from(tbody.querySelectorAll('tr')).filter(tr => !tr.classList.contains('table-empty-row'));
    if (allRows.length === 0) return;

    table.dataset.paginated = '1';

    let paginationWrap = table.parentNode.querySelector('.pagination-wrapper');
    if (allRows.length <= rowsPerPage) {
      if (paginationWrap) paginationWrap.style.display = 'none';
      allRows.forEach(r => { if (r.dataset.searchHidden !== 'true') r.style.display = ''; });
      return;
    }

    if (!paginationWrap) {
      paginationWrap = document.createElement('div');
      paginationWrap.className = 'pagination-wrapper flex flex-col sm:flex-row items-center justify-between px-6 py-3.5 border-t border-slate-100 bg-white gap-3 select-none';
      table.parentNode.insertBefore(paginationWrap, table.nextSibling);
    } else {
      paginationWrap.style.display = '';
    }

    let currentPage = 1;

    function getVisibleRows() {
      return allRows.filter(r => r.dataset.searchHidden !== 'true');
    }

    function renderPage(page) {
      const visibleRows = getVisibleRows();
      const totalPages = Math.max(1, Math.ceil(visibleRows.length / rowsPerPage));
      currentPage = Math.min(Math.max(1, page), totalPages);

      allRows.forEach(r => r.style.display = 'none');

      const start = (currentPage - 1) * rowsPerPage;
      const end = start + rowsPerPage;
      visibleRows.slice(start, end).forEach(r => r.style.display = '');

      renderControls(visibleRows, totalPages);
      refreshIcons();
    }

    function renderControls(visibleRows, totalPages) {
      if (visibleRows.length <= rowsPerPage) {
        paginationWrap.innerHTML = `
          <div class="text-xs text-slate-500 font-medium">
            Hiển thị <span class="font-bold text-slate-900">${visibleRows.length}</span> bản ghi
          </div>
        `;
        return;
      }

      const startIdx = (currentPage - 1) * rowsPerPage + 1;
      const endIdx = Math.min(currentPage * rowsPerPage, visibleRows.length);

      let html = `
        <div class="text-xs text-slate-500 font-medium">
          Hiển thị <span class="font-bold text-slate-900">${startIdx}</span> - <span class="font-bold text-slate-900">${endIdx}</span> trong số <span class="font-bold text-slate-900">${visibleRows.length}</span> bản ghi
        </div>
        <div class="flex items-center gap-1.5 flex-wrap">
          <button type="button" class="btn-page btn-prev px-3 py-1.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-600 hover:bg-slate-100 transition-colors disabled:opacity-40 disabled:cursor-not-allowed" ${currentPage === 1 ? 'disabled' : ''}>Trước</button>
      `;

      for (let i = 1; i <= totalPages; i++) {
        if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
          if (i === currentPage) {
            html += `<button type="button" class="btn-page px-3 py-1.5 rounded-xl bg-sky-600 text-white text-xs font-bold shadow-xs transition-colors">${i}</button>`;
          } else {
            html += `<button type="button" data-page="${i}" class="btn-page px-3 py-1.5 rounded-xl border border-slate-200 text-slate-700 hover:bg-slate-100 text-xs font-semibold transition-colors">${i}</button>`;
          }
        } else if (i === currentPage - 2 || i === currentPage + 2) {
          html += `<span class="px-1.5 text-slate-400 text-xs font-bold">...</span>`;
        }
      }

      html += `
          <button type="button" class="btn-page btn-next px-3 py-1.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-600 hover:bg-slate-100 transition-colors disabled:opacity-40 disabled:cursor-not-allowed" ${currentPage === totalPages ? 'disabled' : ''}>Tiếp</button>
        </div>
      `;

      paginationWrap.innerHTML = html;

      paginationWrap.querySelectorAll('button[data-page]').forEach(btn => {
        btn.addEventListener('click', () => renderPage(parseInt(btn.dataset.page)));
      });

      const prevBtn = paginationWrap.querySelector('.btn-prev');
      if (prevBtn) prevBtn.addEventListener('click', () => { if (currentPage > 1) renderPage(currentPage - 1); });

      const nextBtn = paginationWrap.querySelector('.btn-next');
      if (nextBtn) nextBtn.addEventListener('click', () => { if (currentPage < totalPages) renderPage(currentPage + 1); });
    }

    renderPage(1);
    table._renderPagination = () => renderPage(1);
  }

  /* Phân trang danh sách thẻ (Card Grids, Notifications, Topics) - 10 mục / trang */
  function initListPagination(listSelector, itemsPerPage = 10) {
    const list = typeof listSelector === 'string' ? document.querySelector(listSelector) : listSelector;
    if (!list || list.dataset.paginated === '1') return;

    const allItems = Array.from(list.querySelectorAll('[data-pagination-item]'));
    if (allItems.length === 0) return;

    list.dataset.paginated = '1';

    let controls = list.parentNode.querySelector('[data-pagination-controls]');
    if (allItems.length <= itemsPerPage) {
      if (controls) controls.style.display = 'none';
      allItems.forEach(item => { if (item.dataset.searchHidden !== 'true') item.style.display = ''; });
      return;
    }

    if (!controls) {
      controls = document.createElement('div');
      controls.setAttribute('data-pagination-controls', '');
      controls.className = 'pagination-controls mt-6 flex flex-col sm:flex-row items-center justify-between p-4 bg-white rounded-2xl border border-slate-200 shadow-xs gap-3 select-none';
      list.parentNode.insertBefore(controls, list.nextSibling);
    } else {
      controls.style.display = '';
      controls.className = 'pagination-controls mt-6 flex flex-col sm:flex-row items-center justify-between p-4 bg-white rounded-2xl border border-slate-200 shadow-xs gap-3 select-none';
    }

    let currentPage = 1;

    function getVisibleItems() {
      return allItems.filter(item => item.dataset.searchHidden !== 'true');
    }

    function renderPage(page) {
      const visibleItems = getVisibleItems();
      const totalPages = Math.max(1, Math.ceil(visibleItems.length / itemsPerPage));
      currentPage = Math.min(Math.max(1, page), totalPages);

      allItems.forEach(item => item.style.display = 'none');

      const start = (currentPage - 1) * itemsPerPage;
      const end = start + itemsPerPage;
      visibleItems.slice(start, end).forEach(item => item.style.display = '');

      renderControls(visibleItems, totalPages);
      refreshIcons();
    }

    function renderControls(visibleItems, totalPages) {
      if (visibleItems.length <= itemsPerPage) {
        controls.innerHTML = `
          <div class="text-xs text-slate-500 font-medium">
            Hiển thị <span class="font-bold text-slate-900">${visibleItems.length}</span> mục
          </div>
        `;
        return;
      }

      const startIdx = (currentPage - 1) * itemsPerPage + 1;
      const endIdx = Math.min(currentPage * itemsPerPage, visibleItems.length);

      let html = `
        <div class="text-xs text-slate-500 font-medium">
          Hiển thị <span class="font-bold text-slate-900">${startIdx}</span> - <span class="font-bold text-slate-900">${endIdx}</span> trong số <span class="font-bold text-slate-900">${visibleItems.length}</span> mục
        </div>
        <div class="flex items-center gap-1.5 flex-wrap">
          <button type="button" class="btn-page btn-prev px-3 py-1.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-600 hover:bg-slate-100 transition-colors disabled:opacity-40 disabled:cursor-not-allowed" ${currentPage === 1 ? 'disabled' : ''}>Trước</button>
      `;

      for (let i = 1; i <= totalPages; i++) {
        if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
          if (i === currentPage) {
            html += `<button type="button" class="btn-page px-3 py-1.5 rounded-xl bg-sky-600 text-white text-xs font-bold shadow-xs transition-colors">${i}</button>`;
          } else {
            html += `<button type="button" data-page="${i}" class="btn-page px-3 py-1.5 rounded-xl border border-slate-200 text-slate-700 hover:bg-slate-100 text-xs font-semibold transition-colors">${i}</button>`;
          }
        } else if (i === currentPage - 2 || i === currentPage + 2) {
          html += `<span class="px-1.5 text-slate-400 text-xs font-bold">...</span>`;
        }
      }

      html += `
          <button type="button" class="btn-page btn-next px-3 py-1.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-600 hover:bg-slate-100 transition-colors disabled:opacity-40 disabled:cursor-not-allowed" ${currentPage === totalPages ? 'disabled' : ''}>Tiếp</button>
        </div>
      `;

      controls.innerHTML = html;

      controls.querySelectorAll('button[data-page]').forEach(btn => {
        btn.addEventListener('click', () => renderPage(parseInt(btn.dataset.page)));
      });

      const prevBtn = controls.querySelector('.btn-prev');
      if (prevBtn) prevBtn.addEventListener('click', () => { if (currentPage > 1) renderPage(currentPage - 1); });

      const nextBtn = controls.querySelector('.btn-next');
      if (nextBtn) nextBtn.addEventListener('click', () => { if (currentPage < totalPages) renderPage(currentPage + 1); });
    }

    renderPage(1);
    list._renderPagination = () => renderPage(1);
  }

  /* ──────────────────────────────────────────────────────────────────
     COMMAND PALETTE (CTRL + K / ⌘K)
     ────────────────────────────────────────────────────────────────── */
  function initCommandPalette() {
    const modal = document.getElementById('searchCommandModal');
    const openBtns = document.querySelectorAll('.topbar-search-btn, [data-open-command-palette]');
    if (!modal) return;

    const input = modal.querySelector('.command-palette-input');
    const list = modal.querySelector('.command-palette-list');

    const openModal = () => {
      modal.classList.add('show');
      if (input) {
        input.value = '';
        input.focus();
        filterItems('');
      }
    };

    const closeModal = () => {
      modal.classList.remove('show');
    };

    openBtns.forEach(btn => btn.addEventListener('click', (e) => {
      e.preventDefault();
      openModal();
    }));

    modal.addEventListener('click', (e) => {
      if (e.target === modal || e.target.classList.contains('command-palette-backdrop')) {
        closeModal();
      }
    });

    document.addEventListener('keydown', (e) => {
      if ((e.ctrlKey || e.metaKey) && (e.key === 'k' || e.key === 'K')) {
        e.preventDefault();
        if (modal.classList.contains('show')) closeModal();
        else openModal();
      } else if (e.key === 'Escape' && modal.classList.contains('show')) {
        closeModal();
      }
    });

    const filterItems = (query) => {
      const q = query.toLowerCase().trim();
      const items = modal.querySelectorAll('.command-item');
      items.forEach(item => {
        const text = item.textContent.toLowerCase();
        item.style.display = !q || text.includes(q) ? 'flex' : 'none';
      });
    };

    if (input) {
      input.addEventListener('input', () => filterItems(input.value));
    }
  }

  /* ──────────────────────────────────────────────────────────────────
     SAAS DRAG & DROP FILE UPLOAD
     ────────────────────────────────────────────────────────────────── */
  function initDropzone() {
    document.querySelectorAll('.dropzone-container').forEach(zone => {
      const fileInput = zone.querySelector('input[type="file"]') || document.getElementById(zone.dataset.inputTarget);
      const preview = zone.parentElement.querySelector('.dropzone-file-preview');
      const nameInput = document.getElementById('fileNameInput');

      if (!fileInput) return;

      zone.addEventListener('click', () => fileInput.click());

      ['dragenter', 'dragover'].forEach(name => {
        zone.addEventListener(name, (e) => {
          e.preventDefault();
          zone.classList.add('is-dragover');
        });
      });

      ['dragleave', 'drop'].forEach(name => {
        zone.addEventListener(name, (e) => {
          e.preventDefault();
          zone.classList.remove('is-dragover');
        });
      });

      const handleFiles = (files) => {
        if (!files || files.length === 0) return;
        const file = files[0];
        
        // Populate fileNameInput if present and empty
        if (nameInput && !nameInput.value.trim()) {
          nameInput.value = file.name;
        }

        // Update preview card if present
        if (preview) {
          const nameEl = preview.querySelector('.dropzone-file-name');
          const sizeEl = preview.querySelector('.dropzone-file-size');
          if (nameEl) nameEl.textContent = file.name;
          if (sizeEl) {
            const sizeKb = (file.size / 1024).toFixed(1);
            const sizeMb = (file.size / (1024 * 1024)).toFixed(2);
            sizeEl.textContent = file.size > 1048576 ? `${sizeMb} MB` : `${sizeKb} KB`;
          }
          preview.classList.add('has-file');
        }

        // Trigger native onchange if attached
        if (typeof window.handleFileSelect === 'function') {
          window.handleFileSelect(files);
        }
      };

      zone.addEventListener('drop', (e) => {
        const dt = e.dataTransfer;
        if (dt && dt.files && dt.files.length > 0) {
          fileInput.files = dt.files;
          handleFiles(dt.files);
        }
      });

      fileInput.addEventListener('change', () => {
        if (fileInput.files) handleFiles(fileInput.files);
      });

      // Handle remove button
      if (preview) {
        const removeBtn = preview.querySelector('.dropzone-file-remove');
        if (removeBtn) {
          removeBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            fileInput.value = '';
            if (nameInput) nameInput.value = '';
            preview.classList.remove('has-file');
          });
        }
      }
    });
  }

  window.EnterpriseUI = {
    CTX,
    refreshIcons,
    toast,
    confirmDialog,
    postForm,
    initSidebar,
    initParallax,
    initAccordion,
    bindLiveSearch,
    initFormStates,
    initPagination,
    initListPagination,
    initCommandPalette,
    initDropzone
  };

  document.addEventListener('DOMContentLoaded', () => {
    refreshIcons();
    initSidebar();
    initParallax();
    initAccordion();
    initFormStates();
    initCommandPalette();
    initDropzone();
    
    // Auto-init for common tables with class .datatable-pagination (default 10 rows)
    document.querySelectorAll('.datatable-pagination').forEach(table => {
      if (!table.id) {
        table.id = 'table_' + Math.random().toString(36).substr(2, 9);
      }
      initPagination('#' + table.id, parseInt(table.dataset.pageSize || 10));
    });
    
    // Also init all specific table IDs with 10 rows
    const knownTables = [
      '#topicsTable', '#usersTable', '#groupsTable', '#councilsTable', 
      '#reportsTable', '#periodsTable', '#regsTable', '#adminNotificationsTable',
      '#lecturerTopicsTable', '#lecturerGroupsTable', '#lecturersTable', 
      '#studentsTable', '#adminsTable'
    ];
    knownTables.forEach(selector => {
      if (document.querySelector(selector)) {
        initPagination(selector, 10);
      }
    });

    // Auto-init any remaining tables inside .table-shell if they have > 10 rows
    document.querySelectorAll('.table-shell table').forEach(table => {
      if (!table.id) {
        table.id = 'table_' + Math.random().toString(36).substr(2, 9);
      }
      initPagination('#' + table.id, 10);
    });

    // Auto-init all card and notification lists with data-pagination-list (10 items / page)
    document.querySelectorAll('[data-pagination-list]').forEach(list => {
      initListPagination(list, parseInt(list.dataset.pageSize || 10));
    });
  });
})(window);
