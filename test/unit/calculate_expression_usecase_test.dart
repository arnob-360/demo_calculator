import 'package:dartz/dartz.dart';
import 'package:demo_calculator/core/errors/failures.dart';
import 'package:demo_calculator/features/calculator/domain/entities/calculator_result_entity.dart';
import 'package:demo_calculator/features/calculator/domain/repositories/calculator_repository.dart';
import 'package:demo_calculator/features/calculator/domain/usecases/calculate_expression_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCalculatorRepository implements CalculatorRepository {
  bool shouldReturnError = false;

  @override
  Future<Either<Failure, CalculatorResultEntity>> calculate(String expression) async {
    if (shouldReturnError) {
      return Left(CalculationFailure('Calculation error'));
    }
    return const Right(CalculatorResultEntity(expression: '10 + 20', result: '30'));
  }
}

void main() {
  late CalculateExpressionUsecase usecase;
  late MockCalculatorRepository mockRepository;

  setUp(() {
    mockRepository = MockCalculatorRepository();
    usecase = CalculateExpressionUsecase(mockRepository);
  });

  test('should return CalculatorResultEntity on successful calculation', () async {
    final result = await usecase('10 + 20');

    expect(result.isRight(), true);
    result.fold((failure) => fail('Should have succeeded'), (entity) {
      expect(entity.expression, '10 + 20');
      expect(entity.result, '30');
    });
  });

  test('should return Failure when calculation fails', () async {
    mockRepository.shouldReturnError = true;
    final result = await usecase('invalid');

    expect(result.isLeft(), true);
    result.fold((failure) => expect(failure.message, 'Calculation error'), (_) => fail('Should have failed'));
  });
}
