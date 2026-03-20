# NSymphony Eats Dashboard

A Flutter web dashboard that displays weekly lunch menus and daily attendance statistics. Designed for continuous display on company TV screens.

## Features

- **Weekly Menu Display**: Shows 5 days of lunch menus (Monday-Friday) in a 3+2 grid layout
  - Top row: 3 cards (Mon, Tue, Wed)
  - Bottom row: 2 cards (Thu, Fri) - centered
  - Highlights today's menu
  - Displays regular and vegetarian meal options

- **Attendance Panel**: Real-time display of today's attendance
  - Total attendees count
  - Meal preference breakdown (Regular, Vegetarian, Gluten-Free, Non-Pork)
  - Visual progress bars showing distribution

- **TV-Optimized Layout**:
  - No scrolling required - everything fits on screen
  - Compact fonts and spacing
  - Fixed-height cards for uniform appearance
  - 75/25 split between menu and attendance panels

## Architecture

Built using Clean Architecture principles:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Firebase Firestore integration
- **Presentation Layer**: BLoC state management with Flutter UI

## Prerequisites

- Flutter SDK (3.0 or higher)
- Firebase account
- Firebase CLI (for deployment)

## Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Firebase Configuration

**Note:** `firebase_options.dart` is not tracked in git for security reasons.

To configure Firebase:

1. Copy the example file:
   ```bash
   cp lib/firebase_options.dart.example lib/firebase_options.dart
   ```

2. Get your Firebase config from: [Firebase Console](https://console.firebase.google.com/project/YOUR_PROJECT/settings/general)

3. Update `lib/firebase_options.dart` with your actual Firebase project credentials

4. Ensure Firestore security rules allow read access to:
   - `menus` collection
   - `daily_logs` collection
   - `user_meal_preferences` collection

## Running Locally

### Development Mode

```bash
flutter run -d chrome
```

### Production Build (Local Testing)

```bash
# Build for web
flutter build web --release

# Serve locally
cd build/web
python3 -m http.server 8080

# Access at http://localhost:8080
```

## Deployment to Firebase Hosting

### Initial Setup (Already Completed)

The project is already configured for Firebase Hosting with:
- `firebase.json` - Hosting configuration
- `.firebaserc` - Project configuration

### Deploy to Production

1. **Build the web app**:
   ```bash
   flutter build web --release
   ```

2. **Deploy to Firebase Hosting**:
   ```bash
   firebase deploy --only hosting
   ```

3. **Access your dashboard**:
   - Primary URL: https://nsymphony-eats-prod.web.app
   - Alternative: https://nsymphony-eats-prod.firebaseapp.com

### Quick Deploy Script (Recommended)

Use the provided deployment script for easy one-command deployment:

```bash
./deploy.sh
```

This script will:
1. Build the Flutter web app for production
2. Deploy to Firebase Hosting
3. Show you the live URLs

### Manual Build & Deploy

Alternatively, you can run the commands manually:

```bash
flutter build web --release && firebase deploy --only hosting
```

## Firebase Hosting Details

- **Plan**: Free (Spark plan)
- **Storage**: 10 GB (app uses ~2 MB)
- **Bandwidth**: 10 GB/month
- **Cost**: $0 for typical company usage
- **SSL**: Included automatically
- **CDN**: Global content delivery

## TV Display Setup

1. Open the deployed URL on your TV browser
2. Press F11 (or equivalent) to enter full-screen mode
3. The dashboard will auto-refresh with real-time data from Firebase

## Firestore Data Structure

### Collections Used

**1. `menus/{weekId}`**
```json
{
  "weekId": "2026-W04",
  "days": [
    {
      "date": "2026-01-19",
      "weekday": "monday",
      "status": "working",
      "regular": [{"name": "Chicken Soup"}, {"name": "Grilled Salmon"}],
      "vege": [{"name": "Vegetable Curry"}]
    }
  ]
}
```

**2. `daily_logs/{date}`**
```json
{
  "entries": [
    {"cardNumber": "12345", "timestamp": "2026-01-21T08:30:00Z"}
  ]
}
```

**3. `user_meal_preferences/{cardNumber}`**
```json
{
  "mealType": "vegetarian"
}
```

## Project Structure

```
lib/
├── core/
│   ├── constants/         # Firebase constants
│   ├── di/               # Dependency injection
│   └── utils/            # Utilities (logging, week ID)
├── data/
│   ├── datasource/       # Firestore data sources
│   ├── model/            # DTOs
│   └── repository/       # Repository implementations
├── domain/
│   ├── model/            # Domain entities
│   ├── repository/       # Repository interfaces
│   └── usecase/          # Business logic use cases
└── presentation/
    ├── bloc/             # BLoC state management
    ├── page/             # Dashboard page
    ├── resources/        # Colors, dimensions, themes
    └── widget/           # Reusable widgets (MenuPanel, AttendancePanel)
```

## Troubleshooting

### Build Issues

```bash
# Clean build
flutter clean
flutter pub get
flutter build web --release
```

### Firebase Login Issues

```bash
# Re-authenticate
firebase logout
firebase login
```

### Deployment Issues

```bash
# Check current project
firebase projects:list

# Use specific project
firebase use nsymphony-eats-prod
```

## Development

### State Management

The app uses BLoC pattern with two main BLoCs:
- **MenuBloc**: Manages weekly menu state
- **AttendanceBloc**: Manages attendance counts state

### Real-time Updates

The menu panel subscribes to Firestore real-time updates, so any changes to the menu in Firebase will automatically reflect on the dashboard without refresh.

## License

Internal company project - NSymphony Eats

## Support

For issues or questions, contact the development team.
