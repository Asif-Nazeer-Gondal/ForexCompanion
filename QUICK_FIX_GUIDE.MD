# Quick Fix for flutter_markdown_plus Dependency Issue

## Immediate Solution

Run this command to fix the dependency issue:

```bash
flutter pub add flutter_markdown_plus:^1.0.5
```

OR manually update your `pubspec.yaml`:

```yaml
dependencies:
  flutter_markdown_plus: ^1.0.5  # Changed from ^0.3.0
```

Then run:
```bash
flutter pub get
```

---

## Complete Updated pubspec.yaml

Replace your entire dependencies and dev_dependencies sections with this:

```yaml
name: forexcompanion
description: A forex companion app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.5.1
  
  # Firebase
  firebase_core: ^2.31.0
  firebase_analytics: ^10.10.0
  firebase_crashlytics: ^3.5.0
  cloud_firestore: ^4.17.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Networking
  http: ^1.2.0
  connectivity_plus: ^5.0.2
  
  # Functional Programming
  fpdart: ^1.1.0
  
  # UI & Fonts
  google_fonts: ^6.1.0
  flutter_markdown_plus: ^1.0.5  # CORRECTED VERSION
  
  # Logging
  logger: ^2.0.2
  
  # AI Integration
  google_generative_ai: ^0.4.0
  
  # Database
  drift: ^2.14.1
  path_provider: ^2.1.2
  path: ^1.9.0
  sqlite3_flutter_libs: ^0.5.0
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # Utils
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.8
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  drift_dev: ^2.14.1
  
  # Testing
  mockito: ^5.4.4
  
  # Linting
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  # Uncomment and add your assets if needed
  # assets:
  #   - assets/images/
  #   - assets/icons/
```

---

## Step-by-Step Recovery

### Step 1: Fix the Dependency
```bash
flutter pub add flutter_markdown_plus:^1.0.5
```

### Step 2: Get All Dependencies
```bash
flutter pub get
```

### Step 3: Verify
```bash
flutter doctor
flutter pub deps
```

### Step 4: Analyze
```bash
flutter analyze
```

---

## Alternative: Remove Unused Dependencies

If you're not using the Jarvis (AI chat) feature, you can remove these dependencies entirely:

**Remove from pubspec.yaml:**
- `flutter_markdown_plus`
- `google_generative_ai`
- `cloud_firestore`

**And delete the Jarvis feature folder:**
```bash
rm -rf lib/features/jarvis_disabled/
```

---

## If You Still Get Errors

### Option 1: Start Fresh with Minimal Dependencies

Create a minimal `pubspec.yaml` and add dependencies one by one:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  http: ^1.2.0
  google_fonts: ^6.1.0
  logger: ^2.0.2
  connectivity_plus: ^5.0.2
  fpdart: ^1.1.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  firebase_core: ^2.31.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.4
```

Then run:
```bash
flutter clean
flutter pub get
flutter analyze
```

### Option 2: Check Package Availability

Some packages might not be compatible with your Flutter version. Run:

```bash
flutter pub outdated
```

This will show you which packages need updates.

---

## Common Package Version Issues

If you encounter other version conflicts, use these tested versions:

```yaml
dependencies:
  # Core (Always use latest stable)
  flutter_riverpod: ^2.5.1
  
  # Firebase (Use same major version)
  firebase_core: ^2.31.0
  firebase_analytics: ^10.10.0
  firebase_crashlytics: ^3.5.0
  
  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Network
  http: ^1.2.0
  connectivity_plus: ^5.0.2
  
  # UI
  google_fonts: ^6.1.0
  flutter_markdown_plus: ^1.0.5
  
  # Utils
  logger: ^2.0.2
  fpdart: ^1.1.0
  intl: ^0.19.0
```

---

## Quick Command Reference

```bash
# Fix this specific issue
flutter pub add flutter_markdown_plus:^1.0.5

# OR update all packages
flutter pub upgrade

# Clean everything
flutter clean
rm -rf .dart_tool
rm pubspec.lock

# Start fresh
flutter pub get

# Check for issues
flutter doctor -v
flutter pub deps
flutter analyze
```

---

## Next Steps After Fixing Dependencies

Once `flutter pub get` succeeds:

1. **Fix Import Paths** (from original guide Section 2)
2. **Fix Syntax Errors** (from original guide Section 3)
3. **Create Missing Files** (from original guide Section 6)
4. **Run Code Generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## Need More Help?

If you're still stuck, share:
1. Your current `pubspec.yaml` file
2. Output of `flutter doctor -v`
3. Output of `flutter pub get`

---

## Summary

**The Problem:** `flutter_markdown_plus ^0.3.0` doesn't exist on pub.dev

**The Solution:** Use `flutter_markdown_plus: ^1.0.5`

**Quick Fix:**
```bash
flutter pub add flutter_markdown_plus:^1.0.5
flutter pub get
```

That's it! This should resolve your immediate dependency issue. 🎯