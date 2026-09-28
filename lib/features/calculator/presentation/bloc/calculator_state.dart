part of 'calculator_bloc.dart';

class CalculatorState extends Equatable {
  final String expression;
  final String displayValue;
  final String? result;
  final bool isEvaluated;
  final bool hasError;
  final String? errorMessage;

  const CalculatorState({
    this.expression = '',
    this.displayValue = '0',
    this.result,
    this.isEvaluated = false,
    this.hasError = false,
    this.errorMessage,
  });

  CalculatorState copyWith({
    String? expression,
    String? displayValue,
    String? result,
    bool? isEvaluated,
    bool? hasError,
    String? errorMessage,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      displayValue: displayValue ?? this.displayValue,
      result: result ?? this.result,
      isEvaluated: isEvaluated ?? this.isEvaluated,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    expression,
    displayValue,
    result,
    isEvaluated,
    hasError,
    errorMessage,
  ];
}
