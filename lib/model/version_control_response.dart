enum VersionControlResponse {
  ACCEPTED,
  DISMISSED,
  CANCELLED,
  ERROR,
}

extension VersionControlResponseExtensions on VersionControlResponse {

  static VersionControlResponse fromString(String versionControlResponse) {
    switch (versionControlResponse) {
      case "ACCEPTED":
        return VersionControlResponse.ACCEPTED;
      case "DISMISSED":
        return VersionControlResponse.DISMISSED;
      case "CANCELLED":
        return VersionControlResponse.CANCELLED;
      case "ERROR":
        return VersionControlResponse.ERROR;
      default:
        return VersionControlResponse.DISMISSED;
    }
  }
}