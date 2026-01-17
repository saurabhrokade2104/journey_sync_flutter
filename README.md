================================================================================
                            JOURNEYSYNC
================================================================================

JourneySync is a collaborative travel planning mobile app built with Flutter 
and Dart. Plan trips together seamlessly with real-time communication, live 
location sharing, and smart syncing features.

================================================================================
FEATURES
================================================================================

- Create & Manage Travel Plans
  Organize itineraries, destinations, and schedules

- Real-Time Chat
  Stay connected with your travel group instantly

- Live Location Sharing
  Know where everyone is during the trip

- Instant Notifications
  Get updates on plan changes and messages

- Collaborative Planning
  Work together to build the perfect trip

================================================================================
TECH STACK
================================================================================

Language: Dart
Framework: Flutter
Backend: Firebase
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage
  - Firebase Cloud Messaging (Notifications)

================================================================================
ABOUT JOURNEYSYNC
================================================================================

JourneySync simplifies group travel by centralizing all trip details in one 
place and keeping everyone connected in real time. Whether you're planning a 
weekend getaway or a month-long adventure, JourneySync ensures everyone stays 
on the same page.

================================================================================
GETTING STARTED
================================================================================

PREREQUISITES
-------------
- Flutter SDK (latest stable version)
- Dart (comes with Flutter)
- Firebase account
- Android Studio / Xcode (for mobile development)

INSTALLATION
------------

1. Clone the repository
   git clone https://github.com/your-username/journeysync.git
   cd journeysync

2. Install dependencies
   flutter pub get

3. Firebase Setup
   - Create a Firebase project at https://console.firebase.google.com/
   - Add Android/iOS apps to your Firebase project
   - Download google-services.json (Android) and GoogleService-Info.plist (iOS)
   - Place the files in their respective directories:
     * Android: android/app/google-services.json
     * iOS: ios/Runner/GoogleService-Info.plist
   - Enable Authentication, Firestore, Storage, and Cloud Messaging

4. Run the app
   flutter run

================================================================================
PROJECT STRUCTURE
================================================================================

journeysync/
├── lib/
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   ├── widgets/         # Reusable widgets
│   ├── services/        # Firebase & API services
│   └── main.dart        # App entry point
├── assets/              # Images, fonts, etc.
├── android/             # Android-specific files
├── ios/                 # iOS-specific files
└── pubspec.yaml         # Dependencies



5. Open a Pull Request

====
