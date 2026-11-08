import 'package:flutter/material.dart';

import '../logic/calc.dart';
import '../theme.dart';
import '../widgets.dart';
import 'tool.dart';
import 'weight_gain.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        const Heading('Calculators', sub: 'Choose a calculator'),
        ListCard(
          icon: Icons.local_fire_department_rounded,
          colors: AppColors.icOrange,
          title: 'Calorie & BMR Calculator',
          sub: 'Know your daily calorie needs and BMR.',
          onTap: () => _open(context, const ToolScreen(kind: ToolKind.bmr)),
        ),
        ListCard(
          icon: Icons.trending_up_rounded,
          colors: AppColors.icPurple,
          title: 'Weight Gain Calculator',
          sub: 'Plan your healthy weight gain journey.',
          onTap: () => _open(context, const WeightGainScreen()),
        ),
        ListCard(
          icon: Icons.speed_rounded,
          colors: AppColors.icBlue,
          title: 'BMI Calculator',
          sub: 'Check your BMI and health range.',
          onTap: () => _open(context, const ToolScreen(kind: ToolKind.bmi)),
        ),
        ListCard(
          icon: Icons.egg_alt_rounded,
          colors: AppColors.icGreen,
          title: 'Protein Calculator',
          sub: 'Find your daily protein needs.',
          onTap: () => _open(context, const ToolScreen(kind: ToolKind.protein)),
        ),
        ListCard(
          icon: Icons.trending_down_rounded,
          colors: AppColors.icPink,
          title: 'Weight Loss Calculator',
          sub: 'Set your weight loss goal.',
          onTap: () => _open(context, const ToolScreen(kind: ToolKind.loss)),
        ),
        ListCard(
          icon: Icons.track_changes_rounded,
          colors: AppColors.icTeal,
          title: 'Ideal Weight Calculator',
          sub: 'Know your ideal body weight.',
          onTap: () => _open(context, const ToolScreen(kind: ToolKind.ideal)),
        ),
      ],
    );
  }
}
