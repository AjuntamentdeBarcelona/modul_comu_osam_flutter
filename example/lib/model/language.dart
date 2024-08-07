// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

enum AppLanguage { CA, ES, EN }

extension AppLanguageExtensions on AppLanguage {
  String toLanguageCode() {
    switch (this) {
      case AppLanguage.CA:
        return "ca";
      case AppLanguage.ES:
        return "es";
      case AppLanguage.EN:
        return "en";
      default:
        return "ca";
    }
  }

  static AppLanguage fromLanguageCode(String languageCode) {
    switch (languageCode) {
      case "ca":
        return AppLanguage.CA;
      case "es":
        return AppLanguage.ES;
      case "en":
        return AppLanguage.EN;
      default:
        return AppLanguage.CA;
    }
  }

  Locale toLocale() {
    switch (this) {
      case AppLanguage.CA:
        return const Locale("ca", "ES");
      case AppLanguage.ES:
        return const Locale("es", "ES");
      case AppLanguage.EN:
        return const Locale("en", "US");
      default:
        return const Locale("ca", "ES");
    }
  }
}
