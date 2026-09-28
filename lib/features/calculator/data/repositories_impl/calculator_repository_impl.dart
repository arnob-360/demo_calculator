import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/calculator_result_entity.dart';
import '../../domain/repositories/calculator_repository.dart';
import '../data_source/calculator_local_data_source.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  final CalculatorLocalDataSource localDataSource;

  CalculatorRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, CalculatorResultEntity>> calculate(
    String expression,
  ) async {
    try {
      final result = await localDataSource.calculate(expression);
      return Right(result);
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }
}
