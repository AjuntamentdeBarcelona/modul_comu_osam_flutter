/// Represents the result of an FCM token retrieval operation.
sealed class TokenResponse {}

/// Represents a successful token retrieval.
final class Success extends TokenResponse {
  /// The retrieved FCM token.
  final String token;

  Success(this.token);
}

/// Represents a failed token retrieval.
final class Error extends TokenResponse {
  /// The exception that occurred during the operation.
  final Exception error;

  Error(this.error);
}
