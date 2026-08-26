/**
 * HCMUTE Thesis Portal — Enterprise UI helpers
 * Lucide + SweetAlert2 + Fetch utilities (no page reload where possible)
 */
(function (window) {
  'use strict';

  const CTX = document.body?.dataset?.contextPath || '';

  function refreshIcons() {
    if (typeof lucide !== 'undefined') lucide.createIcons();
  }

  function toast(icon, title, text) {
    return Swal.fire({
      toast: true,
      position: 'top-end',
      icon,
      title,
      text: text || undefined,
      timer: 3200,
      showConfirmButton: false,
      customClass: { popup: 'rounded-2xl shadow-lg border border-slate-100' }
    });
  }

  function confirmDialog(opts) {
    return Swal.fire({
      icon: opts.icon || 'warning',
      title: opts.title || 'Xác nhận',
      text: opts.text || '',
      showCancelButton: true,
      confirmButtonColor: opts.confirmColor || '#2563eb',
      cancelButtonColor: '#64748b',
      confirmButtonText: opts.confirmText || 'Đồng ý',
      cancelButtonText: opts.cancelText || 'Hủy',
      customClass: { popup: 'rounded-2xl shadow-xl' }
    });
  }

  async function postForm(url, data) {
    const body = new URLSearchParams();
    Object.entries(data || {}).forEach(([k, v]) => {
      if (v !== undefined && v !== null) body.append(k, v);
    });
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
      body: body.toString()
    });
    const contentType = res.headers.get('content-type') || '';
    if (contentType.includes('application/json')) return res.json();
    return { success: res.ok, message: res.ok ? 'Thành công' : 'Có lỗi xảy ra' };
  }

  function initSidebar() {
    const wrapper = document.querySelector('.app-wrapper');
    const sidebar = document.querySelector('.app-sidebar');
    const toggleBtn = document.getElementById('sidebarToggleBtn');
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
        document.getElementById('sidebarOverlay')?.classList.toggle('show');
      }
      setTimeout(refreshIcons, 50);
    });

    document.getElementById('sidebarOverlay')?.addEventListener('click', () => {
      sidebar.classList.remove('show');
      document.getElementById('sidebarOverlay')?.classList.remove('show');
    });
  }

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
        row.style.display = !q || row.innerText.toLowerCase().includes(q) ? '' : 'none';
      });
    });
  }

  window.EnterpriseUI = {
    CTX,
    refreshIcons,
    toast,
    confirmDialog,
    postForm,
    initSidebar,
    initAccordion,
    bindLiveSearch
  };

  document.addEventListener('DOMContentLoaded', () => {
    refreshIcons();
    initSidebar();
    initAccordion();
  });
})(window);
