abstract class Failure {
  final String message;
  final Map<String, dynamic>? data;

  Failure(this.message, {this.data});
}

class CalculationFailure extends Failure {
  CalculationFailure(super.message, {super.data});
}

class CacheFailure extends Failure {
  CacheFailure(super.message, {super.data});
}
