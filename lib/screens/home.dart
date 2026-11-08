import 'package:flutter/material.dart';

import '../links.dart';
import '../logic/calc.dart';
import '../theme.dart';
import '../widgets.dart';
import 'tool.dart';
import 'weight_gain.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning!';
    if (h < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final pal = AppColors.green(context);
    final text = AppColors.text(context);
    final muted = AppColors.muted(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F7A4F), Color(0xFF0A5D3C)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Color(0x470F7A4F), blurRadius: 30, offset: Offset(0, 14)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting(),
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 4),
              const Text('Get healthier, stronger and better every day',
                  style: TextStyle(fontSize: 14.5, color: Color(0xEEFFFFFF))),
            ],
          ),
        ),
        AppCard(
          color: pal.soft,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today\u2019s Main Feature',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: muted)),
              const SizedBox(height: 2),
              Text('Weight Gain Calculator',
                  style: TextStyle(
                      fontSize: 22, height: 1.25, fontWeight: FontWeight.w800, color: text)),
              const SizedBox(height: 4),
              Text('Find your daily calories and the time to reach your target weight.',
                  style: TextStyle(fontSize: 14, color: muted)),
              const SizedBox(height: 12),
              PillButton(
                text: 'Calculate Now \u2192',
                color: pal.a,
                textColor: AppColors.onAccent(context),
                onTap: () => _open(context, const WeightGainScreen()),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quick Access',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: text)),
              InkWell(
                onTap: () => Nav.goTab(context, 1),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text('View All',
                      style: TextStyle(fontWeight: FontWeight.w800, color: pal.a)),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _QuickTile(
                icon: Icons.trending_up_rounded,
                colors: AppColors.icPurple,
                title: 'Weight Gain\nCalculator',
                onTap: () => _open(context, const WeightGainScreen()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickTile(
                icon: Icons.speed_rounded,
                colors: AppColors.icBlue,
                title: 'BMI\nCalculator',
                onTap: () => _open(context, const ToolScreen(kind: ToolKind.bmi)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickTile(
                icon: Icons.egg_alt_rounded,
                colors: AppColors.icOrange,
                title: 'Protein\nCalculator',
                onTap: () => _open(context, const ToolScreen(kind: ToolKind.protein)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickTile(
                icon: Icons.trending_down_rounded,
                colors: AppColors.icGreen,
                title: 'Weight Loss\nCalculator',
                onTap: () => _open(context, const ToolScreen(kind: ToolKind.loss)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Health Tips',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, color: text)),
              const SizedBox(height: 4),
              Text(
                'Stay consistent. Small steps create big results! Weigh yourself once a week, sleep 7\u20139 hours and eat enough protein.',
                style: TextStyle(fontSize: 13.5, height: 1.45, color: muted),
              ),
            ],
          ),
        ),
        // Sponsored link - kept on purpose, do not remove or change.
        AppCard(
          padding: EdgeInsets.zero,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => openUrl(kSponsoredUrl),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Sponsored Link',
                  style: TextStyle(
                      fontSize: 15.5,
                      color: text,
                      decoration: TextDecoration.underline,
                      decorationColor: text)),
            ),
          ),
        ),
        const SectLabel('Why you can trust this app'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TrustBox(
                  icon: Icons.functions_rounded,
                  title: 'Standard formulas',
                  text: 'Mifflin-St Jeor for calories, WHO ranges for BMI.'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _TrustBox(
                  icon: Icons.lock_outline_rounded,
                  title: 'Private by design',
                  text: 'No sign-up. Your details stay on your phone.'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TrustBox(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Honest estimates',
                  text: 'Results are guidance, not medical advice.'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _TrustBox(
                  icon: Icons.mail_outline_rounded,
                  title: 'Real support',
                  text: kSupportEmail),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _HowWeCalculate(),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => openUrl(kAboutUrl),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('About this app',
                    style: TextStyle(
                        fontSize: 13, color: muted, decoration: TextDecoration.underline)),
              ),
            ),
            Text('\u00b7', style: TextStyle(color: muted)),
            InkWell(
              onTap: () => openUrl(kPrivacyUrl),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Privacy Policy',
                    style: TextStyle(
                        fontSize: 13, color: muted, decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final List<Color> colors;
  final String title;
  final VoidCallback onTap;
  const _QuickTile({
    required this.icon,
    required this.colors,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.shadow(context),
      ),
      child: Material(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconTile(icon: icon, colors: colors),
                const SizedBox(height: 10),
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text(context))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _TrustBox({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.shadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26, color: AppColors.green(context).a),
          const SizedBox(height: 6),
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text(context))),
          const SizedBox(height: 3),
          Text(text,
              style: TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.muted(context))),
        ],
      ),
    );
  }
}

class _HowWeCalculate extends StatelessWidget {
  Widget _p(BuildContext context, String bold, String rest) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: bold, style: const TextStyle(fontWeight: FontWeight.w800)),
            TextSpan(text: rest),
          ],
        ),
        style: TextStyle(fontSize: 13.5, height: 1.5, color: AppColors.text(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(12),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: const IconTile(icon: Icons.menu_book_rounded, colors: AppColors.icGreen),
          title: Text('How we calculate',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: AppColors.text(context))),
          subtitle: Text('Formulas and sources, in plain words',
              style: TextStyle(fontSize: 13, color: AppColors.muted(context))),
          children: [
            _p(context, 'Daily calories (BMR). ',
                'Mifflin-St Jeor: 10 \u00d7 kg + 6.25 \u00d7 cm \u2212 5 \u00d7 age + 5 for men, \u2212 161 for women. We then multiply by your activity level (1.2 to 1.725) to get maintenance calories.'),
            _p(context, 'Weight gain or loss. ',
                'About 7,700 kcal equals 1 kg of body weight, so 500 g a week means roughly 550 kcal more (or less) per day.'),
            _p(context, 'Protein. ',
                '1.6 to 2.0 g per kg is a common range for people building muscle. Maintenance is about 0.8 to 1.0 g per kg.'),
            _p(context, 'BMI. ',
                'kg \u00f7 m\u00b2. Adult ranges follow the WHO: under 18.5, 18.5 to 24.9, 25 to 29.9 and 30 or more.'),
            _p(context, 'Ideal weight. ',
                'Devine formula, shown next to the healthy BMI range.'),
            _p(context, '',
                'Diet prices and nutrition values are approximate. Always check with a doctor or dietitian before big changes.'),
          ],
        ),
      ),
    );
  }
}
