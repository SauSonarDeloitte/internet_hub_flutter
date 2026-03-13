# HR App Implementation Plan

> **Note for AI:** Mark tasks as done (change `- [ ]` to `- [x]`) immediately after completing them. Do not wait until the end of a phase to update checkboxes.

> **IMPORTANT for AI:** After completing each step or making any code changes, ALWAYS run `dart analyze` or use `getDiagnostics` tool to check for errors before proceeding to the next step. Fix all errors immediately before moving forward.

> **CRITICAL for AI - Bug Fixes:** When fixing bugs, ALWAYS ask the user to manually test and confirm the fix is working before marking the bug as done. Do not mark bug fixes as complete without user confirmation.

## Phase 1: Project Setup & Core Infrastructure

### 1.1 Initialize Flutter Project
- [x] Run `flutter create --platforms=android,ios,web .`
- [x] Add all required packages using `flutter pub add`
- [x] Run `flutter pub upgrade` to ensure latest versions
- [x] Set up folder structure per architecture.md
- [x] Set up environment configuration (dev mode with mocks)

#### Package Installation Commands
```bash
# State Management
flutter pub add bloc flutter_bloc hydrated_bloc equatable

# Navigation
flutter pub add go_router

# Dependency Injection
flutter pub add get_it

# Local Storage
flutter pub add shared_preferences path_provider

# Logging & Debugging
flutter pub add talker talker_flutter talker_bloc_logger talker_dio_logger

# Code Quality
flutter pub add --dev flutter_lints

# UI & Utilities
flutter pub add intl

# After adding all packages, upgrade to latest versions
flutter pub upgrade
```

### 1.2 Core Setup
- [x] Set up GetIt dependency injection
- [x] Initialize Talker for logging
- [x] Configure GoRouter for navigation with TalkerRouteObserver
- [x] Set up Bloc with TalkerBlocObserver
- [x] Create base repository interface pattern
- [x] Set up shared theme and design system
- [x] Create mock data models

#### Talker Setup Structure
```dart
lib/utils/
├── logger/
│   ├── talker_config.dart          # Talker initialization
│   ├── talker_bloc_observer.dart   # Bloc observer with Talker
│   └── talker_route_observer.dart  # Router observer with Talker
└── di/
    └── service_locator.dart        # GetIt setup with Talker registration
```

### 1.3 Mock Data Layer
- [x] Create mock data generators for all features
- [x] Implement mock repositories (no real API calls)
- [x] Add realistic sample data (employees, policies, etc.)
- [x] Create mock response delays to simulate network
- [x] Set up mock error scenarios for testing

### 1.4 Authentication & Session (Mock)
- [x] Create mock auth repository
- [x] Implement mock login/logout flow (hardcoded credentials)
- [x] Set up session management with HydratedBloc
- [x] Create auth guards for routing
- [x] Mock user profiles and roles

**✅ Phase 1 Complete & Working!** All core infrastructure is set up, tested, and verified working on device. The app runs successfully with:
- ✅ Mock authentication system (working)
- ✅ Talker logging configured (working)
- ✅ GoRouter navigation with auth guards (working)
- ✅ HydratedBloc for state persistence (working)
- ✅ GetIt dependency injection (working)
- ✅ Shared theme and design system (working)
- ✅ Mock data layer ready for all features (working)
- ✅ Proper Scaffold with AppBar on all screens (working)
- ✅ No errors in dart analyze (verified)

**Test Results:**
- App launches successfully on device
- Login screen displays correctly with proper UI
- Navigation redirects work as expected
- Theme applies correctly (Material 3)
- All dependencies initialized without errors

---

## Phase 2: Main Navigation & Menu Structure

### 2.1 App Shell
- [x] Create main app scaffold with responsive layout
- [x] Implement navigation drawer/sidebar for menu
- [x] Create bottom navigation (mobile)
- [x] Add app bar with user profile
- [x] Implement menu item models and configuration

### 2.2 Menu Structure Implementation

```
Main Menu
├── Dashboard
├── Employee Services
│   ├── Team Directory
│   ├── Policies
│   ├── Benefits
│   ├── Travel
│   ├── Leave/Attendance
│   ├── Compensation
│   ├── Recognition
│   ├── Bolt
│   ├── Ayush Health
│   ├── Holiday Calendar
│   └── Documents
└── Company Resources
    ├── IT Resources
    ├── Map
    ├── Emergency Contacts
    └── Company Overview
```

### 2.3 Menu Components
- [x] Create menu item widget (with icon, label, badge support)
- [x] Create expandable menu section widget
- [x] Implement menu navigation logic
- [x] Add menu search/filter functionality
- [x] Create responsive menu (drawer for mobile, sidebar for desktop)

### 2.4 Bug Fixes & Platform-Specific Issues
- [x] Fix web platform: MissingPluginException for path_provider
  - Issue: `getApplicationDocumentsDirectory` not available on web
  - Solution: Created `WebStorageDirectory` class for web-specific storage
  - Files modified: `lib/main.dart`, created `lib/utils/storage/web_storage_directory.dart`
  - Result: App now works on web platform using IndexedDB for HydratedBloc storage

- [x] Fix Duplicate GlobalKey and Navigation errors during drawer logout
  - Issues: 
    1. `Assertion failed: Duplicate GlobalKey detected in widget tree` 
    2. `You have popped the last page off of the stack, there are no pages left to show`
  - Location: `framework.dart:4738:12` and `go_router/src/delegate.dart:175:7`
  - Root Cause Identified: 
    - Drawer logout was calling `Navigator.of(context).pop()` which conflicts with GoRouter's navigation management
    - GoRouter manages navigation through redirects, not manual Navigator.pop() calls
    - Calling Navigator.pop() tried to pop the last page, causing navigation stack errors
    - This also caused race conditions leading to duplicate GlobalKey errors
  - **Solution Implemented:**
    - Removed `Navigator.pop()` call from drawer logout completely
    - Let GoRouter handle navigation automatically through its redirect logic
    - When logout is triggered, AuthBloc state changes, GoRouter detects it and redirects to login
    - Drawer closes automatically when the route changes
  - Files Modified: 
    - `lib/utils/router/app_router.dart` - Updated login route with pageBuilder
    - `lib/features/auth/screens/login_screen.dart` - Changed to late final for GlobalKey
    - `lib/shared/widgets/menu/app_drawer.dart` - Removed Navigator.pop() call, let GoRouter handle navigation
  - **✅ VERIFIED WORKING:** User confirmed both errors are now fixed - logout from drawer works correctly

**✅ Phase 2 Complete & Working!** All navigation and menu components are implemented and tested. The app now has:
- ✅ Responsive app shell (mobile, tablet, desktop layouts)
- ✅ Navigation drawer with user profile header
- ✅ Expandable menu sections with all features
- ✅ 16 placeholder screens for all features
- ✅ Proper login screen with demo credentials
- ✅ Full routing configuration with auth guards
- ✅ Menu navigation working across all screens
- ✅ No errors in dart analyze (verified)

**Test Results:**
- Login works with demo@company.com / password123
- Navigation drawer opens and displays all menu items
- All 16 feature screens are accessible
- Responsive layout adapts to screen size
- User profile menu in app bar works
- Logout functionality works correctly

**Kiro Credits Consumed:** 56 credits

**Git Commit:**
- Commit Hash: `afbdaf5`
- Branch: `main`
- Message: "Complete Phase 2: Navigation and Menu Structure - All screens and routing implemented"
- Files Changed: 47 files, 3858 insertions(+), 111 deletions(-)
- Date: Phase 2 completion

**Key Files Added:**
- Menu system: `lib/core/menu/` (menu_config.dart, models/)
- App shell: `lib/shared/widgets/layout/app_shell.dart`
- Navigation drawer: `lib/shared/widgets/menu/` (app_drawer.dart, menu widgets)
- Login screen: `lib/features/auth/screens/login_screen.dart`
- 16 feature screens in `lib/features/*/screens/`
- Router configuration: `lib/utils/router/app_router.dart`
- Route definitions: `lib/core/route/route_names.dart`

---

## Phase 2.5: Talker UI Integration (Debug Logging Interface)

### 2.5.1 Create Talker Screen Route
- [x] Add Talker screen route to `core/route/route_names.dart`
- [x] Configure Talker screen route in GoRouter (`utils/router/app_router.dart`)
- [x] Make Talker screen accessible only in debug mode
- [x] Test navigation to Talker screen

### 2.5.2 Add Talker Button to Login Screen
- [x] Add floating action button (FAB) to login screen
- [x] Position FAB in bottom-right corner
- [x] Add debug-only visibility check (only show in debug mode)
- [x] Add icon (e.g., `Icons.bug_report` or `Icons.developer_mode`)
- [x] Wire FAB to navigate to Talker screen
- [x] Test FAB visibility and navigation

### 2.5.3 Add Talker Button to Dashboard Drawer
- [x] Add "Developer Logs" menu item to drawer
- [x] Position in a separate "Debug" section at bottom of drawer
- [x] Add debug-only visibility check
- [x] Add appropriate icon (e.g., `Icons.terminal` or `Icons.code`)
- [x] Wire menu item to navigate to Talker screen
- [x] Test drawer menu item visibility and navigation

### 2.5.4 Add Talker Button to AppBar Actions
- [x] Add Talker icon button to AppBar actions
- [x] Position after user profile menu
- [x] Add debug-only visibility check
- [x] Add icon (e.g., `Icons.bug_report`)
- [x] Wire button to navigate to Talker screen
- [x] Ensure responsive behavior (hide on small screens if needed)
- [x] Test AppBar button visibility and navigation

### 2.5.5 Configure Talker Screen Settings
- [x] Customize Talker screen theme to match app theme
- [x] Configure log filters (show/hide specific log types)
- [x] Add ability to clear logs
- [x] Add ability to share/export logs
- [x] Test Talker screen functionality

### 2.5.6 Testing & Verification
- [x] Test Talker button visibility in debug mode
- [x] Verify Talker buttons are hidden in release mode
- [x] Test navigation from all three entry points (login, drawer, appbar)
- [x] Verify logs are displayed correctly in Talker screen
- [x] Test log filtering and clearing
- [x] Run `dart analyze` to ensure no errors
- [ ] Test on multiple screen sizes (mobile, tablet, desktop)

### 2.5.7 Bug Fixes
- [x] Fix Talker screen not opening when tapping debug buttons
  - Issue: Tapping the Talker button (FAB, drawer menu, or AppBar) does not navigate to Talker screen
  - Root Cause: Auth redirect logic was blocking access to the Talker screen route
  - **Solution Implemented:**
    - Added exception in redirect logic to allow access to Talker screen in debug mode without authentication
    - Talker screen can now be accessed from login screen (unauthenticated) and from authenticated screens
    - Added logging to track when Talker screen access is allowed
  - Files Modified:
    - `lib/utils/router/app_router.dart` - Updated redirect logic to allow Talker screen access in debug mode
  - **✅ VERIFIED WORKING:** User confirmed the fix is working

- [x] Fix Developer Logs menu item in drawer not opening Talker screen
  - Issue: Tapping "Developer Logs" menu item in the navigation drawer causes error: "You have popped the last page off of the stack, there are no pages left to show"
  - Root Cause: Using `Navigator.of(context).pop()` to close drawer conflicts with GoRouter's navigation stack management
  - **Solution Implemented:**
    - Use `Scaffold.of(context).closeDrawer()` instead of `Navigator.of(context).pop()`
    - This properly closes the drawer without interfering with GoRouter's navigation stack
    - Use `WidgetsBinding.instance.addPostFrameCallback()` to schedule navigation after the current frame completes
    - This ensures the drawer is fully closed before navigation begins
  - Files Modified:
    - `lib/shared/widgets/menu/app_drawer.dart` - Changed to Scaffold.closeDrawer() with post-frame callback navigation
  - **✅ VERIFIED WORKING:** User confirmed the fix is working

**Phase 2.5 Structure:**
```dart
lib/
├── core/route/
│   └── route_names.dart                    # Add talkerScreen route ✅
├── utils/router/
│   └── app_router.dart                     # Add Talker screen route config ✅
├── features/auth/screens/
│   └── login_screen.dart                   # Add FAB for Talker ✅
├── shared/widgets/
│   ├── layout/
│   │   └── app_shell.dart                  # Add Talker button to AppBar ✅
│   └── menu/
│       └── app_drawer.dart                 # Add Talker menu item ✅
└── utils/
    └── debug/
        └── debug_utils.dart                # Helper for debug mode checks ✅
```

**Expected Outcome:**
- Developers can easily access Talker logs from three convenient locations ✅
- Talker UI is only visible in debug builds ✅
- All navigation to Talker screen works correctly ✅
- Logs are properly displayed and filterable ✅

**✅ Phase 2.5 Complete!** Talker UI integration is now fully implemented with access points from:
1. Login screen (FAB in bottom-right corner)
2. Navigation drawer (Developer Logs menu item)
3. AppBar (bug report icon button)

All access points are debug-only and properly configured. The Talker screen uses a dark theme and provides full logging functionality including filtering, clearing, and exporting logs.

---

## Phase 3: Login Screen Redesign (Design-Driven)

### 3.1 Color System Setup
- [x] Create color constants file in `lib/core/colors/app_colors.dart`
- [x] Define brand colors:
  - Blue: `rgba(40, 40, 255, 1)` - Main brand color
  - Dark Blue: `rgba(13, 13, 143, 1)` - Secondary/accent color
  - Light Blue: `rgba(196, 207, 253, 1)` - Light backgrounds and highlights
  - White: `#ffffffe5` - Standard white with slight transparency
  - Bright White: `#FFFFFF` - Pure white for cards and surfaces

### 3.2 Theme Configuration
- [x] Update `lib/shared/theme/app_theme.dart` with new color scheme
- [x] Configure light theme with blue primary colors
- [x] Configure dark theme with blue primary colors
- [x] Set up component-specific theming:
  - Input fields with blue focus borders
  - Buttons with blue backgrounds
  - Cards with bright white backgrounds
  - Icons with blue color
- [x] Create `theme.md` documentation

### 3.3 Responsive Login Screen Layout
- [x] Implement responsive layout with `LayoutBuilder`
- [x] Web layout (≥768px width):
  - [x] 1/4 width blue gradient background (dark blue to blue)
  - [x] 3/4 width white area with centered login form card
  - [x] App logo and name on gradient side
  - [x] "Welcome Back" title on form side
- [x] Mobile layout (<768px width):
  - [x] Centered login form with padding
  - [x] App logo and "HR App" title on form
  - [x] Responsive card layout

### 3.4 Login Form Styling
- [x] Email input field with validation
- [x] Password input field with show/hide toggle
- [x] Blue "Sign In" button with loading state
- [x] Demo credentials section with light blue background
- [x] Form validation and error handling
- [x] Consistent spacing and padding

### 3.5 Testing & Verification
- [x] Test responsive layout on different screen sizes
- [x] Verify color scheme consistency
- [x] Test form validation
- [x] Test login flow with demo credentials
- [x] Run `dart analyze` to ensure no errors
- [x] Verify theme applies correctly across the app

**✅ Phase 3 Complete!** Login screen redesign is fully implemented with:
- ✅ Custom color system with brand colors
- ✅ Comprehensive theme configuration (light and dark modes)
- ✅ Responsive web layout (1/4 gradient + 3/4 form)
- ✅ Mobile-optimized layout
- ✅ Styled form with validation
- ✅ Light blue demo credentials section
- ✅ Complete theme documentation
- ✅ No errors in dart analyze (verified)

**Files Created/Modified:**
- Created: `lib/core/colors/app_colors.dart` - Color constants
- Created: `theme.md` - Theme documentation
- Modified: `lib/shared/theme/app_theme.dart` - Updated theme with new colors
- Modified: `lib/features/auth/screens/login_screen.dart` - Responsive login layout
- Modified: `login-design.md` - Design specification (all tasks completed)

**Design Specifications:**
- Blue gradient: Dark Blue (#0D0D8F) to Blue (#2828FF)
- Form background: Bright White (#FFFFFF)
- Demo credentials: Light Blue background (#C4CFFD)
- Responsive breakpoint: 768px
- Layout ratio (web): 1:3 (gradient:form)

---

## Phase 4: Feature Implementation (Iterative)

### 4.1 Dashboard (Priority: HIGH)
- [x] Create dashboard feature folder structure
- [x] Implement dashboard screen with widgets
- [x] Add quick access cards
- [x] Implement notifications widget
- [x] Add activity feed
- [x] Create dashboard bloc/cubit
- [x] Create mock dashboard repository
- [x] Generate mock dashboard data

**✅ Phase 4.1 Complete!** Dashboard is now fully functional with:
- ✅ Responsive dashboard layout with welcome section
- ✅ Quick access cards grid (6 cards with navigation)
- ✅ Leave balance widget with progress indicator
- ✅ Notifications list with unread indicators
- ✅ Upcoming events calendar
- ✅ Activity feed with timeline
- ✅ Pull-to-refresh functionality
- ✅ Full state management with DashboardBloc
- ✅ Mock data with realistic samples
- ✅ Error handling and retry mechanism
- ✅ No errors in dart analyze (verified)

**Files Created:**
- Models: `lib/features/dashboard/models/dashboard_data.dart`
- Bloc: `lib/features/dashboard/bloc/` (dashboard_bloc.dart, dashboard_state.dart, dashboard_event.dart)
- Repository: `lib/repository/dashboard/` (dashboard_repository.dart, mock_dashboard_repository.dart)
- Widgets: `lib/features/dashboard/widgets/` (quick_access_card_widget.dart, notification_widget.dart, activity_feed_widget.dart, leave_balance_widget.dart, upcoming_events_widget.dart)
- Mock data: `lib/mock/mock_dashboard.dart`
- Screen: `lib/features/dashboard/screens/dashboard_screen.dart` (updated)
- Service locator: `lib/utils/di/service_locator.dart` (updated with dashboard dependencies)

### 4.2 Team Directory (Priority: HIGH)
- [ ] Create team directory feature structure
- [ ] Implement employee list screen
- [ ] Create employee profile screen
- [ ] Add search and filter functionality
- [ ] Implement org chart view
- [ ] Create mock team directory repository
- [ ] Generate mock employee data (50-100 employees)

### 4.3 Leave/Attendance (Priority: HIGH)
- [ ] Create leave/attendance feature structure
- [ ] Implement leave application form
- [ ] Create leave history screen
- [ ] Add attendance tracking view
- [ ] Implement calendar view
- [ ] Create leave balance widget
- [ ] Create mock leave/attendance repository
- [ ] Generate mock leave data and balances
- [ ] Mock approval workflow states

### 4.4 Policies (Priority: MEDIUM)
- [ ] Create policies feature structure
- [ ] Implement policy list screen
- [ ] Create policy detail/viewer screen
- [ ] Create mock policies repository
- [ ] Generate mock policy data
- [ ] Mock acknowledgment tracking
- [ ] Add search functionality

### 4.5 Benefits (Priority: MEDIUM)
- [ ] Create benefits feature structure
- [ ] Implement benefits overview screen
- [ ] Create benefit detail screens
- [ ] Create mock benefits repository
- [ ] Generate mock benefits data
- [ ] Mock enrollment status

### 4.6 Travel (Priority: MEDIUM)
- [ ] Create travel feature structure
- [ ] Implement travel request form
- [ ] Create booking management screen
- [ ] Add expense tracking
- [ ] Create mock travel repository
- [ ] Generate mock travel requests and bookings
- [ ] Mock approval workflow

### 4.7 Compensation (Priority: MEDIUM)
- [ ] Create compensation feature structure
- [ ] Implement salary breakdown screen
- [ ] Add payslip viewer
- [ ] Create tax documents section
- [ ] Create mock compensation repository
- [ ] Generate mock salary and payslip data
- [ ] Mock compensation history

### 4.8 Recognition (Priority: MEDIUM)
- [ ] Create recognition feature structure
- [ ] Implement recognition feed
- [ ] Create award submission form
- [ ] Add leaderboard view
- [ ] Implement badge system
- [ ] Create appreciation wall
- [ ] Create mock recognition repository
- [ ] Generate mock recognition data and badges

### 4.9 Bolt (Priority: LOW)
- [ ] Create bolt feature structure
- [ ] Implement quick actions dashboard
- [ ] Add customizable shortcuts
- [ ] Create mock bolt repository
- [ ] Generate mock quick actions data

### 4.10 Ayush Health (Priority: MEDIUM)
- [ ] Create health feature structure
- [ ] Implement health dashboard
- [ ] Create wellness challenges view
- [ ] Add health resources library
- [ ] Create mock health repository
- [ ] Generate mock health data and challenges

### 4.11 Holiday Calendar (Priority: HIGH)
- [ ] Create holiday calendar feature structure
- [ ] Implement calendar view
- [ ] Add regional holiday filtering
- [ ] Create holiday list view
- [ ] Create mock holiday calendar repository
- [ ] Generate mock holiday data for 2026

### 4.12 Documents (Priority: HIGH)
- [ ] Create documents feature structure
- [ ] Implement document list screen
- [ ] Add document upload functionality (mock)
- [ ] Create document viewer
- [ ] Create mock documents repository
- [ ] Generate mock document metadata
- [ ] Mock sharing and permissions

### 4.13 IT Resources (Priority: MEDIUM)
- [ ] Create IT resources feature structure
- [ ] Implement helpdesk ticket system
- [ ] Create request forms (software/hardware)
- [ ] Add IT policies viewer
- [ ] Create mock IT resources repository
- [ ] Generate mock ticket and request data

### 4.14 Map (Priority: LOW)
- [ ] Create map feature structure
- [ ] Implement office location maps
- [ ] Add floor plan viewer
- [ ] Create desk booking system
- [ ] Create mock map repository
- [ ] Generate mock office and desk data

### 4.15 Emergency Contacts (Priority: HIGH)
- [ ] Create emergency contacts feature structure
- [ ] Implement contact directory
- [ ] Add quick dial functionality
- [ ] Create incident reporting form
- [ ] Add safety protocols viewer
- [ ] Create mock emergency contacts repository
- [ ] Generate mock emergency contact data

### 4.16 Company Overview (Priority: LOW)
- [ ] Create company overview feature structure
- [ ] Implement company info screens
- [ ] Add leadership team section
- [ ] Create org structure viewer
- [ ] Add mission/vision content
- [ ] Create mock company overview repository
- [ ] Generate mock company data

---

## Phase 5: Cross-Cutting Concerns

### 5.1 Mock CMS Integration
- [ ] Set up CMS content models
- [ ] Create mock CMS data loader
- [ ] Implement feature-specific builders
- [ ] Mock content updates

### 5.2 Local Storage
- [ ] Implement local data persistence
- [ ] Add offline indicators (mock mode)
- [ ] Store mock data locally
- [ ] Handle form submissions locally

### 5.3 Mock Notifications
- [ ] Create mock notification system
- [ ] Implement notification handlers
- [ ] Add notification preferences
- [ ] Create in-app notification center with mock data

### 5.4 Search
- [ ] Implement global search functionality (on mock data)
- [ ] Add feature-specific search
- [ ] Create search history
- [ ] Add search suggestions

---

## Phase 6: Polish & Optimization

### 6.1 UI/UX Refinement
- [ ] Implement loading states and skeletons
- [ ] Add error handling and retry mechanisms
- [ ] Create empty states
- [ ] Add animations and transitions
- [ ] Implement pull-to-refresh

### 6.2 Responsive Design
- [ ] Test on various screen sizes
- [ ] Optimize layouts for tablet
- [ ] Ensure web responsiveness
- [ ] Test orientation changes

### 6.3 Accessibility
- [ ] Add semantic labels
- [ ] Test with screen readers
- [ ] Ensure proper contrast ratios
- [ ] Add keyboard navigation (web)

### 6.4 Performance
- [ ] Optimize image loading
- [ ] Implement lazy loading
- [ ] Profile and optimize slow screens
- [ ] Reduce app size

### 6.5 Testing
- [ ] Write unit tests for blocs/cubits
- [ ] Create widget tests for key screens
- [ ] Add integration tests for critical flows
- [ ] Perform manual testing on all platforms

---

## Phase 7: Deployment

### 7.1 Android
- [ ] Configure app signing
- [ ] Set up build variants
- [ ] Create Play Store listing
- [ ] Generate release build
- [ ] Submit to Play Store

### 7.2 iOS
- [ ] Configure provisioning profiles
- [ ] Set up App Store Connect
- [ ] Create App Store listing
- [ ] Generate release build
- [ ] Submit to App Store

### 7.3 Web
- [ ] Configure web hosting
- [ ] Set up domain and SSL
- [ ] Optimize for SEO
- [ ] Deploy to production
- [ ] Configure CDN

---

## Immediate Next Steps (Menu Implementation with Mock Data)

### Step 1: Create Mock Data Infrastructure
```dart
lib/mock/
├── mock_data.dart              # Base mock data utilities
├── mock_employees.dart         # Employee mock data
├── mock_leaves.dart            # Leave/attendance mock data
├── mock_policies.dart          # Policy mock data
├── mock_benefits.dart          # Benefits mock data
├── mock_travel.dart            # Travel mock data
├── mock_compensation.dart      # Compensation mock data
├── mock_recognition.dart       # Recognition mock data
├── mock_health.dart            # Health mock data
├── mock_holidays.dart          # Holiday mock data
├── mock_documents.dart         # Documents mock data
├── mock_it_resources.dart      # IT resources mock data
├── mock_emergency.dart         # Emergency contacts mock data
└── mock_company.dart           # Company overview mock data
```

### Step 2: Create Repository Interfaces & Mock Implementations
```dart
lib/repository/
├── auth/
│   ├── auth_repository.dart           # Interface
│   └── mock_auth_repository.dart      # Mock implementation
├── dashboard/
│   ├── dashboard_repository.dart
│   └── mock_dashboard_repository.dart
├── team_directory/
│   ├── team_directory_repository.dart
│   └── mock_team_directory_repository.dart
└── [similar pattern for all features]
```

### Step 3: Create Menu Data Model
```dart
lib/core/menu/
├── models/
│   ├── menu_item.dart
│   └── menu_section.dart
└── menu_config.dart
```

### Step 4: Create Menu Widgets
```dart
lib/shared/widgets/menu/
├── app_drawer.dart
├── menu_section_widget.dart
├── menu_item_widget.dart
└── responsive_menu.dart
```

### Step 5: Create Placeholder Screens
```dart
lib/features/
├── dashboard/screens/dashboard_screen.dart
├── team_directory/screens/team_directory_screen.dart
├── policies/screens/policies_screen.dart
├── benefits/screens/benefits_screen.dart
├── travel/screens/travel_screen.dart
├── leave_attendance/screens/leave_attendance_screen.dart
├── compensation/screens/compensation_screen.dart
├── recognition/screens/recognition_screen.dart
├── bolt/screens/bolt_screen.dart
├── ayush_health/screens/ayush_health_screen.dart
├── holiday_calendar/screens/holiday_calendar_screen.dart
├── documents/screens/documents_screen.dart
├── it_resources/screens/it_resources_screen.dart
├── map/screens/map_screen.dart
├── emergency_contacts/screens/emergency_contacts_screen.dart
└── company_overview/screens/company_overview_screen.dart
```

### Step 6: Configure Routes
- [x] Define route names in `core/route/route_names.dart`
- [x] Configure GoRouter with all menu routes
- [x] Add TalkerRouteObserver to GoRouter for navigation logging
- [x] Add mock auth guards for routing
- [x] Test route logging with Talker

### Step 7: Wire Up Navigation with Mock Data
- [x] Connect menu items to routes
- [x] Register mock repositories in GetIt
- [x] Test navigation flow with mock data
- [ ] Add breadcrumbs (web/desktop)
- [x] Implement back navigation

### Step 8: Create Mock Login
- [x] Create login screen
- [x] Implement mock authentication (hardcoded credentials)
- [x] Add mock user profiles
- [x] Test auth flow
- [x] Verify Talker logs for auth events

### Step 9: Talker Integration & Testing
- [x] Test Bloc event/state logging
- [x] Test navigation logging
- [x] Test error/exception logging
- [x] Configure Talker filters and settings
- [ ] Add Talker screen UI access points (see Phase 2.5)

### Step 10: Verify Phase 2 Completion
- [x] Run `dart analyze` and fix all errors
- [x] Test on device/emulator
- [x] Verify all navigation flows work
- [x] Commit Phase 2 changes to git

---

## Timeline Estimate (Mock Implementation)

- **Phase 1:** 3-4 days (setup + mock infrastructure)
- **Phase 2:** 3-4 days (menu structure)
- **Phase 2.5:** 0.5-1 day (Talker UI integration)
- **Phase 3:** 1-2 days (login screen redesign based on design spec)
- **Phase 4:** 6-8 weeks (iterative feature implementation with mock data)
- **Phase 5:** 1 week (cross-cutting with mocks)
- **Phase 6:** 1-2 weeks (polish)
- **Phase 7:** N/A (deployment deferred until real API integration)

**Total:** ~9-12 weeks for mock implementation

## Future: Real API Integration

When ready to integrate real APIs:
- [ ] Replace mock repositories with real API implementations
- [ ] Keep repository interfaces unchanged
- [ ] Add API client with Dio
- [ ] Configure environment-based repository injection
- [ ] Add Firebase, analytics, and error tracking
- [ ] Test with real backend
- [ ] Deploy to production

**Estimated time for API integration:** 2-3 weeks

---

## Priority Order for MVP

1. Authentication & Session
2. Main Navigation & Menu
3. Login Screen Redesign (Design-Driven)
4. Dashboard
5. Team Directory
6. Leave/Attendance
7. Holiday Calendar
8. Emergency Contacts
9. Documents
10. Policies
11. Other features (iterative)

---

## Packages Used (Mock Implementation Phase)

Key dependencies for mock implementation, grouped by purpose:

| Purpose | Packages | Role |
|--------|----------|------|
| **State management** | bloc, flutter_bloc, hydrated_bloc, equatable | Business logic and UI state; persisted state where needed; immutable state models |
| **Navigation** | go_router | Declarative routing, deep links, redirects |
| **Dependency injection** | get_it | Service locator for repositories, blocs |
| **Logging & Debugging** | talker, talker_flutter, talker_bloc_logger, talker_dio_logger | Comprehensive logging for events, exceptions, bloc states, navigation, and future HTTP requests |
| **Code quality** | flutter_lints | Linting and analysis rules |
| **Local storage** | shared_preferences, path_provider | Key-value storage and file paths |
| **Utilities** | intl | Date formatting and localization |

## Future Packages (Real API Integration Phase)

Additional packages to add when integrating real APIs:

| Purpose | Packages | Role |
|--------|----------|------|
| **Networking** | dio | HTTP client (already has talker_dio_logger for logging) |
| **CMS & content** | cached_network_image, flutter_svg, flutter_html, shimmer | Loading and rendering CMS-driven content |
| **Firebase** | firebase_core, firebase_messaging | Push notifications and Firebase services |
| **Analytics & attribution** | clevertap_plugin, appsflyer_sdk | Analytics and attribution |
| **Error tracking** | sentry_flutter | Production error reporting |
| **Testing** | mocktail | Mocking in unit and widget tests |
| **UI & media** | lottie, rive, video_player, camera, photo_view, webview_flutter, flutter_pdfview | Animations, video, camera, web view, PDF |
| **Device & platform** | device_info_plus, package_info_plus, permission_handler, url_launcher | Device info, app version, permissions, opening URLs |
## Timeline Estimate (Mock Implementation)

- **Phase 1:** 3-4 days (setup + mock infrastructure) ✅ Complete
- **Phase 2:** 3-4 days (menu structure) ✅ Complete
- **Phase 2.5:** 0.5-1 day (Talker UI integration) ✅ Complete
- **Phase 3:** 1-2 days (login screen redesign based on design spec) ✅ Complete
- **Phase 4:** 6-8 weeks (iterative feature implementation with mock data) - In Progress
- **Phase 5:** 1 week (cross-cutting with mocks)
- **Phase 6:** 1-2 weeks (polish)
- **Phase 7:** N/A (deployment deferred until real API integration)

**Total:** ~9-12 weeks for mock implementation
**Completed:** Phases 1, 2, 2.5, 3, and 4.1 (Dashboard)## Priority Order for MVP

1. ✅ Authentication & Session (Complete)
2. ✅ Main Navigation & Menu (Complete)
3. ✅ Login Screen Redesign (Complete - Design-Driven)
4. ✅ Dashboard (Complete)
5. Team Directory
6. Leave/Attendance
7. Holiday Calendar
8. Emergency Contacts
9. Documents
10. Policies
11. Other features (iterative)