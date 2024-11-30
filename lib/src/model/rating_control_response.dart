// ignore_for_file: constant_identifier_names

/// Rating popup behavior
enum RatingControlResponse {
  /// The native rating popup for each platform has been requested
  ACCEPTED,

  /// The popup does not meet the conditions to be shown to the user
  DISMISSED,

  /// If there was an error in the process of obtaining the necessary
  /// information or in displaying the popup
  ERROR,
}

extension RatingControlResponseExtensions on RatingControlResponse {
  static RatingControlResponse fromString(String ratingControlResponse) {
    switch (ratingControlResponse) {
      case 'ACCEPTED':
        return RatingControlResponse.ACCEPTED;
      case 'DISMISSED':
        return RatingControlResponse.DISMISSED;
      case 'ERROR':
        return RatingControlResponse.ERROR;
      default:
        return RatingControlResponse.DISMISSED;
    }
  }
}
