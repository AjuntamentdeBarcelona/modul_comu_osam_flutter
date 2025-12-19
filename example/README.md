# Common Module Flutter Example

This is a sample application to demonstrate the functionality of the `osam_common_module_flutter` plugin. The application showcases features like version control, in-app rating prompts, and remote configuration using Firebase.

## Features

- **Splash Screen**: The initial screen of the application that initializes the necessary services and navigates to the home screen.
- **Home Screen**: The main screen of the application, which provides access to other features.
- **Options Screen**: Allows configuration of the application's behavior, such as language, version name, and version code.
- **Info Screen**: Displays information about the application.
- **Actions Screen**: Demonstrates various actions that can be performed within the app.
- **Version Control**: Checks for updates and prompts the user to update the application if a new version is available.
- **In-App Rating**: Prompts the user to rate the application on the app store.
- **Firebase Integration**: Utilizes Firebase for remote configuration, analytics, and crashlytics.

## OSAM Repository Implementation

The `osam_common_module_flutter` plugin is integrated into the application through the `OsamRepositoryImpl` class, which implements the `OsamRepository` interface. This class provides the following functionality:

- **Version Control**: The `checkForUpdates` method calls the `osamSdk.versionControl` method to check for application updates. The language for the version control dialog is determined by the application's settings.
- **In-App Rating**: The `checkRating` method calls the `osamSdk.rating` method to prompt the user to rate the application. The language for the rating dialog is determined by the application's settings.
- **Language Change**: The `changeLanguageEvent` method calls the `osamSdk.changeLanguageEvent` method to notify the SDK that the application's language has changed.
- **First Time or Update Event**: The `firstTimeOrUpdateEvent` method calls the `osamSdk.firstTimeOrUpdateAppEvent` method to notify the SDK that the application has been launched for the first time or has been updated.
- **Device and App Information**: The `deviceInformation` and `appInformation` methods call the corresponding methods in the SDK to retrieve device and application information.
- **FCM Token**: The `getFCMToken` method calls the `osamSdk.getFCMToken` method to retrieve the Firebase Cloud Messaging token.
- **Custom Topic Subscription**: The `subscribeToCustomTopic` and `unsubscribeToCustomTopic` methods call the corresponding methods in the SDK to subscribe to and unsubscribe from custom topics.

## Permissions

The application requests the following permissions:

- **Notifications**: The application requests permission to display notifications. This is handled in the `_initializeMessaging` method in the `di.dart` file.

## Events

The application handles the following events from the `osam_common_module_flutter` plugin:

- **Crashlytics**: The `_onCrashlyticsException` method sends crash reports to Firebase Crashlytics.
- **Analytics**: The `_onAnalyticsEvent` method logs events to Firebase Analytics.
- **Performance**: The `_onPerformanceEvent` method sends performance metrics to Firebase Performance.
- **Messaging**: The `_onMessagingEvent` method handles messaging events, such as subscribing to and unsubscribing from topics.

## Project Structure

The project is organized into the following directories:

- `lib/`: The main source code of the application.
  - `di/`: Dependency injection setup.
  - `data/`: Data sources, such as remote and local data.
  - `mixin/`: Mixins used across the application.
  - `model/`: Data models.
  - `main.dart`: The entry point of the application.
  - `splash_screen.dart`: The splash screen.
  - `home_screen.dart`: The home screen.
  - `info_screen.dart`: The info screen.
  - `actions_screen.dart`: The actions screen.
  - `options_screen.dart`: The options screen.

## Dependencies

The project uses the following dependencies:

- `osam_common_module_flutter`: The core plugin being demonstrated.
- `shared_preferences`: For storing simple data.
- `group_radio_button`: For creating radio button groups.
- `flutter_fgbg`: For detecting when the app is in the foreground or background.
- `firebase_core`: For initializing Firebase.
- `firebase_analytics`: For analytics.
- `firebase_crashlytics`: For crash reporting.
- `firebase_performance`: For performance monitoring.
- `firebase_messaging`: For push notifications.
- `dio`: For making HTTP requests.

## How to Run

1. Clone the repository.
2. Navigate to the `example` directory.
3. Run `flutter pub get` to install the dependencies.
4. Run `flutter run` to launch the application.
