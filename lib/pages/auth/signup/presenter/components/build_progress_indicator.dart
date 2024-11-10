import 'package:ctree/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class BuildProgressIndicator extends StatelessWidget {
  final int step;
  final int remainingSteps;
  const BuildProgressIndicator(
      {super.key, required this.step, required this.remainingSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: step,
          child: Container(
            height: 4,
            color: AppColors.red,
          ),
        ),
        Expanded(
          flex: remainingSteps,
          child: Container(
            height: 4,
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}
