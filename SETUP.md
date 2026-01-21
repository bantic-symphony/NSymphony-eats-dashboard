# NSymphony Eats Dashboard - Setup Guide

## Overview

This is a Flutter web dashboard that displays the weekly lunch menu and today's attendance/meal preferences for Symphony NS employees. It uses the same Firebase backend as the main NSymphony Eats mobile app.

## Architecture

The project follows Clean Architecture with:
- **Domain Layer**: Pure Dart business logic (models, repositories, use cases)
- **Data Layer**: Firebase integration (DTOs, data sources, repository implementations)
- **Presentation Layer**: Flutter UI with BLoC state management

## Firebase Setup

**IMPORTANT**: This dashboard uses the **same Firebase project** as the NSymphony Eats mobile app. You're not creating a new project - just configuring web access to the existing one.

### Step-by-Step Setup

1. Install FlutterFire CLI (if not already installed):
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Configure Firebase for web:
   ```bash
   flutterfire configure
   ```

3. When prompted:
   - **Select your existing Firebase project** (the same one used by the mobile app)
   - **Choose "web" as the platform**
   - Press Enter to accept the default bundle ID

4. This will generate `lib/firebase_options.dart` with web configuration for your existing project

**What this does:**
- Generates web-specific config (API keys, etc.)
- Connects to your existing Firebase backend
- Pulls data from the same Firestore collections as the mobile app
- Does NOT create a new project or duplicate any data

## Running the App

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run on web:
   ```bash
   flutter run -d chrome
   ```

3. Build for production:
   ```bash
   flutter build web
   ```

## Dashboard Layout

The dashboard uses a 3:1 layout ratio:
- **Left side (75%)**: Weekly menu display with daily menus from Monday to Friday
- **Right side (25%)**: Today's attendance and meal preference counts

## Features

### Menu Panel
- Displays current week's menu
- Highlights today's menu
- Shows regular and vegetarian meal options
- Automatically refreshes on menu updates (real-time streaming)

### Attendance Panel
- Total attendees today
- Meal preference breakdown:
  - Regular meals
  - Vegetarian meals
  - Gluten-free meals
  - Non-pork meals
- Visual progress bars showing percentage distribution
- Warning for users without meal preferences

## Firestore Collections Used

- `menus`: Weekly lunch menus
- `daily_logs`: Daily attendance (card numbers)
- `user_meal_preferences`: User meal preferences

## Development

To add new features or modify the dashboard:

1. **Domain Layer**: Add models, repositories, or use cases
2. **Data Layer**: Implement data sources and DTOs
3. **Presentation Layer**: Create BLoCs and UI components
4. **Dependency Injection**: Register new dependencies in `lib/core/di/service_locator.dart`

## Troubleshooting

If the dashboard shows no data:
- Verify Firebase is configured correctly
- Check that you have the correct Firestore permissions
- Ensure the `menus`, `daily_logs`, and `user_meal_preferences` collections exist
- Verify you're using the same Firebase project as the NSymphony Eats mobile app

## Notes

- This dashboard is read-only and does not modify any data
- It automatically refreshes when menu data changes in Firestore
- The layout is optimized for desktop/large screens
