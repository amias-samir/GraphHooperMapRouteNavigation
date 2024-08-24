/// Custom app exception class used for all forms of exceptions
///
class AppException implements Exception {
  /// Creates new instance of [AppException]
  ///
  const AppException({
    required this.statusCode,
    required this.message,
  });

  /// Error status code [statusCode]
  /// this status code is independent and is not linked to any other status codes like http status codes
  /// and is custom status code which is used for this project only.
  final int statusCode;

  /// Error message string [message]
  final String message;

  @override
  String toString() {
    return 'AppException{message: $message, statusCode: $statusCode}';
  }

  // status code 1 --> http exceptions
  // status code 2 -> app exceptions
}
