# UI Redesign Plan

## 1. Product Direction

ASM_WEB_UTE will use an **HCMUTE Academic Technology** visual language: a serious university management product with premium SaaS clarity, restrained futuristic depth, and lightweight 3D accents.

Core principle:

> Clarity and task completion come before decoration.

The redesign keeps the existing Java Spring Boot MVC, JSP, JSTL, session authentication, controller mappings, services, repositories, entities, DTOs, database schema, and form contracts unchanged.

## 2. Current Frontend Inventory

### Shared application shell

The authenticated screens use the following shared JSPs:

- `src/main/webapp/views/common/header.jsp`
- `src/main/webapp/views/common/navbar.jsp`
- `src/main/webapp/views/common/sidebar.jsp`
- `src/main/webapp/views/common/footer.jsp`
- `src/main/webapp/assets/css/custom-theme.css`
- `src/main/webapp/assets/js/enterprise-ui.js`

There is also a legacy `views/layout/` set. It is not the active include path for the current admin, lecturer, and student screens and should not become a second design system.

### Public screens

- `views/index.jsp`: public topic catalog and portal home.
- `views/login.jsp`: custom session login form.
- `views/register.jsp`: registration form bound to `/register`.

### Admin screens and backend routes

- `admin/dashboard.jsp`
- `admin/topics.jsp`
- `admin/periods.jsp`
- `admin/registrations.jsp`
- `admin/groups.jsp`
- `admin/reports.jsp`
- `admin/councils.jsp`
- `admin/results.jsp`
- `admin/users.jsp`
- `admin/notifications.jsp`

Routes are owned by `AdminController` under dashboard, periods, topics, registrations, groups, councils, results, reports, notifications, and users.

### Lecturer screens and backend routes

- `lecturer/dashboard.jsp`
- `lecturer/topics.jsp`
- `lecturer/groups.jsp`
- `lecturer/reports.jsp`
- `lecturer/report-detail.jsp`
- `lecturer/grading.jsp`
- `lecturer/councils.jsp`
- `lecturer/notifications.jsp`

Routes are owned by `LecturerController`, including AJAX grading and report approval/rejection.

### Student screens and backend routes

- `student/dashboard.jsp`
- `student/topics.jsp`
- `student/group.jsp`
- `student/reports.jsp`
- `student/results.jsp`
- `student/notifications.jsp`

Routes are owned by `StudentController`, including topic registration, group management, report upload, results, notifications, and student lookup.

## 3. Current UI Findings

### Shared components

The strongest reuse boundary is already `views/common/`. It should remain the single active shell for authenticated pages.

### Duplication and conflicts

- Tailwind CDN utilities, Bootstrap CSS, Bootstrap JS, inline JSP styles, and `custom-theme.css` are used together.
- Public home/login/register have separate styling from authenticated pages.
- `views/layout/` can become a source of accidental divergence.
- Status badges are currently expressed through repeated ad-hoc Tailwind combinations instead of one semantic component contract.
- Many pages repeat white rounded surfaces and table styles.
- Some pages use Lucide while the public home/register also load FontAwesome.
- Bootstrap dropdown behavior is coupled to the common navbar while Tailwind controls most visual styling.

### UX risks

- Dense dashboards can compete for attention between KPI, timeline, notifications, and lists.
- Tables need a consistent action hierarchy and mobile overflow strategy.
- Empty, loading, and error states are inconsistent.
- Demo quick-login controls must remain available for development but visually secondary to production navigation.
- Search and filter patterns need consistent placement and labels.

## 4. Design System

### Tokens

```css
--primary: #006da8;
--primary-dark: #003b63;
--primary-soft: #e8f4fa;
--background: #f4f8fb;
--surface: #ffffff;
--surface-muted: #eef4f7;
--text: #17324d;
--muted: #6b8192;
--border: #dce7ed;
--success: #159570;
--warning: #d88900;
--danger: #c94b4b;
--info: #178bb8;
--radius-sm: 8px;
--radius-md: 10px;
--radius-lg: 14px;
--radius-xl: 16px;
--shadow-sm: 0 4px 14px rgba(16, 42, 67, .05);
--shadow-md: 0 10px 28px rgba(16, 42, 67, .08);
--transition-fast: 160ms ease-out;
--transition-normal: 280ms ease-out;
```

### Typography

Use Plus Jakarta Sans consistently:

- Page title: 28px, 700/800.
- Section title: 18px, 700.
- Card title: 14px, 700.
- Body: 14px.
- Caption: 12px.
- Table: 13px.
- Form label: 12px, 700.

### Semantic statuses

- `PENDING`: amber.
- `APPROVED`, `ACTIVE`, `COMPLETED`: green.
- `REJECTED`: red.
- `INACTIVE`: neutral.
- Informational states: cyan.

## 5. Component Architecture

Reusable visual contracts will live in the common CSS/JS layer:

- `.app-wrapper`, `.app-sidebar`, `.app-main`.
- `.page-heading-block`.
- `.dashboard-hero`.
- `.bento-grid`.
- `.dashboard-stat`.
- `.card-custom`, `.surface`.
- `.table-shell`.
- `.status-badge` and semantic status classes.
- `.empty-state-panel`.
- `.btn-ui-primary`, `.btn-ui-outline`, and loading state.
- Form focus, error, disabled, and success states.
- Modal and notification elevation layers.
- Responsive mobile drawer and horizontal table handling.

## 6. Information Architecture

### Admin

- Overview: Dashboard.
- Project operations: Topics, registration periods, registrations, student groups.
- Evaluation: Councils, reports, results.
- System: Users, notifications.

### Lecturer

- Overview: Dashboard.
- Supervision: Topics, student groups, reports.
- Evaluation: Grading, councils.
- Communication: Notifications.

### Student

- Overview: Dashboard.
- Projects: Topic catalog, current project/group.
- Submission: Reports.
- Outcomes: Results and notifications.

## 7. Screen Strategy

### Home

- Brand header and clear CTA.
- Real campus/teamwork hero image with accessible overlay.
- Active registration period.
- Compact statistics.
- Four-step process.
- Search/filter topic catalog.
- News/notification area.
- SEO title, description, canonical, and Open Graph metadata.

### Login/Register

- Brand-led split layout or centered compact surface.
- Preserve `/login` and `/register` actions and existing input names.
- Show/hide password, remembered email, validation/error state, and loading state.
- No unsupported SSO action is added.

### Dashboards

Each dashboard follows:

1. Welcome/page header.
2. Role-specific KPI row using real model attributes.
3. Priority work queue.
4. Timeline, activity, or status distribution only where backend data exists.
5. Empty states with relevant CTA.

### Topic and project screens

- Search/filter toolbar.
- Grid/table view where useful.
- Semantic status badges.
- Clear supervisor, department, group capacity, dates, progress, and actions.
- Preserve existing registration and save forms.

### Reports and grading

- Submission dropzone and history surface for students.
- Lecturer report review and grading split layout.
- AJAX grading keeps its existing endpoint and payload.
- File download links remain unchanged.

### Groups, councils, results, users, notifications

- Use table shell, action hierarchy, semantic status, confirmation dialogs, and empty states.
- Do not invent backend data or add fake charts.

## 8. 3D Strategy

3D is a restrained accent, not a core interaction model.

Use CSS-only or lightweight HTML elements for:

- Dashboard hero geometric ring/grid.
- One featured KPI or hero object per page at most.
- Login illustration made from layered document cards and rings.
- Home hero depth through image, overlay, and subtle grid.

Rules:

- Maximum parallax rotation: 5–8 degrees.
- No 3D on tables, forms, or dense data views.
- No large Three.js dependency for simple shapes.
- Respect `prefers-reduced-motion`.
- No continuous high-frequency particle animation.

## 9. Motion Strategy

- Micro interaction: 150–200ms.
- Component transition: 250–350ms.
- Page reveal: 400–600ms.
- Card hover: translateY(-3px), subtle shadow increase.
- Button hover: translateY(-1px).
- Modal: fade + small scale.
- Toast: slide/fade from top-right.
- Form submit: button loading state and duplicate-submit prevention.

## 10. Responsive Strategy

- Desktop: fixed/collapsible sidebar and sticky compact topbar.
- Tablet: collapsed sidebar and two-column content where safe.
- Mobile: drawer sidebar, single-column bento, 44px minimum touch targets.
- Tables: horizontal scroll in a contained shell, never page overflow.
- KPI cards: four columns desktop, two tablet, one/two mobile depending content.

## 11. Accessibility and Performance

- Preserve visible keyboard focus.
- Add skip link and semantic labels.
- Use `aria-label` on icon-only buttons.
- Keep contrast suitable for body and table text.
- Support reduced motion.
- Prefer local optimized images for production; external Unsplash is acceptable for preview only.
- Avoid new heavy dependencies.
- Keep charts data-driven and do not fabricate metrics.

## 12. Implementation Phases

1. Design tokens and reusable CSS primitives.
2. Common header, sidebar, navbar, footer, and responsive shell.
3. Login and registration.
4. Admin dashboard and admin tables/forms.
5. Lecturer dashboard, reports, councils, and grading.
6. Student dashboard, topics, group, reports, and results.
7. Shared topic/project/table/filter refinements.
8. Notification, modal, toast, loading, empty, and error states.
9. Lightweight 3D hero polish and motion audit.
10. Responsive and accessibility audit.
11. Full Maven build and route/form verification.

## 13. Validation Gates

After each phase:

- Run `mvnw.cmd clean package -DskipTests`.
- Check JSP include structure.
- Confirm controller mappings are unchanged.
- Confirm form actions and input names are unchanged.
- Confirm JSTL and EL variables are preserved.
- Check login/session and role navigation.
- Check AJAX grading and report actions.
- Check desktop, tablet, and mobile layout.
- Check empty, error, disabled, and loading states.

## 14. Backend Safety

No changes are planned for:

- Entities.
- Repositories.
- Services.
- Controllers.
- DTO contracts.
- Database schema.
- Authentication or authorization.
- Sessions.
- URL mappings.
- Existing form actions and JSTL model variables.
