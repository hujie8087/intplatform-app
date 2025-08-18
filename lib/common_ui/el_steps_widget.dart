import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class StepData {
  final IconData icon;
  final String label;
  final String? description;
  StepData({required this.icon, required this.label, this.description});
}

class ElSteps extends StatelessWidget {
  final List<StepData> steps;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;
  final double stepRadius;

  const ElSteps({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.activeColor = primaryColor,
    this.inactiveColor = Colors.grey,
    this.completedColor = primaryColor,
    this.stepRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep;

            final bgColor =
                isCompleted
                    ? completedColor
                    : isActive
                    ? activeColor
                    : inactiveColor;

            final iconColor = Colors.white;

            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      if (index > 0)
                        Expanded(
                          child: Container(
                            height: 2,
                            color:
                                index <= currentStep
                                    ? completedColor
                                    : inactiveColor,
                          ),
                        ),
                      if (index == 0)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                        ),
                      Container(
                        width: stepRadius * 2,
                        height: stepRadius * 2,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          steps[index].icon,
                          size: stepRadius,
                          color: iconColor,
                        ),
                      ),
                      if (index < steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color:
                                index < currentStep
                                    ? completedColor
                                    : inactiveColor,
                          ),
                        ),
                      if (index == steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    steps[index].label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.px,
                      color: index <= currentStep ? activeColor : inactiveColor,
                    ),
                  ),
                  if (steps[index].description != null)
                    Text(
                      steps[index].description!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
