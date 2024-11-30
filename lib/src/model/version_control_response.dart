// ignore_for_file: constant_identifier_names

/// User actions with the version control popup
enum VersionControlResponse {
  /// If the user has chosen the accept/ok button
  ACCEPTED,

  /// If the user has chosen the dismiss button (remove popup)
  DISMISSED,

  /// If the user has chosen the cancel button (remove popup)
  CANCELLED,

  /// if there was an error in the process of obtaining
  /// the necessary information or in displaying the popup
  ERROR,
}

extension VersionControlResponseExtensions on VersionControlResponse {
  static VersionControlResponse fromString(String versionControlResponse) {
    switch (versionControlResponse) {
      case 'ACCEPTED':
        return VersionControlResponse.ACCEPTED;
      case 'DISMISSED':
        return VersionControlResponse.DISMISSED;
      case 'CANCELLED':
        return VersionControlResponse.CANCELLED;
      case 'ERROR':
        return VersionControlResponse.ERROR;
      default:
        return VersionControlResponse.DISMISSED;
    }
  }
}
