# ForexCompanion 💱

A comprehensive financial companion app built with Flutter and Riverpod, featuring real-time forex rates, budget tracking, and an AI-powered assistant (Jarvis).

## Features ✨

- **Real-time Forex Rates**: Track currency exchange rates with automatic updates
- **Budget Management**: Create and track budgets with detailed analytics
- **AI Assistant (Jarvis)**: Chat-based financial assistant powered by Google Gemini
- **Offline Support**: Cache forex rates for offline access
- **Multi-platform**: Supports Android, iOS, Web, and Desktop

## Architecture 🏗️

This project follows **Clean Architecture** principles:

```
lib/
├── core/                    # Core functionality
│   ├── error/              # Error handling (Failures, Exceptions)
│   ├── network/            # Network connectivity
│   ├── cache/              # Caching layer
│   ├── utils/              # Utilities (Logger, Validators)
│   └── theme/              # App theming
├── features/               # Feature modules
│   ├── forex/
│   │   ├── data/          # Data sources & services
│   │   ├── domain/        # Business logic & models
│   │   └── presentation/  # UI & state management
│   ├── budget/
│   └── jarvis/
└── config/                 # App configuration
```

## Getting Started 🚀

### Prerequisites

- Flutter SDK: `>=3.2.0 <4.0.0`
- Dart SDK: `>=3.2.0`
- Android Studio / VS Code
- Firebase account (for Jarvis AI features)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Asif-Nazeer-Gondal/ForexCompanion.git
   cd ForexCompanion
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   Create a `.env` file in the root directory:
   ```bash
   FOREX_API_KEY=your_forex_api_key_here
   FOREX_API_URL=https://api.exchangerate-api.com/v4/latest/
   GEMINI_API_KEY=your_gemini_api_key_here
   PRODUCTION=false
   ```

4. **Configure Firebase**
    - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
    - Add Android/iOS apps to your Firebase project
    - Download and place `google-services.json` (Android) in `android/app/`
    - Download and place `GoogleService-Info.plist` (iOS) in `ios/Runner/`
    - Enable Firestore and Authentication in Firebase Console

5. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## Testing 🧪

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Generate coverage report (HTML)
```bash
genhtml coverage/lcov.info -o coverage/html
```

### Run specific test file
```bash
flutter test test/features/forex/data/forex_repository_impl_test.dart
```

## Building for Release 📦

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Project Structure Details 📁

### Core Modules

- **Error Handling**: Centralized error handling with `Failure` and `Exception` types
- **Network**: Connectivity checks and network status monitoring
- **Cache**: Hive-based caching for offline support
- **Logger**: Structured logging with different log levels

### Features

#### Forex
- Real-time currency exchange rates
- Historical rate tracking
- Offline caching with 15-minute expiry
- Retry logic for failed API calls

#### Budget
- Create and manage budgets
- Track income and expenses
- Local storage with Drift (SQLite)
- Budget summaries and analytics

#### Jarvis (AI Assistant)
- Chat-based interface
- Google Gemini AI integration
- Financial advice and insights
- Transaction tracking support

## Dependencies 📚

### Core
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `fpdart` - Functional programming (Either type)

### Data & Storage
- `drift` - Local database (SQLite)
- `hive` - Key-value cache
- `firebase_core` & `cloud_firestore` - Cloud storage

### Network
- `http` - HTTP client
- `connectivity_plus` - Network status
- `retry` - Retry logic for API calls

### UI
- `google_fonts` - Custom fonts
- `flutter_markdown_plus` - Markdown rendering

### Development
- `flutter_lints` - Linting rules
- `mockito` - Mocking for tests
- `build_runner` - Code generation

## Code Quality 🎯

This project maintains high code quality through:

- ✅ Clean Architecture principles
- ✅ Comprehensive error handling with `Either<Failure, Success>`
- ✅ Unit tests with 60%+ coverage target
- ✅ Integration tests for critical flows
- ✅ Structured logging
- ✅ Input validation
- ✅ Offline-first approach

## Contributing 🤝

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow the existing architecture pattern
- Write tests for new features
- Use meaningful commit messages
- Update documentation as needed
- Run `flutter analyze` before committing

## Troubleshooting 🔧

### Common Issues

**Build errors after pulling changes**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Firebase authentication issues**
- Ensure Firebase is properly configured
- Check that google-services.json is in the correct location
- Verify Firebase project settings

**Network errors in tests**
- Make sure mock objects are properly configured
- Check that NetworkInfo is being injected

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact 📧

Asif Nazeer Gondal - [@GitHub](https://github.com/Asif-Nazeer-Gondal)

Project Link: [https://github.com/Asif-Nazeer-Gondal/ForexCompanion](https://github.com/Asif-Nazeer-Gondal/ForexCompanion)

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Riverpod for state management
- Firebase for backend services
- Google Gemini for AI capabilities