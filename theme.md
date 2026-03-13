# Theme Documentation — HR App

## Color Palette

The app uses a blue-based color scheme with the following primary colors:

### Primary Colors
- **Blue**: `rgba(40, 40, 255, 1)` - Main brand color
- **Dark Blue**: `rgba(13, 13, 143, 1)` - Secondary/accent color
- **Light Blue**: `rgba(196, 207, 253, 1)` - Light backgrounds and highlights

### Background Colors
- **White**: `#ffffffe5` - Standard white with slight transparency
- **Bright White**: `#FFFFFF` - Pure white for cards and surfaces

## Color Constants

All colors are defined in `lib/core/colors/app_colors.dart`:

```dart
class AppColors {
  static const Color blue = Color.fromRGBO(40, 40, 255, 1);
  static const Color darkBlue = Color.fromRGBO(13, 13, 143, 1);
  static const Color lightBlue = Color.fromRGBO(196, 207, 253, 1);
  static const Color white = Color(0xFFFFFFE5);
  static const Color brightWhite = Color(0xFFFFFFFF);
}
```

## Theme Configuration

The app theme is configured in `lib/shared/theme/app_theme.dart` and provides both light and dark mode support.

### Light Theme

**Color Scheme:**
- Primary: Blue (`AppColors.blue`)
- Secondary: Dark Blue (`AppColors.darkBlue`)
- Background: Bright White (`AppColors.brightWhite`)
- Surface: Bright White (`AppColors.brightWhite`)

**Component Styling:**
- **Scaffold**: Bright white background
- **AppBar**: Bright white background, no elevation, black87 text
- **Cards**: Bright white background, 2px elevation, 12px border radius
- **Input Fields**: 
  - Bright white fill color
  - Grey border (enabled state)
  - Blue border (focused state, 2px width)
  - 8px border radius
- **Buttons**:
  - Filled/Elevated: Blue background, bright white text
  - Text: Blue text
  - 8px border radius
- **Icons**: Blue color
- **FAB**: Blue background, bright white icon

### Dark Theme

**Color Scheme:**
- Primary: Blue (`AppColors.blue`)
- Secondary: Dark Blue (`AppColors.darkBlue`)
- Background: Black
- Surface: Grey 900

**Component Styling:**
- **Scaffold**: Black background
- **AppBar**: Grey 900 background, no elevation, white text
- **Cards**: Grey 900 background, 2px elevation, 12px border radius
- **Input Fields**: 
  - Grey 800 fill color
  - Grey 700 border (enabled state)
  - Blue border (focused state, 2px width)
  - 8px border radius
- **Buttons**:
  - Filled/Elevated: Blue background, bright white text
  - Text: Blue text
  - 8px border radius
- **Icons**: Blue color
- **FAB**: Blue background, bright white icon

## Usage

### Applying Theme

The theme is applied in the main app widget:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // or ThemeMode.light / ThemeMode.dark
  // ...
);
```

### Using Colors in Widgets

Always use the color constants from `AppColors`:

```dart
import 'package:your_app/core/colors/app_colors.dart';

Container(
  color: AppColors.blue,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.brightWhite),
  ),
)
```

### Accessing Theme Colors

Access theme colors through the context:

```dart
final theme = Theme.of(context);
final primaryColor = theme.colorScheme.primary; // AppColors.blue
final backgroundColor = theme.scaffoldBackgroundColor; // AppColors.brightWhite
```

## Design Principles

1. **Consistency**: Use `AppColors` constants throughout the app
2. **Accessibility**: Ensure sufficient contrast between text and backgrounds
3. **Responsiveness**: Theme adapts to system dark mode preferences
4. **Material 3**: Uses Material 3 design system for modern UI components
5. **Simplicity**: Clean, minimal design with focus on usability

## Component Guidelines

### Buttons
- Use `FilledButton` for primary actions
- Use `ElevatedButton` for secondary actions
- Use `TextButton` for tertiary/low-emphasis actions

### Cards
- Use for grouping related content
- Consistent 12px border radius
- Subtle 2px elevation for depth

### Input Fields
- Always use `OutlineInputBorder`
- 8px border radius for consistency
- Blue focus indicator for clarity

### Icons
- Default to blue color
- Use bright white on blue backgrounds
- Maintain consistent sizing (24px default)

## Responsive Design

The theme works across all screen sizes:
- Mobile: Optimized for touch interactions
- Tablet: Balanced spacing and sizing
- Desktop/Web: Larger hit targets, appropriate spacing
- All platforms use the same color scheme for brand consistency
