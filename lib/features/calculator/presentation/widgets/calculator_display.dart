import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_sizes.dart';

class CalculatorDisplay extends StatelessWidget {
  final String expression;
  final String displayValue;
  final bool hasError;
  final VoidCallback onDelete;

  const CalculatorDisplay({
    super.key,
    required this.expression,
    required this.displayValue,
    required this.hasError,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingBody, vertical: AppSizes.paddingInside),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkDisplayBg : AppColors.lightDisplayBg,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12, width: 1),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top expression line & delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  key: const Key('calculator_backspace_button'),
                  icon: const Icon(Icons.backspace_outlined, size: 20),
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  onPressed: onDelete,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      expression.isEmpty ? ' ' : expression,
                      key: const Key('calculator_expression_text'),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Main display number / result
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                displayValue,
                key: const Key('calculator_display_text'),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: hasError ? AppColors.error : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
