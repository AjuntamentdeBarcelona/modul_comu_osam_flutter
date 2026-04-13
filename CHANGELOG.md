## 8.1.5-dev

* IMPLEMENTED STYLES FLEXIBILITY FOR CUSTOM POPUPS
    * Added a parameter when building the version control popup for adding foreign styles or keeping their own.

## 8.1.2-dev

* IMPLEMENTED CUSTOM POPUPS
    * Added custom Flutter popups implementation to support dark/light mode colors (#1C1C1C and #B0B0B0) as requested.
    * Added UIHelper and OSAMDialog widget in the Flutter part.
    * Updated example app with "Custom Flutter Popup" button to test the new UI.

## 8.1.1-dev

* BREAKING CHANGES
    * Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to version 3.0.1-dev accessible popup.

## 8.1.0

* BREAKING CHANGES
    * Updated the app demo showing functionalities and configurations;
    * Adding new screens to the demo app.
    * Inclusion of user cases in the demo app for the providers to check if they want to.
    * Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to version 3.1.0 (adding more login version control and fixing some bugs);
    * To show icon in version control in iOS you need to add the image "dialog_app_icon" with the icon image.

## 8.0.0

* BREAKING CHANGES
  * Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to version 3.0.0; 
  * Adding the checkbox "Dont Show again" to modes INFO and LAZY.
  * For the INFO and LAZY modes, when the user opens version control and accepts, there is now a field that defines the amount of time before that popup appears again.
  * We have added language change analytic events for firebase.
  * Integrated Firebase Messaging to manage notification topic subscriptions based on language changes.

## 7.0.2

* BREAKING CHANGES
  * Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to version 2.2.4 fixing version control in app update and offline mode.

## 7.0.1

* BREAKING CHANGES
  * Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to version 2.2.3 fixing returned value from INFO mode.

## 7.0.0

* BREAKING CHANGES
  * Update dependencies
  * Compatibility with XCode 16
  * Need to use minimal Dart SDK version ^3.5.0
  * Need to use minimal Flutter version 3.24.3

## 6.0.0

* BREAKING CHANGES
  * Rename package from `common_module_flutter` to `osam_common_module_flutter`
  * To import, use only `import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';` and not src/ or other subdirectories.
  * Need to use minimal Dart SDK version 3.0.0
  * Need to use minimal Flutter version 3.10.0

## 5.1.0

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to version 2.1.8. Only for Android.
* Improve linting.
* Refactor package to pub dev standards.
* Refactor documentation.
* Add GitHub templates.

## 5.0.4

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to version 2.1.7.

## 5.0.0

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to
  version 2.0.16. Updated to version 5.0.0 of modul_comu_osam_flutter, it has flutter 3.X support.

## 4.0.2

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to
  version 2.0.2. This version has the following changes:
  * Version: Fix bug related to URL handling

## 4.0.1

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to
  version 2.0.1. This version has the following changes:
  * Rating: Exclude deprecated rating control responses

## 4.0.0

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to
  version 2.0.1. This version has the following changes:
  * Version: Integrated capability for enable/disable version control based in a time range
  * Rating: Integrated Google In App Review for Android

## 3.0.2

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to
  version 1.0.11. This version fixes a bug when using Proguard in Android.

## 3.0.1

* Updated [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) to
  version 1.0.10. This version fixes a bug of the rating popup in iOS.

## 3.0.0

* Using [modul_comu_osam library](https://github.com/AjuntamentdeBarcelona/modul_comu_osam) (
  developed using Kotlin Multiplatform Mobile, KMM) to implement the functionality of this library.
  This library is now a wrapper of the one developed in KMM.

## 2.0.1

* Fix Version Control Popup Context

## 2.0.0

* Migrated to null safety
* Fix english language in sample app

## 1.0.0

* First version of common module flutter (not null safety)