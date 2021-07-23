import 'package:flutter/widgets.dart';

enum AppLanguage { CA, ES, EN }

extension LanguageExtensions on AppLanguage {
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
        return Locale("ca", "ES");
      case AppLanguage.ES:
        return Locale("es", "ES");
      case AppLanguage.EN:
        return Locale("en", "US");
      default:
        return Locale("ca", "ES");
    }
  }
}
