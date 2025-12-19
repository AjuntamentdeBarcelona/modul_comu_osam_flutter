/// Rating popup behavior
enum SubscriptionResponse {
  /// The native rating popup for each platform has been requested
  accepted,

  /// If there was an error in the process of obtaining the necessary
  /// information or in displaying the popup
  error,
}

extension SubscriptionResponseExtensions on SubscriptionResponse {
  static SubscriptionResponse fromString(String subscriptionResponse) {
    switch (subscriptionResponse) {
      case 'ACCEPTED':
        return SubscriptionResponse.accepted;
      case 'ERROR':
        return SubscriptionResponse.error;
      default:
        return SubscriptionResponse.error;
    }
  }
}
