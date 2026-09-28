import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_sizes.dart';
import '../../../../core/constant/app_values.dart';
import '../bloc/calculator_bloc.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_display.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text(
          AppValues.appName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingBody,
            vertical: AppSizes.paddingInside,
          ),
          child: BlocBuilder<CalculatorBloc, CalculatorState>(
            builder: (context, state) {
              final bloc = context.read<CalculatorBloc>();

              return Column(
                children: [
                  // Upper display area
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CalculatorDisplay(
                        expression: state.expression,
                        displayValue: state.displayValue,
                        hasError: state.hasError,
                        onDelete: () => bloc.add(const DeletePressedEvent()),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sizedBoxHeight),

                  // Keypad rows
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row 1: AC, +/-, %, ÷
                      Row(
                        children: [
                          CalculatorButton(
                            text: 'AC',
                            type: CalculatorButtonType.action,
                            onPressed: () =>
                                bloc.add(const ClearPressedEvent()),
                          ),
                          CalculatorButton(
                            text: '+/-',
                            type: CalculatorButtonType.action,
                            onPressed: () =>
                                bloc.add(const ToggleSignPressedEvent()),
                          ),
                          CalculatorButton(
                            text: '%',
                            type: CalculatorButtonType.action,
                            onPressed: () =>
                                bloc.add(const PercentagePressedEvent()),
                          ),
                          CalculatorButton(
                            text: '÷',
                            type: CalculatorButtonType.operator,
                            onPressed: () => bloc.add(
                              const OperatorPressedEvent(operator: '÷'),
                            ),
                          ),
                        ],
                      ),

                      // Row 2: 7, 8, 9, ×
                      Row(
                        children: [
                          CalculatorButton(
                            text: '7',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '7')),
                          ),
                          CalculatorButton(
                            text: '8',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '8')),
                          ),
                          CalculatorButton(
                            text: '9',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '9')),
                          ),
                          CalculatorButton(
                            text: '×',
                            type: CalculatorButtonType.operator,
                            onPressed: () => bloc.add(
                              const OperatorPressedEvent(operator: '×'),
                            ),
                          ),
                        ],
                      ),

                      // Row 3: 4, 5, 6, -
                      Row(
                        children: [
                          CalculatorButton(
                            text: '4',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '4')),
                          ),
                          CalculatorButton(
                            text: '5',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '5')),
                          ),
                          CalculatorButton(
                            text: '6',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '6')),
                          ),
                          CalculatorButton(
                            text: '-',
                            type: CalculatorButtonType.operator,
                            onPressed: () => bloc.add(
                              const OperatorPressedEvent(operator: '-'),
                            ),
                          ),
                        ],
                      ),

                      // Row 4: 1, 2, 3, +
                      Row(
                        children: [
                          CalculatorButton(
                            text: '1',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '1')),
                          ),
                          CalculatorButton(
                            text: '2',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '2')),
                          ),
                          CalculatorButton(
                            text: '3',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '3')),
                          ),
                          CalculatorButton(
                            text: '+',
                            type: CalculatorButtonType.operator,
                            onPressed: () => bloc.add(
                              const OperatorPressedEvent(operator: '+'),
                            ),
                          ),
                        ],
                      ),

                      // Row 5: 0, ., =
                      Row(
                        children: [
                          CalculatorButton(
                            text: '0',
                            flex: 2,
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '0')),
                          ),
                          CalculatorButton(
                            text: '.',
                            type: CalculatorButtonType.number,
                            onPressed: () =>
                                bloc.add(const NumberPressedEvent(digit: '.')),
                          ),
                          CalculatorButton(
                            text: '=',
                            type: CalculatorButtonType.equal,
                            onPressed: () =>
                                bloc.add(const CalculatePressedEvent()),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
