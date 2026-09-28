import '../../domain/entities/calculator_result_entity.dart';

class CalculatorResultModel extends CalculatorResultEntity {
  const CalculatorResultModel({
    required super.expression,
    required super.result,
  });

  factory CalculatorResultModel.fromJson(Map<String, dynamic> json) {
    return CalculatorResultModel(
      expression: json['expression'] as String? ?? '',
      result: json['result'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'expression': expression, 'result': result};
  }
}
