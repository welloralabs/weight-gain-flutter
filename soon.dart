import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';

/// Placeholder for sections that arrive in the next build stages.
class SoonScreen extends StatelessWidget {
  final String title;
  final String sub;
  final int tab;
  final IconData icon;
  const SoonScreen({
    super.key,
    required this.title,
    required this.sub,
    required this.tab,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.navColor(context, tab);
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        Heading(title, sub: sub),
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 44, color: color),
              const SizedBox(height: 12),
              Text('Coming in the next build',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text(context))),
              const SizedBox(height: 6),
              Text('This section is being ported from the web app and will arrive in the next stage.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: AppColors.muted(context))),
            ],
          ),
        ),
      ],
    );
  }
}
