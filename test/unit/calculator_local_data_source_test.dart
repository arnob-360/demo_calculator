import 'package:demo_calculator/core/errors/exceptions.dart';
import 'package:demo_calculator/features/calculator/data/data_source/calculator_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculatorLocalDataSource dataSource;

  setUp(() {
    dataSource = CalculatorLocalDataSourceImpl();
  });

  group('CalculatorLocalDataSourceImpl Tests', () {
    test('should calculate simple addition correctly', () async {
      final result = await dataSource.calculate('5 + 3');
      expect(result.result, '8');
    });

    test(
      'should calculate with correct operator precedence (BODMAS)',
      () async {
        final result = await dataSource.calculate('2 + 3 × 4');
        expect(result.result, '14');
      },
    );

    test('should handle division and decimal results correctly', () async {
      final result = await dataSource.calculate('10 ÷ 4');
      expect(result.result, '2.5');
    });

    test('should handle subtraction correctly', () async {
      final result = await dataSource.calculate('15 - 8');
      expect(result.result, '7');
    });

    test('should handle negative numbers correctly', () async {
      final result = await dataSource.calculate('-5 + 12');
      expect(result.result, '7');
    });

    test('should throw CalculationException on division by zero', () async {
      expect(
        () => dataSource.calculate('8 ÷ 0'),
        throwsA(isA<CalculationException>()),
      );
    });

    test('should throw CalculationException on invalid syntax', () async {
      expect(
        () => dataSource.calculate('8 + +'),
        throwsA(isA<CalculationException>()),
      );
    });
  });
}
