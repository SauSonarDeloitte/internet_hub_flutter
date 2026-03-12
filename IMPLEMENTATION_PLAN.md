# HR App Implementation Plan

> **Note for AI:** Mark tasks as done (change `- [ ]` to `- [x]`) immediately after completing them. Do not wait until the end of a phase to update checkboxes.

> **IMPORTANT for AI:** After completing each step or making any code changes, ALWAYS run `dart analyze` or use `getDiagnostics` tool to check for errors before proceeding to the next step. Fix all errors immediately before moving forward.

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

**Kiro Credits Consumed:** 24.64 credits

---

## Phase 3: Feature Implementation (Iterative)

### 3.1 Dashboard (Priority: HIGH)
- [ ] Create dashboard feature folder structure
- [ ] Implement dashboard screen with widgets
- [ ] Add quick access cards
- [ ] Implement notifications widget
- [ ] Add activity feed
- [ ] Create dashboard bloc/cubit
- [ ] Create mock dashboard repository
- [ ] Generate mock dashboard data

### 3.2 Team Directory (Priority: HIGH)
- [ ] Create team directory feature structure
- [ ] Implement employee list screen
- [ ] Create employee profile screen
- [ ] Add search and filter functionality
- [ ] Implement org chart view
- [ ] Create mock team directory repository
- [ ] Generate mock employee data (50-100 employees)

### 3.3 Leave/Attendance (Priority: HIGH)
- [ ] Create leave/attendance feature structure
- [ ] Implement leave application form
- [ ] Create leave history screen
- [ ] Add attendance tracking view
- [ ] Implement calendar view
- [ ] Create leave balance widget
- [ ] Create mock leave/attendance repository
- [ ] Generate mock leave data and balances
- [ ] Mock approval workflow states

### 3.4 Policies (Priority: MEDIUM)
- [ ] Create policies feature structure
- [ ] Implement policy list screen
- [ ] Create policy detail/viewer screen
- [ ] Create mock policies repository
- [ ] Generate mock policy data
- [ ] Mock acknowledgment tracking
- [ ] Add search functionality

### 3.5 Benefits (Priority: MEDIUM)
- [ ] Create benefits feature structure
- [ ] Implement benefits overview screen
- [ ] Create benefit detail screens
- [ ] Create mock benefits repository
- [ ] Generate mock benefits data
- [ ] Mock enrollment status

### 3.6 Travel (Priority: MEDIUM)
- [ ] Create travel feature structure
- [ ] Implement travel request form
- [ ] Create booking management screen
- [ ] Add expense tracking
- [ ] Create mock travel repository
- [ ] Generate mock travel requests and bookings
- [ ] Mock approval workflow

### 3.7 Compensation (Priority: MEDIUM)
- [ ] Create compensation feature structure
- [ ] Implement salary breakdown screen
- [ ] Add payslip viewer
- [ ] Create tax documents section
- [ ] Create mock compensation repository
- [ ] Generate mock salary and payslip data
- [ ] Mock compensation history

### 3.8 Recognition (Priority: MEDIUM)
- [ ] Create recognition feature structure
- [ ] Implement recognition feed
- [ ] Create award submission form
- [ ] Add leaderboard view
- [ ] Implement badge system
- [ ] Create appreciation wall
- [ ] Create mock recognition repository
- [ ] Generate mock recognition data and badges

### 3.9 Bolt (Priority: LOW)
- [ ] Create bolt feature structure
- [ ] Implement quick actions dashboard
- [ ] Add customizable shortcuts
- [ ] Create mock bolt repository
- [ ] Generate mock quick actions data

### 3.10 Ayush Health (Priority: MEDIUM)
- [ ] Create health feature structure
- [ ] Implement health dashboard
- [ ] Create wellness challenges view
- [ ] Add health resources library
- [ ] Create mock health repository
- [ ] Generate mock health data and challenges

### 3.11 Holiday Calendar (Priority: HIGH)
- [ ] Create holiday calendar feature structure
- [ ] Implement calendar view
- [ ] Add regional holiday filtering
- [ ] Create holiday list view
- [ ] Create mock holiday calendar repository
- [ ] Generate mock holiday data for 2026

### 3.12 Documents (Priority: HIGH)
- [ ] Create documents feature structure
- [ ] Implement document list screen
- [ ] Add document upload functionality (mock)
- [ ] Create document viewer
- [ ] Create mock documents repository
- [ ] Generate mock document metadata
- [ ] Mock sharing and permissions

### 3.13 IT Resources (Priority: MEDIUM)
- [ ] Create IT resources feature structure
- [ ] Implement helpdesk ticket system
- [ ] Create request forms (software/hardware)
- [ ] Add IT policies viewer
- [ ] Create mock IT resources repository
- [ ] Generate mock ticket and request data

### 3.14 Map (Priority: LOW)
- [ ] Create map feature structure
- [ ] Implement office location maps
- [ ] Add floor plan viewer
- [ ] Create desk booking system
- [ ] Create mock map repository
- [ ] Generate mock office and desk data

### 3.15 Emergency Contacts (Priority: HIGH)
- [ ] Create emergency contacts feature structure
- [ ] Implement contact directory
- [ ] Add quick dial functionality
- [ ] Create incident reporting form
- [ ] Add safety protocols viewer
- [ ] Create mock emergency contacts repository
- [ ] Generate mock emergency contact data

### 3.16 Company Overview (Priority: LOW)
- [ ] Create company overview feature structure
- [ ] Implement company info screens
- [ ] Add leadership team section
- [ ] Create org structure viewer
- [ ] Add mission/vision content
- [ ] Create mock company overview repository
- [ ] Generate mock company data

---

## Phase 4: Cross-Cutting Concerns

### 4.1 Mock CMS Integration
- [ ] Set up CMS content models
- [ ] Create mock CMS data loader
- [ ] Implement feature-specific builders
- [ ] Mock content updates

### 4.2 Local Storage
- [ ] Implement local data persistence
- [ ] Add offline indicators (mock mode)
- [ ] Store mock data locally
- [ ] Handle form submissions locally

### 4.3 Mock Notifications
- [ ] Create mock notification system
- [ ] Implement notification handlers
- [ ] Add notification preferences
- [ ] Create in-app notification center with mock data

### 4.4 Search
- [ ] Implement global search functionality (on mock data)
- [ ] Add feature-specific search
- [ ] Create search history
- [ ] Add search suggestions

---

## Phase 5: Polish & Optimization

### 5.1 UI/UX Refinement
- [ ] Implement loading states and skeletons
- [ ] Add error handling and retry mechanisms
- [ ] Create empty states
- [ ] Add animations and transitions
- [ ] Implement pull-to-refresh

### 5.2 Responsive Design
- [ ] Test on various screen sizes
- [ ] Optimize layouts for tablet
- [ ] Ensure web responsiveness
- [ ] Test orientation changes

### 5.3 Accessibility
- [ ] Add semantic labels
- [ ] Test with screen readers
- [ ] Ensure proper contrast ratios
- [ ] Add keyboard navigation (web)

### 5.4 Performance
- [ ] Optimize image loading
- [ ] Implement lazy loading
- [ ] Profile and optimize slow screens
- [ ] Reduce app size

### 5.5 Testing
- [ ] Write unit tests for blocs/cubits
- [ ] Create widget tests for key screens
- [ ] Add integration tests for critical flows
- [ ] Perform manual testing on all platforms

---

## Phase 6: Deployment

### 6.1 Android
- [ ] Configure app signing
- [ ] Set up build variants
- [ ] Create Play Store listing
- [ ] Generate release build
- [ ] Submit to Play Store

### 6.2 iOS
- [ ] Configure provisioning profiles
- [ ] Set up App Store Connect
- [ ] Create App Store listing
- [ ] Generate release build
- [ ] Submit to App Store

### 6.3 Web
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
- [ ] Add Talker screen for viewing logs in debug mode
- [x] Test Bloc event/state logging
- [x] Test navigation logging
- [x] Test error/exception logging
- [x] Configure Talker filters and settings

---

## Timeline Estimate (Mock Implementation)

- **Phase 1:** 3-4 days (setup + mock infrastructure)
- **Phase 2:** 3-4 days (menu structure)
- **Phase 3:** 6-8 weeks (iterative feature implementation with mock data)
- **Phase 4:** 1 week (cross-cutting with mocks)
- **Phase 5:** 1-2 weeks (polish)
- **Phase 6:** N/A (deployment deferred until real API integration)

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
3. Dashboard
4. Team Directory
5. Leave/Attendance
6. Holiday Calendar
7. Emergency Contacts
8. Documents
9. Policies
10. Other features (iterative)

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
