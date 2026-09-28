import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/calculate_expression_usecase.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final CalculateExpressionUsecase _calculateExpressionUsecase;

  CalculatorBloc(this._calculateExpressionUsecase)
    : super(const CalculatorState()) {
    on<NumberPressedEvent>(_onNumberPressed);
    on<OperatorPressedEvent>(_onOperatorPressed);
    on<ClearPressedEvent>(_onClearPressed);
    on<DeletePressedEvent>(_onDeletePressed);
    on<ToggleSignPressedEvent>(_onToggleSignPressed);
    on<PercentagePressedEvent>(_onPercentagePressed);
    on<CalculatePressedEvent>(_onCalculatePressed);
  }

  void _onNumberPressed(
    NumberPressedEvent event,
    Emitter<CalculatorState> emit,
  ) {
    if (state.hasError || state.isEvaluated) {
      if (event.digit == '.') {
        emit(CalculatorState(expression: '0.', displayValue: '0.'));
      } else {
        emit(
          CalculatorState(expression: event.digit, displayValue: event.digit),
        );
      }
      return;
    }

    final currentExpr = state.expression;

    if (event.digit == '.') {
      // Find the current number token (from the last operator)
      final lastOperatorIdx = currentExpr.lastIndexOf(RegExp(r'[\+\-\×\÷]'));
      final currentNumberSegment = lastOperatorIdx == -1
          ? currentExpr
          : currentExpr.substring(lastOperatorIdx + 1);

      if (currentNumberSegment.contains('.')) {
        return; // Prevent multiple decimal points in one number
      }

      if (currentExpr.isEmpty ||
          currentExpr.endsWith(' ') ||
          currentNumberSegment.isEmpty) {
        final newExpr = '${currentExpr}0.';
        emit(state.copyWith(expression: newExpr, displayValue: newExpr));
        return;
      }
    }

    String newExpr;
    if (currentExpr == '0' && event.digit != '.') {
      newExpr = event.digit;
    } else {
      newExpr = '$currentExpr${event.digit}';
    }

    emit(state.copyWith(expression: newExpr, displayValue: newExpr));
  }

  void _onOperatorPressed(
    OperatorPressedEvent event,
    Emitter<CalculatorState> emit,
  ) {
    if (state.hasError) {
      emit(
        CalculatorState(
          expression: '0 ${event.operator} ',
          displayValue: '0 ${event.operator} ',
        ),
      );
      return;
    }

    String currentExpr = state.expression;

    if (state.isEvaluated && state.result != null) {
      // Chain previous result into new calculation
      currentExpr = state.result!;
    }

    if (currentExpr.isEmpty) {
      currentExpr = '0';
    }

    final trimmed = currentExpr.trimRight();
    final lastChar = trimmed.isNotEmpty ? trimmed[trimmed.length - 1] : '';

    if (lastChar == '+' ||
        lastChar == '-' ||
        lastChar == '×' ||
        lastChar == '÷') {
      // Replace previous operator
      final withoutOp = trimmed.substring(0, trimmed.length - 1).trimRight();
      final newExpr = '$withoutOp ${event.operator} ';
      emit(
        state.copyWith(
          expression: newExpr,
          displayValue: newExpr,
          isEvaluated: false,
        ),
      );
      return;
    }

    final newExpr = '$trimmed ${event.operator} ';
    emit(
      state.copyWith(
        expression: newExpr,
        displayValue: newExpr,
        isEvaluated: false,
      ),
    );
  }

  void _onClearPressed(ClearPressedEvent event, Emitter<CalculatorState> emit) {
    emit(const CalculatorState());
  }

  void _onDeletePressed(
    DeletePressedEvent event,
    Emitter<CalculatorState> emit,
  ) {
    if (state.hasError || state.isEvaluated) {
      emit(const CalculatorState());
      return;
    }

    final currentExpr = state.expression;
    if (currentExpr.isEmpty || currentExpr == '0') {
      emit(const CalculatorState());
      return;
    }

    String trimmed = currentExpr;
    if (trimmed.endsWith(' ')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }

    final newExpr = trimmed.substring(0, trimmed.length - 1).trimRight();
    final display = newExpr.isEmpty ? '0' : newExpr;

    emit(state.copyWith(expression: newExpr, displayValue: display));
  }

  void _onToggleSignPressed(
    ToggleSignPressedEvent event,
    Emitter<CalculatorState> emit,
  ) {
    if (state.hasError || state.expression.isEmpty || state.expression == '0') {
      return;
    }

    final currentExpr = state.isEvaluated && state.result != null
        ? state.result!
        : state.expression;

    // Check if whole expression is just a single number
    final numVal = double.tryParse(currentExpr);
    if (numVal != null) {
      final toggled = -numVal;
      final formatted = toggled == toggled.roundToDouble()
          ? toggled.toInt().toString()
          : toggled.toString();
      emit(
        state.copyWith(
          expression: formatted,
          displayValue: formatted,
          isEvaluated: false,
        ),
      );
    }
  }

  void _onPercentagePressed(
    PercentagePressedEvent event,
    Emitter<CalculatorState> emit,
  ) {
    if (state.hasError || state.expression.isEmpty || state.expression == '0') {
      return;
    }

    final currentExpr = state.isEvaluated && state.result != null
        ? state.result!
        : state.expression;

    final numVal = double.tryParse(currentExpr);
    if (numVal != null) {
      final percentVal = numVal / 100.0;
      final formatted = percentVal.toString();
      emit(
        state.copyWith(
          expression: formatted,
          displayValue: formatted,
          isEvaluated: false,
        ),
      );
    }
  }

  Future<void> _onCalculatePressed(
    CalculatePressedEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    final expr = state.expression.trim();
    if (expr.isEmpty) return;

    final resultEither = await _calculateExpressionUsecase(expr);

    resultEither.fold(
      (failure) {
        emit(
          state.copyWith(
            hasError: true,
            errorMessage: failure.message,
            displayValue: failure.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            expression: expr,
            result: data.result,
            displayValue: data.result,
            isEvaluated: true,
            hasError: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
