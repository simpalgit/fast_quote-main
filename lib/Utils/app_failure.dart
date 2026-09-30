abstract class Failure {
  final dynamic message;
  final int statusCode;

  const Failure(this.message, [this.statusCode = 404]);

  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(dynamic message, int statusCode)
      : super(message, statusCode);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}
