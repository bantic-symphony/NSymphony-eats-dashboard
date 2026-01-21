/// Base class for all application errors
sealed class AppError {
  final String message;
  const AppError(this.message);
}

class FirestoreError extends AppError {
  const FirestoreError(super.message);
}

class NetworkError extends AppError {
  const NetworkError(super.message);
}

class UnknownError extends AppError {
  const UnknownError(super.message);
}
