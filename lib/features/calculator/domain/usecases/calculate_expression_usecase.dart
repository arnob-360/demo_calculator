import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/calculator_result_entity.dart';
import '../repositories/calculator_repository.dart';

class CalculateExpressionUsecase {
  final CalculatorRepository repository;

  CalculateExpressionUsecase(this.repository);

  Future<Either<Failure, CalculatorResultEntity>> call(
    String expression,
  ) async {
    return await repository.calculate(expression);
  }
}
