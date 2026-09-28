import '../../../../core/errors/app_exception_message.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/calculator_result_model.dart';

abstract class CalculatorLocalDataSource {
  Future<CalculatorResultModel> calculate(String expression);
}

class CalculatorLocalDataSourceImpl implements CalculatorLocalDataSource {
  @override
  Future<CalculatorResultModel> calculate(String expression) async {
    final sanitized = expression.trim();
    if (sanitized.isEmpty) {
      throw CalculationException(
        message: AppExceptionMessage.invalidExpression,
      );
    }

    try {
      final double evalResult = _evaluate(sanitized);
      if (evalResult.isNaN || evalResult.isInfinite) {
        throw CalculationException(message: AppExceptionMessage.divisionByZero);
      }

      final String formattedResult = _formatResult(evalResult);
      return CalculatorResultModel(
        expression: sanitized,
        result: formattedResult,
      );
    } on CalculationException {
      rethrow;
    } catch (_) {
      throw CalculationException(
        message: AppExceptionMessage.invalidExpression,
      );
    }
  }

  String _formatResult(double val) {
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    // Limit decimal precision and trim trailing zeroes
    String str = val.toStringAsFixed(8);
    while (str.contains('.') && (str.endsWith('0') || str.endsWith('.'))) {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }

  double _evaluate(String expr) {
    final tokens = _tokenize(expr);
    if (tokens.isEmpty) {
      throw CalculationException(
        message: AppExceptionMessage.invalidExpression,
      );
    }

    final rpn = _toRpn(tokens);
    return _evaluateRpn(rpn);
  }

  List<String> _tokenize(String expr) {
    final clean = expr
        .replaceAll(' ', '')
        .replaceAll('×', '*')
        .replaceAll('÷', '/');
    final List<String> tokens = [];
    final StringBuffer numBuffer = StringBuffer();

    for (int i = 0; i < clean.length; i++) {
      final char = clean[i];

      if ((char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) ||
          char == '.') {
        numBuffer.write(char);
      } else if (char == '+' ||
          char == '-' ||
          char == '*' ||
          char == '/' ||
          char == '%' ||
          char == '(' ||
          char == ')') {
        if (numBuffer.isNotEmpty) {
          tokens.add(numBuffer.toString());
          numBuffer.clear();
        }

        // Check for unary minus:
        // A minus is unary if it is at the start, or immediately preceded by an operator or '('
        if (char == '-') {
          final isUnary =
              tokens.isEmpty ||
              tokens.last == '(' ||
              tokens.last == '+' ||
              tokens.last == '-' ||
              tokens.last == '*' ||
              tokens.last == '/' ||
              tokens.last == '%';
          if (isUnary) {
            numBuffer.write(char);
            continue;
          }
        }

        tokens.add(char);
      } else {
        throw CalculationException(
          message: AppExceptionMessage.invalidExpression,
        );
      }
    }

    if (numBuffer.isNotEmpty) {
      tokens.add(numBuffer.toString());
    }

    return tokens;
  }

  int _precedence(String op) {
    switch (op) {
      case '+':
      case '-':
        return 1;
      case '*':
      case '/':
      case '%':
        return 2;
      default:
        return 0;
    }
  }

  List<String> _toRpn(List<String> tokens) {
    final List<String> output = [];
    final List<String> opStack = [];

    for (final token in tokens) {
      final numVal = double.tryParse(token);
      if (numVal != null) {
        output.add(token);
      } else if (token == '(') {
        opStack.add(token);
      } else if (token == ')') {
        while (opStack.isNotEmpty && opStack.last != '(') {
          output.add(opStack.removeLast());
        }
        if (opStack.isEmpty || opStack.last != '(') {
          throw CalculationException(
            message: AppExceptionMessage.invalidExpression,
          );
        }
        opStack.removeLast(); // pop '('
      } else {
        // Operator
        while (opStack.isNotEmpty &&
            opStack.last != '(' &&
            _precedence(opStack.last) >= _precedence(token)) {
          output.add(opStack.removeLast());
        }
        opStack.add(token);
      }
    }

    while (opStack.isNotEmpty) {
      final top = opStack.removeLast();
      if (top == '(' || top == ')') {
        throw CalculationException(
          message: AppExceptionMessage.invalidExpression,
        );
      }
      output.add(top);
    }

    return output;
  }

  double _evaluateRpn(List<String> rpn) {
    final List<double> stack = [];

    for (final token in rpn) {
      final val = double.tryParse(token);
      if (val != null) {
        stack.add(val);
      } else {
        if (stack.length < 2) {
          throw CalculationException(
            message: AppExceptionMessage.invalidExpression,
          );
        }
        final b = stack.removeLast();
        final a = stack.removeLast();

        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            if (b == 0) {
              throw CalculationException(
                message: AppExceptionMessage.divisionByZero,
              );
            }
            stack.add(a / b);
            break;
          case '%':
            if (b == 0) {
              throw CalculationException(
                message: AppExceptionMessage.divisionByZero,
              );
            }
            stack.add(a % b);
            break;
          default:
            throw CalculationException(
              message: AppExceptionMessage.invalidExpression,
            );
        }
      }
    }

    if (stack.length != 1) {
      throw CalculationException(
        message: AppExceptionMessage.invalidExpression,
      );
    }

    return stack.single;
  }
}
