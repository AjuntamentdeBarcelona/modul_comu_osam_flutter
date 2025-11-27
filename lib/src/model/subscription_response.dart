/// Rating popup behavior
enum SubscriptionResponse {
  /// The native rating popup for each platform has been requested
  ACCEPTED,

  /// If there was an error in the process of obtaining the necessary
  /// information or in displaying the popup
  ERROR,
}

extension SubscriptionResponseExtensions on SubscriptionResponse {
  static SubscriptionResponse fromString(String subscriptionResponse) {
    switch (subscriptionResponse) {
      case 'ACCEPTED':
        return SubscriptionResponse.ACCEPTED;
      case 'ERROR':
        return SubscriptionResponse.ERROR;
      default:
        return SubscriptionResponse.ERROR;
    }
  }
}
