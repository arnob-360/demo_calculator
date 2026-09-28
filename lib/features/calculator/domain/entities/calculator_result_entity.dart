import 'package:equatable/equatable.dart';

class CalculatorResultEntity extends Equatable {
  final String expression;
  final String result;

  const CalculatorResultEntity({
    required this.expression,
    required this.result,
  });

  @override
  List<Object?> get props => [expression, result];
}
