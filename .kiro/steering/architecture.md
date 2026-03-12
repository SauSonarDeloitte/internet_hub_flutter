# Architecture — HR App
---


## Application Device & Screen Responsiveness  ← (NEW SECTION ADDED)
This application is intended to run on **all screen sizes** — including mobile, tablet, desktop, and web.  
Therefore:

- Always choose **responsive** or **adaptive** Flutter widgets.
- Prefer layout widgets such as:
  - `LayoutBuilder`
  - `MediaQuery`
  - `Flexible`, `Expanded`
  - `FractionallySizedBox`
  - `OrientationBuilder`
  - `AspectRatio`
- Avoid hardcoded sizes unless absolutely necessary.
- Use shared responsive helpers (if any) under `shared/` or create them if missing.

The goal is: **All widgets must adapt gracefully across different form factors.**

---

## Handling Packages Per Platform (Android / iOS vs. Web)  ← (NEW SECTION ADDED)
In cases where a package is:

- fully supported on **Android & iOS**,  
- but **NOT supported on Web**,  
- and there is a separate ideal package for Web,

follow this pattern:

### **1. Use conditional imports**
Example:
**```dart**
import 'mobile_impl.dart' if (dart.library.html) 'web_impl.dart';

## Rounting and Navigation ← (NEW SECTION ADDED)
Ensure routing behaves correctly on all platforms 

- mobile: deep links
- web: browser URL strategy (hash)
- maintain brower history consistency
- Handle refresh behavior gracefully 

## Folder Structure

The layout reflects architectural layers and responsibilities rather than a flat list of screens. Code lives under a single main library folder.

```
lib/
├── api/                        # Network layer: HTTP client, endpoints, headers, shared result type
├── core/
│   └── route/                   # App-wide routing: route names, paths, redirects
├── cms/
│   └── models/                  # Content layer: CMS section models (consumed by feature builders)
├── features/
│   └── <feature>/              # One folder per feature; each contains:
│       ├── view/ or screens/   # Screens and page-level UI
│       ├── widgets/            # Feature-specific reusable widgets
│       ├── bloc/ or controller/ # State and business logic for the feature
│       └── sub-feature/        # Optional nested feature areas
├── repository/                  # Data access layer: abstract interfaces + implementations (per domain)
├── shared/                     # Cross-cutting: shared widgets, theme, extensions, models
├── utils/                      # App wiring and cross-cutting: router config, constants, network helpers, analytics
└── <domain>/                   # Top-level domain/vertical modules (session, profile, verticals)
    └── ...                     # Each has its own screens, bloc, models as needed
```

- **api** — Single place for how the app talks to the backend (client, result type).
- **core** — App-wide concerns (e.g. routing) that are not feature-specific.
- **cms** — Central content models; features consume them via builders, they do not define the app’s feature set.
- **feature** — One folder per feature; inside each: view/screens, widgets, state (bloc/controller), and optional sub-features. Feature names are not part of the architecture; the *pattern* is.
- **repository** — Data access is abstracted behind interfaces with one implementation per domain; feature based names in the structure.
- **shared** — Reusable UI and utilities used by multiple features.
- **utils** — Bootstrap, routing, config, and cross-cutting helpers.
- **domain** — Top-level modules for app-wide or vertical concerns (e.g. user session, profile, or other domains). Each is a self-contained area with its own structure; the architecture is “one folder per domain,” not a fixed list of names.

Each feature folder follows the same pattern (view/screens, widgets, bloc/controller, optional sub-feature). 

Repositories follow an interface + implementation pattern per domain.

---

## Packages Used

Key dependencies used by the app, grouped by purpose:

| Purpose | Packages | Role |
|--------|----------|------|
| **State management** | bloc, flutter_bloc, hydrated_bloc, equatable | Business logic and UI state; persisted state where needed; immutable state models |
| **Navigation** | go_router | Declarative routing, deep links, redirects |
| **Networking** | dio, http | HTTP client and requests |
| **Dependency injection** | get_it | Service locator for API client, repositories, blocs |
| **Code quality** | flutter_lints | Linting and analysis rules |
| **CMS & content** | cached_network_image, flutter_svg, flutter_html, shimmer | Loading and rendering CMS-driven content |
| **Firebase** | firebase_core, firebase_messaging | Push notifications and Firebase services |
| **Analytics & attribution** | clevertap_plugin, appsflyer_sdk, user_experior | Analytics and attribution |
| **Local storage** | shared_preferences, shared_preference_app_group | Key-value storage; app-group storage on iOS where needed |
| **Testing** | mocktail | Mocking in unit and widget tests |
| **UI & media** | lottie, rive, video_player, camera, photo_view, webview_flutter, flutter_pdfview | Animations, video, camera, web view, PDF |
| **Device & platform** | device_info_plus, package_info_plus, permission_handler, path_provider, url_launcher | Device info, app version, permissions, files, opening URLs |
| **Other** | intl (formatting), sentry_flutter (error reporting), in_app_review, health/fitbitter (health data), and various feature-specific libraries | Localisation, monitoring, reviews, and domain features |

---

## Overview

The app is built with **Flutter** and uses:

- **State management:** Business logic and screen state are handled by dedicated components (Blocs and Cubits). Some state is persisted so it survives app restarts.
- **Navigation:** Screen flow and deep links are handled by a single routing setup.
- **Networking:** All server communication goes through a shared HTTP client with configurable timeouts and interceptors.
- **Dependency injection:** Shared services (e.g. API client, repositories, state handlers) are registered in one place and injected where needed, so components stay testable and loosely coupled.
- **Code quality:** The project uses standard Flutter lint rules so style and common issues stay consistent.

---

## How the Codebase Is Organized

The app is split into broad areas:

- **API / network:** Central HTTP client, base URLs, headers, and a common way to represent success and error from API calls.
- **Core:** App-wide routing definitions and redirect rules (e.g. after login, for web).
- **CMS:** Content-driven sections: a central component loads and caches CMS data; each feature has builders that turn that data into UI.
- **Features:** Each major capability (home, SME flows, policy, travel, etc.) lives in its own area with screens, reusable widgets, and state logic. Some features are broken into sub-features.
- **Repositories:** Data access is abstracted behind repository interfaces, with one concrete implementation per area (e.g. auth, home, policy). These talk to the API and return results in a consistent shape.
- **Shared:** Reusable UI components, theme, extensions, and shared models used across features.
- **Utilities:** Routing configuration, app constants, network helpers, and third-party integrations (e.g. analytics).
- **User and profile:** User session, auth-related models, and profile/policy screens.
- **Other domains:** Additional top-level areas for things like ABHA, activity tracking, auto, BMI, calculators, and similar verticals.

Routing is defined in one place: route names and paths live in a single source of truth, and the full navigation tree is configured there. CMS content is loaded once and then consumed by feature-specific builders so the UI can stay in sync with backend content.

---

## How Components Depend on Each Other

- **Screens and widgets** do not call APIs directly. They only trigger actions (e.g. “load policies”) and react to state (loading, success, error). All network and business logic lives in state handlers and repositories.
- **Repositories** are the only place that talks to the backend. They are injected where needed and return a standard success/error result type.
- **Domain and data are not strictly separated.** Response models and business concepts often live together; repositories frequently return API-shaped data that the UI or state layer uses directly.
- **Cross-feature reuse** happens through shared components, CMS models, or by resolving shared state handlers and repositories from the central registry.

---

## State and Business Logic

- **UI stays simple:** Screens and widgets only display data and send events (e.g. “user tapped submit”). They do not contain business rules or API calls.
- **State handlers** (Blocs/Cubits) own async work and logic. State is represented as immutable objects so changes are predictable and easy to test.
- **Naming:** Each feature typically has a state object, a state handler, and events (or methods) that drive behavior. Some features use a lighter “Cubit” style instead of full Bloc.
- **Persistence:** Where needed (e.g. user session), state is rehydrated on app start so the user stays logged in and key data is restored.

---

## Data and Networking

- **Single HTTP client:** All API calls go through one configured client. Base URL, headers, timeouts, retries, and logging are applied in one place (including interceptors).
- **Repositories** use this client to fetch and submit data. They return a consistent result type (success payload or error), so callers can handle outcomes uniformly.
- **Models:** CMS content is modeled in a dedicated area; feature-specific and API response models can live in the feature or in the repository area. There is no strict rule that “domain” and “DTO” must be in separate layers.
- **Timeouts and resilience:** Connection and read timeouts are set on the client; retry and logging behavior is defined in the shared interceptors.

---

## Adding a New Feature

1. **Define the route** — Add the new screen(s) to the central routing config (path and name).
2. **Implement the feature** — Create a feature area with screens, widgets, and a state handler (Bloc/Cubit). Use sub-features if the scope is large.
3. **Data access** — If the feature needs server data, add a repository interface and implementation, and register them in the app’s service registry.
4. **Wire state and navigation** — Register the new state handler in the app and ensure the router provides it (or it is available from a parent) where the screen is shown.
5. **CMS-driven content** — If the feature is driven by CMS, add the content models and a builder that consumes the central CMS data for this feature.

---

## Testing

- **Unit tests** cover state handlers and repositories in places where they exist; coverage is not uniform across the app.
- **Widget tests** and **integration tests** are used for important flows. Mocking is done via a common testing library.
- There is no single mandated standard for test layout or coverage targets; teams add tests as features are built or maintained.
