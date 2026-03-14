# Design Document — Dashboard Redesign (Phase 3.5.1)

## Overview

This design covers the refactoring and extension of `DashboardScreen` to deliver a polished Employee Self-Service portal. The key changes are:

- A **two-column layout** on wide screens (≥1024 px): main content (4/5) + Right_Sidebar (1/5).
- A **Search_Bar** that filters the 12 service tiles locally.
- A **flat-design Service_Grid** with responsive column counts (2/3/4).
- A **Right_Sidebar** containing a Notification_Panel (ListView, max 10) and a custom Calendar_Widget (no external packages).
- Full integration with the existing `DashboardBloc`; search state is local only.

The existing `DashboardScreen` already has a working service grid and action buttons. This redesign refactors the layout structure and adds the sidebar, search, and calendar without changing the BLoC or data layer.

---

## Architecture

The feature lives entirely within `lib/features/dashboard/` following the project's feature-based folder convention.

```
lib/features/dashboard/
├── screens/
│   └── dashboard_screen.dart        ← refactored (layout + search state)
├── widgets/
│   ├── notification_widget.dart     ← existing, unchanged
│   ├── leave_balance_widget.dart    ← existing, unchanged
│   ├── activity_feed_widget.dart    ← existing, unchanged
│   ├── upcoming_events_widget.dart  ← existing, unchanged
│   ├── service_grid.dart            ← NEW: stateful, owns search query
│   ├── right_sidebar.dart           ← NEW: composes NotificationPanel + CalendarWidget
│   ├── notification_panel.dart      ← NEW: sidebar notification list
│   └── calendar_widget.dart         ← NEW: custom month calendar
└── bloc/
    ├── dashboard_bloc.dart          ← existing, unchanged
    ├── dashboard_event.dart         ← existing (MarkNotificationRead already present)
    └── dashboard_state.dart         ← existing, unchanged
```

No new BLoC, repository, or route changes are required. `MarkNotificationRead` already exists in `dashboard_event.dart`.

### Layout Strategy

```
DashboardScreen
└── AppShell
    └── BlocBuilder<DashboardBloc>
        └── LayoutBuilder          ← single breakpoint check (≥1024px)
            ├── [wide]  Row
            │           ├── Expanded(flex:4)  ← main content (scrollable)
            │           └── Expanded(flex:1)  ← Right_Sidebar (fixed)
            └── [narrow] SingleChildScrollView
                          └── Column
                              ├── main content
                              └── Right_Sidebar (stacked)
```

`LayoutBuilder` is used **only** for the 1024 px breakpoint. The service grid uses its own inner `LayoutBuilder` for the 600/900 px column-count breakpoints.

---

## Components and Interfaces

### `DashboardScreen` / `DashboardView`

- Provides `BlocProvider<DashboardBloc>`.
- Uses `LayoutBuilder` to switch between two-column `Row` and single-column `Column`.
- In two-column mode: main content column is wrapped in `SingleChildScrollView`; `Right_Sidebar` is wrapped in a separate scroll context so it stays fixed relative to the viewport.
- Passes `DashboardData` down to child widgets.

### `ServiceGrid` (StatefulWidget)

```dart
class ServiceGrid extends StatefulWidget {
  const ServiceGrid({super.key});
}
```

- Owns `TextEditingController` and `String _query` state.
- Renders the Search_Bar (`TextField`) and the `GridView.builder`.
- Filters the static 12-item service list by `_query` (case-insensitive `contains`).
- Uses an inner `LayoutBuilder` to set `crossAxisCount`: `width >= 900 → 4`, `width >= 600 → 3`, else `2`.
- Shows "No services found" `Text` when filtered list is empty.
- Disposes the controller in `dispose()`.

### `RightSidebar`

```dart
class RightSidebar extends StatelessWidget {
  final List<Notification> notifications;
  const RightSidebar({super.key, required this.notifications});
}
```

- Composes `NotificationPanel` and `CalendarWidget` in a `Column`.
- Wrapped in a `SingleChildScrollView` so it can scroll independently on very small heights.

### `NotificationPanel`

```dart
class NotificationPanel extends StatelessWidget {
  final List<Notification> notifications;
  const NotificationPanel({super.key, required this.notifications});
}
```

- Displays "Latest Notifications" heading.
- Renders `ListView` (shrinkWrap, NeverScrollableScrollPhysics inside sidebar scroll) of up to 10 items using the existing `NotificationWidget`.
- Shows "No new notifications" when list is empty.
- Shows "View all" `TextButton` when `notifications.length > 10`.
- Dispatches `MarkNotificationRead` via `context.read<DashboardBloc>()` on tile tap.

### `CalendarWidget`

```dart
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
}
```

- Owns `DateTime _focusedMonth` state (initialised to `DateTime.now()`).
- Renders a header row: left arrow `IconButton`, month/year `Text`, right arrow `IconButton`.
- Renders a 7-column `GridView` of day-of-week labels (Mon–Sun).
- Renders a `GridView` of day cells for the focused month, with leading empty cells for the first weekday offset.
- Today's date cell uses `AppColors.blue` background with white text; other cells use default theme.
- No external packages.

---

## Data Models

No new models are required. All data comes from the existing `DashboardData`:

| Field | Type | Used by |
|---|---|---|
| `notifications` | `List<Notification>` | `NotificationPanel` |
| `leaveBalance` | `LeaveBalance` | `LeaveBalanceWidget` (unchanged) |
| `activityFeed` | `List<ActivityItem>` | `ActivityFeedWidget` (unchanged) |
| `upcomingEvents` | `List<UpcomingEvent>` | `UpcomingEventsWidget` (unchanged) |
| `userSummary` | `UserSummary` | Welcome section (unchanged) |

The 12 service tiles are a **static list** defined inside `ServiceGrid` — they are not fetched from the BLoC or backend.

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system — essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Layout switches at 1024 px breakpoint

*For any* screen width, the dashboard SHALL render a two-column `Row` layout when width ≥ 1024 px and a single-column `Column` layout when width < 1024 px, with no hardcoded pixel widths for the column split (only `Expanded(flex:4)` and `Expanded(flex:1)`).

**Validates: Requirements 1.1, 1.2, 1.3, 6.1, 6.2, 6.4**

---

### Property 2: Service grid column count matches breakpoints

*For any* available width passed to the service grid's `LayoutBuilder`, the `GridView` `crossAxisCount` SHALL be 4 when width ≥ 900 px, 3 when 600 px ≤ width < 900 px, and 2 when width < 600 px.

**Validates: Requirements 3.3, 3.4, 3.5, 6.3**

---

### Property 3: Search filter correctness

*For any* non-empty search query string, the set of displayed service tiles SHALL be exactly those tiles whose label contains the query string (case-insensitive), and no others.

**Validates: Requirements 2.2**

---

### Property 4: Notification panel cap and "View all" invariant

*For any* list of notifications from `DashboardBloc`, the `NotificationPanel` SHALL display at most 10 items, and SHALL show a "View all" link if and only if the total notification count exceeds 10.

**Validates: Requirements 4.6**

---

### Property 5: Unread notification visual distinction

*For any* notification in the panel, if `notification.isRead == false` then the rendered tile SHALL have a visual distinction (bold title or unread indicator) compared to a read notification.

**Validates: Requirements 4.3**

---

### Property 6: MarkNotificationRead dispatched on tap

*For any* notification tile tapped in the `NotificationPanel`, the `DashboardBloc` SHALL receive exactly one `MarkNotificationRead` event carrying that notification's `id`.

**Validates: Requirements 4.4**

---

### Property 7: Calendar month navigation round-trip

*For any* focused month M, tapping the next-month arrow then the previous-month arrow SHALL return the calendar to displaying month M.

**Validates: Requirements 5.3**

---

### Property 8: No layout overflow across screen widths

*For any* screen width between 320 px and 2560 px, the `DashboardScreen` SHALL render without overflow errors.

**Validates: Requirements 6.5**

---

## Error Handling

| Scenario | Behaviour |
|---|---|
| `DashboardBloc` emits `DashboardLoading` | Show `CircularProgressIndicator` centred on screen |
| `DashboardBloc` emits `DashboardError` | Show error icon, message text, and "Retry" button that dispatches `LoadDashboard` |
| Search query matches zero tiles | Show "No services found" text inside the grid area |
| Notification list is empty | Show "No new notifications" text inside `NotificationPanel` |
| `MarkNotificationRead` fails | BLoC logs the error silently; no error state emitted (existing behaviour) |
| Calendar month navigation | Pure local state; no error conditions |

---

## Testing Strategy

### Unit Tests

- `ServiceGrid` filter logic: verify filtered list for various query strings (empty, partial match, case variants, no match).
- `CalendarWidget` month navigation: verify `_focusedMonth` changes correctly on prev/next tap.
- `NotificationPanel` cap: verify only first 10 items are rendered when list has >10 items.

### Property-Based Tests

Use the `test` package with manual generators (or `fast_check`-style helpers) since the project does not currently include a PBT library. Each property test runs a minimum of **100 iterations** with randomised inputs.

**Property 1 — Layout breakpoint**
```
// Feature: dashboard-redesign, Property 1: layout switches at 1024px breakpoint
// For 100 random widths: verify Row present iff width >= 1024, Column otherwise
```

**Property 2 — Grid column count**
```
// Feature: dashboard-redesign, Property 2: service grid column count matches breakpoints
// For 100 random widths: verify crossAxisCount == expected per breakpoint rules
```

**Property 3 — Search filter correctness**
```
// Feature: dashboard-redesign, Property 3: search filter correctness
// For 100 random query strings: displayed tiles == tiles where label.toLowerCase().contains(query.toLowerCase())
```

**Property 4 — Notification cap**
```
// Feature: dashboard-redesign, Property 4: notification panel cap and view-all invariant
// For 100 random list sizes (0–50): rendered count <= 10, "View all" shown iff count > 10
```

**Property 5 — Unread visual distinction**
```
// Feature: dashboard-redesign, Property 5: unread notification visual distinction
// For 100 random notification lists: every unread item has bold FontWeight in rendered widget
```

**Property 6 — MarkNotificationRead on tap**
```
// Feature: dashboard-redesign, Property 6: MarkNotificationRead dispatched on tap
// For 100 random notification lists: tapping item at index i dispatches MarkNotificationRead(notifications[i].id)
```

**Property 7 — Calendar round-trip**
```
// Feature: dashboard-redesign, Property 7: calendar month navigation round-trip
// For 100 random starting months: next then prev returns to original month
```

**Property 8 — No overflow**
```
// Feature: dashboard-redesign, Property 8: no layout overflow across screen widths
// For widths [320, 375, 600, 900, 1024, 1280, 1920, 2560]: no RenderFlex overflow errors
```

### Widget Tests (Examples)

- Search bar renders with placeholder "Search services, documents".
- All 12 service tiles render in correct order when query is empty.
- Tapping Documents tile shows download dialog.
- Tapping a non-Documents tile triggers `go_router` navigation to the correct route.
- `DashboardLoading` state → `CircularProgressIndicator` visible.
- `DashboardError` state → error message and retry button visible; tapping retry dispatches `LoadDashboard`.
- Pull-to-refresh dispatches `RefreshDashboard`.
- "Latest Notifications" heading present in sidebar.
- Today's date cell in `CalendarWidget` has `AppColors.blue` background.
- "Employee Self-Service" heading and `Divider` present above grid.
