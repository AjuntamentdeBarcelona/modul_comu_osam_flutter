enum RatingControlResponse {
  ACCEPTED,
  DISMISSED,
  CANCELLED,
  LATER,
  ERROR,
}

extension RatingControlResponseExtensions on RatingControlResponse {
  static RatingControlResponse fromString(String ratingControlResponse) {
    switch (ratingControlResponse) {
      case "ACCEPTED":
        return RatingControlResponse.ACCEPTED;
      case "DISMISSED":
        return RatingControlResponse.DISMISSED;
      case "CANCELLED":
        return RatingControlResponse.CANCELLED;
      case "LATER":
        return RatingControlResponse.LATER;
      case "ERROR":
        return RatingControlResponse.ERROR;
      default:
        return RatingControlResponse.DISMISSED;
    }
  }
}
