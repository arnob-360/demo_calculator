import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_sizes.dart';

enum CalculatorButtonType { number, operator, action, equal }

class CalculatorButton extends StatelessWidget {
  final String text;
  final CalculatorButtonType type;
  final VoidCallback onPressed;
  final int flex;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.type,
    required this.onPressed,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color textColor;

    switch (type) {
      case CalculatorButtonType.number:
        bgColor = isDark ? AppColors.darkBtnNumber : AppColors.lightBtnNumber;
        textColor = isDark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary;
        break;
      case CalculatorButtonType.operator:
        bgColor = isDark
            ? AppColors.darkBtnOperator
            : AppColors.lightBtnOperator;
        textColor = Colors.white;
        break;
      case CalculatorButtonType.action:
        bgColor = isDark ? AppColors.darkBtnAction : AppColors.lightBtnAction;
        textColor = isDark ? AppColors.secondary : AppColors.primary;
        break;
      case CalculatorButtonType.equal:
        bgColor = AppColors.secondary;
        textColor = Colors.white;
        break;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          elevation: isDark ? 0 : 1,
          shadowColor: Colors.black26,
          child: InkWell(
            key: Key('btn_$text'),
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            onTap: onPressed,
            child: Container(
              height: 64,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      type == CalculatorButtonType.operator ||
                          type == CalculatorButtonType.equal
                      ? FontWeight.bold
                      : FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
