/// Information about the app
enum LanguageInformationResponse {
  /// If the analytic has been sent
  SENT,

  /// If the analytic has not been sent
  NOT_SENT,

  /// If there has been an error when sending the analytic
  ERROR,
}

extension LanguageInformationResponseExtensions on LanguageInformationResponse {
  static LanguageInformationResponse fromString(
      String languageInformationResponse) {
    switch (languageInformationResponse) {
      case 'SENT':
        return LanguageInformationResponse.SENT;
      case 'NOT_SENT':
        return LanguageInformationResponse.NOT_SENT;
      case 'ERROR':
        return LanguageInformationResponse.ERROR;
      default:
        return LanguageInformationResponse.ERROR;
    }
  }
}
