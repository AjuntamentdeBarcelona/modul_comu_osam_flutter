// ignore_for_file: constant_identifier_names

/// Information about the app
enum AppLanguageResponse {
  /// If the analytic has been sent
  SUCCESS,

  /// If the analytic has not been sent
  UNCHANGED,

  /// If there has been an error when sending the analytic
  ERROR,
}

extension AppLanguageResponseExtensions on AppLanguageResponse {
  static AppLanguageResponse fromString(String languageInformationResponse) {
    switch (languageInformationResponse) {
      case 'SUCCESS':
        return AppLanguageResponse.SUCCESS;
      case 'UNCHANGED':
        return AppLanguageResponse.UNCHANGED;
      case 'ERROR':
        return AppLanguageResponse.ERROR;
      default:
        return AppLanguageResponse.ERROR;
    }
  }
}
