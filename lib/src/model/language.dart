// ignore_for_file: constant_identifier_names

/// Represent langauges supported by the module
enum Language {
  /// Catalan
  CA,

  /// Spanish
  ES,

  /// English
  EN,
}

extension LanguageExtensions on Language {
  String toLanguageCode() {
    switch (this) {
      case Language.CA:
        return 'ca';
      case Language.ES:
        return 'es';
      case Language.EN:
        return 'en';
      default:
        return 'ca';
    }
  }

  static Language fromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'ca':
        return Language.CA;
      case 'es':
        return Language.ES;
      case 'en':
        return Language.EN;
      default:
        return Language.CA;
    }
  }
}
