import 'package:flutter/material.dart';

import 'screens/calculators.dart';
import 'screens/home.dart';
import 'screens/soon.dart';
import 'theme.dart';
import 'widgets.dart';

void main() {
  runApp(const WgApp());
}

class WgApp extends StatelessWidget {
  const WgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Gain Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const Shell(),
    );
  }
}

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: Nav.tab,
      builder: (context, tab, _) {
        return Scaffold(
          backgroundColor: AppColors.bg(context),
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: tab,
              children: const [
                HomeScreen(),
                CalculatorsScreen(),
                SoonScreen(
                  title: 'Nutrition',
                  sub: 'Track your food, stay on plan',
                  tab: 2,
                  icon: Icons.restaurant_rounded,
                ),
                SoonScreen(
                  title: 'Workout',
                  sub: 'Stronger \u2022 Healthier \u2022 Happier',
                  tab: 3,
                  icon: Icons.fitness_center_rounded,
                ),
                SoonScreen(
                  title: 'My Profile',
                  sub: 'Your journey, your goals',
                  tab: 4,
                  icon: Icons.person_rounded,
                ),
              ],
            ),
          ),
          bottomNavigationBar: AppNav(current: tab),
        );
      },
    );
  }
}
