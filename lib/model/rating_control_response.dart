enum RatingControlResponse {
  ACCEPTED,
  DISMISSED,
  ERROR,
}

extension RatingControlResponseExtensions on RatingControlResponse {
  static RatingControlResponse fromString(String ratingControlResponse) {
    switch (ratingControlResponse) {
      case "ACCEPTED":
        return RatingControlResponse.ACCEPTED;
      case "DISMISSED":
        return RatingControlResponse.DISMISSED;
      case "ERROR":
        return RatingControlResponse.ERROR;
      default:
        return RatingControlResponse.DISMISSED;
    }
  }
}
