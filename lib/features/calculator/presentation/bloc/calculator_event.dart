part of 'calculator_bloc.dart';

sealed class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

class NumberPressedEvent extends CalculatorEvent {
  final String digit;

  const NumberPressedEvent({required this.digit});

  @override
  List<Object?> get props => [digit];
}

class OperatorPressedEvent extends CalculatorEvent {
  final String operator;

  const OperatorPressedEvent({required this.operator});

  @override
  List<Object?> get props => [operator];
}

class ClearPressedEvent extends CalculatorEvent {
  const ClearPressedEvent();
}

class DeletePressedEvent extends CalculatorEvent {
  const DeletePressedEvent();
}

class ToggleSignPressedEvent extends CalculatorEvent {
  const ToggleSignPressedEvent();
}

class PercentagePressedEvent extends CalculatorEvent {
  const PercentagePressedEvent();
}

class CalculatePressedEvent extends CalculatorEvent {
  const CalculatePressedEvent();
}
