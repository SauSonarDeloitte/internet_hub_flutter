# HR App

A comprehensive Flutter-based HR management application for Android, iOS, and Web platforms.

---

## Overview

The HR App provides employees with a centralized platform to access company resources, manage policies, track attendance, and utilize various employee services. Built with Flutter for cross-platform compatibility and responsive design.

---

## Features

### Dashboard
- Personalized employee dashboard
- Quick access to frequently used services
- Notifications and announcements
- Activity feed

### Employee Services

#### Team Directory
- Search and browse employee directory
- View employee profiles and contact information
- Organizational hierarchy view
- Department-wise filtering

#### Policies
- Access company policies and guidelines
- Policy documents and updates
- Version history and acknowledgments

#### Benefits
- Employee benefits overview
- Enrollment and management
- Benefits eligibility and coverage details

#### Travel
- Travel request submission
- Booking management
- Travel policy and guidelines
- Expense tracking

#### Leave/Attendance
- Leave application and approval workflow
- Attendance tracking and history
- Leave balance overview
- Calendar view of team availability

#### Compensation
- Salary structure and breakdown
- Payslip access and download
- Tax documents
- Compensation history

#### Recognition
- Peer recognition and awards
- Achievement tracking
- Leaderboards and badges
- Appreciation wall

#### Bolt
- Quick actions and shortcuts
- Frequently used services
- Custom workflows

#### Ayush Health
- Health and wellness programs
- Health tracking integration
- Wellness challenges
- Health resources and tips

#### Holiday Calendar
- Company holiday list
- Regional holiday variations
- Calendar sync
- Upcoming holidays view

#### Documents
- Personal document repository
- Document upload and management
- Secure document storage
- Document sharing and access control

### Company Resources

#### IT Resources
- IT support and helpdesk
- Software and hardware requests
- Access management
- IT policies and guidelines

#### Map
- Office locations and maps
- Floor plans
- Desk booking
- Navigation assistance

#### Emergency Contacts
- Emergency contact directory
- Safety protocols
- Incident reporting
- Quick dial access

#### Company Overview
- Company information and history
- Mission, vision, and values
- Leadership team
- Organizational structure

---

## Technical Stack

- **Framework:** Flutter (Android, iOS, Web)
- **State Management:** Bloc/Cubit with Hydrated Bloc
- **Navigation:** GoRouter
- **Networking:** Dio
- **Dependency Injection:** GetIt
- **Local Storage:** SharedPreferences
- **Analytics:** CleverTap, AppsFlyer
- **Push Notifications:** Firebase Messaging
- **Error Tracking:** Sentry

---

## Architecture

The app follows a feature-based architecture with clear separation of concerns:

- **Features:** Each menu item is implemented as a feature module
- **Repositories:** Data access layer with abstract interfaces
- **API:** Centralized network layer
- **Shared:** Reusable widgets and utilities
- **CMS:** Content management integration

For detailed architecture documentation, see [architecture.md](.kiro/steering/architecture.md).

---

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Chrome (for web development)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   
   # Web
   flutter run -d chrome
   ```

### Configuration

- Configure Firebase for push notifications
- Set up API endpoints in environment configuration
- Configure analytics keys (CleverTap, AppsFlyer)

---

## Project Structure

```
lib/
├── api/                    # Network layer
├── core/                   # App-wide routing and core functionality
├── cms/                    # CMS content models
├── features/               # Feature modules
│   ├── dashboard/
│   ├── team_directory/
│   ├── policies/
│   ├── benefits/
│   ├── travel/
│   ├── leave_attendance/
│   ├── compensation/
│   ├── recognition/
│   ├── bolt/
│   ├── ayush_health/
│   ├── holiday_calendar/
│   ├── documents/
│   ├── it_resources/
│   ├── map/
│   ├── emergency_contacts/
│   └── company_overview/
├── repository/             # Data access layer
├── shared/                 # Shared widgets and utilities
└── utils/                  # App configuration and helpers
```

---

## Development Guidelines

- Follow the architecture patterns defined in the project
- Write unit tests for business logic
- Ensure responsive design for all screen sizes
- Use platform-specific implementations where needed
- Follow Flutter and Dart best practices

---

## Platform Support

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (Modern browsers)

---

## License

[Add your license information here]

---

## Contact

[Add contact information or support details here]
