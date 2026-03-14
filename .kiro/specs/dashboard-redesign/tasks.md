# Tasks — Dashboard Redesign (Phase 3.5.1)

## Task List

- [x] 1. Create `ServiceGrid` stateful widget
  - [x] 1.1 Create `lib/features/dashboard/widgets/service_grid.dart` with `TextEditingController` and `_query` state
  - [x] 1.2 Implement inner `LayoutBuilder` for crossAxisCount (≥900→4, ≥600→3, else 2)
  - [x] 1.3 Implement case-insensitive label filter; show "No services found" on empty results
  - [x] 1.4 Render Search_Bar `TextField` with placeholder "Search services, documents" above the grid
  - [x] 1.5 Dispose `TextEditingController` in `dispose()`

- [x] 2. Create `CalendarWidget` stateful widget
  - [x] 2.1 Create `lib/features/dashboard/widgets/calendar_widget.dart` with `_focusedMonth` state
  - [x] 2.2 Render header row: prev arrow, "Month Year" text, next arrow
  - [x] 2.3 Render 7-column day-of-week label row (Mon–Sun)
  - [x] 2.4 Render day cells `GridView` with correct leading empty cells for first-weekday offset
  - [x] 2.5 Highlight today's date with `AppColors.blue` background and white text

- [x] 3. Create `NotificationPanel` widget
  - [x] 3.1 Create `lib/features/dashboard/widgets/notification_panel.dart`
  - [x] 3.2 Render "Latest Notifications" heading
  - [x] 3.3 Render `ListView` (shrinkWrap) of up to 10 notifications using existing `NotificationWidget`
  - [x] 3.4 Show "No new notifications" text when list is empty
  - [x] 3.5 Show "View all" `TextButton` when notification count > 10
  - [x] 3.6 Dispatch `MarkNotificationRead` event on notification tap via `context.read<DashboardBloc>()`

- [x] 4. Create `RightSidebar` widget
  - [x] 4.1 Create `lib/features/dashboard/widgets/right_sidebar.dart`
  - [x] 4.2 Compose `NotificationPanel` above `CalendarWidget` in a `Column` inside a `SingleChildScrollView`

- [x] 5. Refactor `DashboardScreen` for two-column layout
  - [x] 5.1 Wrap `DashboardView` body in a `LayoutBuilder` that checks `constraints.maxWidth >= 1024`
  - [x] 5.2 For wide layout: render `Row` with `Expanded(flex:4)` main content + `Expanded(flex:1)` `RightSidebar`
  - [x] 5.3 For narrow layout: render `SingleChildScrollView > Column` with main content then `RightSidebar` stacked below
  - [x] 5.4 Replace inline service grid and search logic with the new `ServiceGrid` widget
  - [x] 5.5 Pass `data.notifications` to `RightSidebar`; remove the old inline notification section from main content
  - [x] 5.6 Ensure main content column is independently scrollable in two-column mode (`SingleChildScrollView`)

- [x] 6. Write tests
  - [x] 6.1 Unit test: `ServiceGrid` filter — empty query returns all 12, partial match returns subset, no match returns empty
  - [x] 6.2 Unit test: `CalendarWidget` month navigation — next then prev returns to original month (Property 7)
  - [x] 6.3 Unit test: `NotificationPanel` cap — list of 11 renders 10 items and shows "View all"
  - [x] 6.4 Widget test: `DashboardScreen` at width 1200 renders `Row` with two `Expanded` children (Property 1)
  - [x] 6.5 Widget test: `DashboardScreen` at width 800 renders single-column `Column` (Property 1)
  - [x] 6.6 Widget test: `ServiceGrid` at widths 320, 650, 950 renders correct crossAxisCount (Property 2)
  - [x] 6.7 Widget test: search filter — for random queries displayed tiles match case-insensitive contains (Property 3)
  - [x] 6.8 Widget test: tapping notification dispatches `MarkNotificationRead` with correct id (Property 6)
  - [x] 6.9 Widget test: `DashboardLoading` → `CircularProgressIndicator`; `DashboardError` → error UI + retry
  - [x] 6.10 Widget test: tapping Documents tile shows download dialog; tapping other tile triggers navigation
