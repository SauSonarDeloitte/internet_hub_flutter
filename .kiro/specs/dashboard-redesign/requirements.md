# Requirements Document

## Introduction

This feature redesigns the HR App dashboard screen (Phase 3.5.1) to deliver a polished Employee Self-Service portal layout. The redesign introduces a two-column page structure on wider screens (main content area + right sidebar), a flat-design service grid with 12 service options, a "Search services, documents" bar, a latest-notifications panel, and a calendar widget. The layout must be fully responsive across mobile, tablet, desktop, and web.

The existing dashboard screen already contains a working service grid and action buttons; this spec captures the remaining and refined requirements to complete Phase 3.5.1.

---

## Glossary

- **Dashboard_Screen**: The main screen rendered at the `/dashboard` route.
- **Service_Grid**: The responsive grid of Employee Self-Service option tiles.
- **Service_Tile**: A single flat-design item in the Service_Grid — blue icon centred at top, black label at bottom, no card elevation.
- **Right_Sidebar**: The 1/5-width column on the right side of the dashboard, visible on wide screens (≥1024 px), containing the Notification_Panel and Calendar_Widget.
- **Notification_Panel**: A scrollable list of the employee's latest notifications inside the Right_Sidebar.
- **Calendar_Widget**: An inline monthly calendar inside the Right_Sidebar.
- **Search_Bar**: The "Search services, documents" input field displayed in the top-right area of the main content column.
- **Responsive_Breakpoints**: Mobile < 600 px, Tablet 600–1023 px, Desktop/Web ≥ 1024 px.
- **DashboardBloc**: The existing BLoC that manages dashboard state (load, refresh, mark-notification-read).
- **AppShell**: The shared layout wrapper that provides the navigation drawer/sidebar and app bar.

---

## Requirements

### Requirement 1: Two-Column Page Layout

**User Story:** As an employee, I want the dashboard to use screen space efficiently on large displays, so that I can see service options and sidebar information at the same time without scrolling.

#### Acceptance Criteria

1. WHEN the Dashboard_Screen renders on a screen width ≥ 1024 px, THE Dashboard_Screen SHALL display a two-column layout where the main content column occupies 4/5 of the available width and the Right_Sidebar occupies 1/5 of the available width.
2. WHEN the Dashboard_Screen renders on a screen width < 1024 px, THE Dashboard_Screen SHALL display a single-column layout where the Right_Sidebar content is stacked below the main content.
3. THE Dashboard_Screen SHALL use `LayoutBuilder` to determine the active layout breakpoint (≥1024 px vs < 1024 px), and SHALL use a `Row` with `Expanded` (flex: 4) for the main content column and `Expanded` (flex: 1) for the Right_Sidebar to achieve the 4/5 and 1/5 width split — with no hardcoded pixel widths for the column split.
4. WHILE the two-column layout is active, THE Right_Sidebar SHALL remain fixed in position as the main content column scrolls independently.

---

### Requirement 2: Search Bar

**User Story:** As an employee, I want a search bar at the top of the service section, so that I can quickly find services or documents without scrolling through the grid.

#### Acceptance Criteria

1. THE Dashboard_Screen SHALL display a Search_Bar with placeholder text "Search services, documents" positioned in the top-right area of the main content column, above the Service_Grid.
2. WHEN the employee enters text into the Search_Bar, THE Service_Grid SHALL filter Service_Tiles to show only those whose labels contain the entered text (case-insensitive).
3. WHEN the Search_Bar is empty, THE Service_Grid SHALL display all 12 Service_Tiles.
4. IF the Search_Bar filter produces zero matching Service_Tiles, THEN THE Service_Grid SHALL display an empty-state message "No services found".
5. THE Search_Bar SHALL be implemented as a stateful widget that holds the current query and triggers a rebuild of the Service_Grid on each text change.

---

### Requirement 3: Employee Self-Service Grid

**User Story:** As an employee, I want a clear, flat-design grid of service shortcuts, so that I can navigate to any HR service in one tap.

#### Acceptance Criteria

1. THE Service_Grid SHALL display exactly the following 12 Service_Tiles in order: Team Directory, Policies, Benefits, Leave/Attendance, Compensation, Recognition - GEM, Health & Wellness, Holiday Calendar, Documents, Travel, BOLT - Start Learning!, Idea Management Portal.
2. EACH Service_Tile SHALL render a blue (`AppColors.blue`) icon centred horizontally at the top and a black text label centred at the bottom, with no card elevation or background fill (flat design).
3. WHEN the screen width is ≥ 900 px, THE Service_Grid SHALL render 4 columns.
4. WHEN the screen width is ≥ 600 px and < 900 px, THE Service_Grid SHALL render 3 columns.
5. WHEN the screen width is < 600 px, THE Service_Grid SHALL render 2 columns.
6. WHEN an employee taps a Service_Tile (other than Documents), THE Dashboard_Screen SHALL navigate to the corresponding route defined in `RouteNames`.
7. WHEN an employee taps the Documents Service_Tile, THE Dashboard_Screen SHALL display a download dialog offering "About Bajaj Auto" and "Code of Conduct" options.
8. THE Service_Grid SHALL be preceded by an "Employee Self-Service" section heading with a horizontal divider.

---

### Requirement 4: Right Sidebar — Notification Panel

**User Story:** As an employee, I want to see my latest notifications in the sidebar, so that I can stay informed without leaving the dashboard.

#### Acceptance Criteria

1. THE Notification_Panel SHALL display a "Latest Notifications" section heading inside the Right_Sidebar.
2. THE Notification_Panel SHALL render a scrollable `ListView` of the employee's notifications sourced from the existing `DashboardBloc` loaded state.
3. WHEN a notification has not been read, THE Notification_Panel SHALL visually distinguish it (e.g. bold text or an unread indicator dot).
4. WHEN an employee taps a notification in the Notification_Panel, THE DashboardBloc SHALL receive a `MarkNotificationRead` event for that notification's id.
5. IF the notification list is empty, THEN THE Notification_Panel SHALL display the message "No new notifications".
6. THE Notification_Panel SHALL display a maximum of 10 notifications; WHEN more than 10 exist, THE Notification_Panel SHALL show a "View all" link that navigates to a full notifications screen.

---

### Requirement 5: Right Sidebar — Calendar Widget

**User Story:** As an employee, I want to see a monthly calendar in the sidebar, so that I can quickly check dates and upcoming events without switching screens.

#### Acceptance Criteria

1. THE Calendar_Widget SHALL display an inline monthly calendar below the Notification_Panel inside the Right_Sidebar.
2. THE Calendar_Widget SHALL highlight today's date visually using the app's primary blue colour.
3. THE Calendar_Widget SHALL allow the employee to navigate to the previous and next month using arrow controls.
4. WHEN the Dashboard_Screen is in single-column layout (width < 1024 px), THE Calendar_Widget SHALL be rendered below the Notification_Panel in the stacked layout.
5. THE Calendar_Widget SHALL be implemented without external calendar packages, using Flutter's built-in `TableCalendar`-style grid or a custom `GridView`-based widget.

---

### Requirement 6: Responsive Layout Integrity

**User Story:** As an employee using the app on any device, I want the dashboard to look correct and be usable regardless of screen size, so that I have a consistent experience on mobile, tablet, and desktop.

#### Acceptance Criteria

1. THE Dashboard_Screen SHALL use responsive layout widgets (`LayoutBuilder`, `Row`, `Expanded`, `Flexible`, `Column`) and SHALL NOT contain hardcoded pixel widths for major layout regions.
2. WHEN the screen width changes (e.g. browser resize on web), THE Dashboard_Screen SHALL re-render the appropriate layout without requiring a full page reload.
3. THE Service_Grid column count SHALL adjust automatically per Requirement 3 criteria (2 / 3 / 4 columns) as the screen width changes.
4. WHILE the two-column layout is active, THE Right_Sidebar width SHALL be expressed as `Expanded(flex: 1)` within a `Row` alongside the main content column's `Expanded(flex: 4)`, achieving the 1/5 ratio without any fixed pixel value.
5. THE Dashboard_Screen SHALL render without overflow errors on screen widths from 320 px to 2560 px.

---

### Requirement 7: State Management Integration

**User Story:** As a developer, I want the dashboard redesign to integrate cleanly with the existing DashboardBloc, so that data loading, refresh, and notification interactions continue to work correctly.

#### Acceptance Criteria

1. THE Dashboard_Screen SHALL continue to use the existing `DashboardBloc` for all data (notifications, leave balance, activity feed, upcoming events).
2. WHEN the `DashboardBloc` emits a `DashboardLoading` state, THE Dashboard_Screen SHALL display a `CircularProgressIndicator`.
3. WHEN the `DashboardBloc` emits a `DashboardError` state, THE Dashboard_Screen SHALL display an error message and a retry button that dispatches `LoadDashboard`.
4. WHEN the employee performs a pull-to-refresh gesture, THE Dashboard_Screen SHALL dispatch `RefreshDashboard` to the `DashboardBloc`.
5. THE Search_Bar query state SHALL be managed locally within the dashboard widget and SHALL NOT be persisted to `DashboardBloc` or `HydratedBloc`.
