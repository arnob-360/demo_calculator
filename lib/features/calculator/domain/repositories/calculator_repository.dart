import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/calculator_result_entity.dart';

abstract class CalculatorRepository {
  Future<Either<Failure, CalculatorResultEntity>> calculate(String expression);
}
