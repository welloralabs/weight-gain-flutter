import 'package:flutter/material.dart';

import '../logic/calc.dart';
import '../logic/format.dart';
import '../theme.dart';
import '../widgets.dart';

class WeightGainScreen extends StatefulWidget {
  const WeightGainScreen({super.key});

  @override
  State<WeightGainScreen> createState() => _WeightGainScreenState();
}

class _WeightGainScreenState extends State<WeightGainScreen> {
  final _age = TextEditingController();
  final _wt = TextEditingController();
  final _tw = TextEditingController();
  final _ft = TextEditingController();
  final _inch = TextEditingController();
  final _cm = TextEditingController();
  final _mon = TextEditingController();
  final _resKey = GlobalKey();

  String _gender = 'M';
  bool _isFt = true;
  bool _ratePlan = true;
  double _act = 1.375;
  double _rate = 500;
  WgResult? _res;

  @override
  void dispose() {
    for (final c in [_age, _wt, _tw, _ft, _inch, _cm, _mon]) {
      c.dispose();
    }
    super.dispose();
  }

  void _switchUnit(bool toFt) {
    if (toFt == _isFt) return;
    setState(() {
      if (toFt) {
        final cm = heightCmFromCm(_cm.text);
        if (cm > 0) {
          final p = ftInFromCm(cm);
          _ft.text = p[0];
          _inch.text = p[1];
        }
      } else {
        final cm = heightCmFromFtIn(_ft.text, _inch.text);
        if (cm > 0) _cm.text = rs(cm);
      }
      _isFt = toFt;
    });
  }

  void _calc() {
    FocusScope.of(context).unfocus();
    final input = WgInput(
      gender: _gender,
      age: numOf(_age.text),
      weight: numOf(_wt.text),
      target: numOf(_tw.text),
      isFt: _isFt,
      ft: int.tryParse(_ft.text.trim()) ?? 0,
      inch: numOf(_inch.text),
      cmIn: numOf(_cm.text),
      activity: _act,
      isRatePlan: _ratePlan,
      rate: _rate,
      months: numOf(_mon.text),
    );
    setState(() => _res = computeWeightGain(input));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = _resKey.currentContext;
      if (c != null && (_res?.ok ?? false)) {
        Scrollable.ensureVisible(c, duration: const Duration(milliseconds: 300));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pal = AppColors.blue(context);
    final res = _res;
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      bottomNavigationBar: const AppNav(current: 1),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 24),
          children: [
            BackRow(label: 'Calculators', color: pal.a),
            const Heading('Weight Gain Calculator',
                sub: 'Get your daily calories and timeline based on your body.'),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gender',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Seg(
                    items: const ['Male', 'Female'],
                    index: _gender == 'M' ? 0 : 1,
                    onChanged: (i) => setState(() => _gender = i == 0 ? 'M' : 'F'),
                    pal: pal,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Lbl('Age (years)'),
                            NumBox(controller: _age, hint: '25', decimal: false),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Lbl('Weight (kg)'),
                            NumBox(controller: _wt, hint: '55'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  HeightInput(
                    isFt: _isFt,
                    ft: _ft,
                    inch: _inch,
                    cm: _cm,
                    onUnit: _switchUnit,
                    pal: pal,
                  ),
                  const Lbl('Target Weight (kg)'),
                  NumBox(controller: _tw, hint: '65'),
                  const Lbl('Weight Gain Plan'),
                  Seg(
                    items: const ['Weekly rate', 'Months'],
                    index: _ratePlan ? 0 : 1,
                    onChanged: (i) => setState(() => _ratePlan = i == 0),
                    pal: pal,
                  ),
                  if (_ratePlan) ...[
                    const Lbl('Weight Gain per Week'),
                    DropBox<double>(
                      value: _rate,
                      items: const [
                        MapEntry('250 g / week (slow)', 250.0),
                        MapEntry('500 g / week (recommended)', 500.0),
                        MapEntry('750 g / week (fast)', 750.0),
                      ],
                      onChanged: (v) => setState(() => _rate = v),
                    ),
                  ] else ...[
                    const Lbl('In how many months do you want to reach your target?'),
                    NumBox(controller: _mon, hint: 'Months (6)'),
                  ],
                  const Lbl('Activity'),
                  DropBox<double>(
                    value: _act,
                    items: const [
                      MapEntry('Sedentary (little or no exercise)', 1.2),
                      MapEntry('Light (1\u20133 days/week)', 1.375),
                      MapEntry('Moderate (3\u20135 days/week)', 1.55),
                      MapEntry('Very active (6\u20137 days/week)', 1.725),
                    ],
                    onChanged: (v) => setState(() => _act = v),
                  ),
                  GoButton(text: 'Calculate', onTap: _calc, pal: pal),
                  if (res != null && !res.ok) NoteBox(res.error!),
                ],
              ),
            ),
            if (res == null || !res.ok)
              AppCard(
                color: pal.soft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your result will appear here',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: AppColors.text(context))),
                    const SizedBox(height: 4),
                    Text(
                      'Fill in your details and tap Calculate. You will see your daily calories, time to target, BMI and protein here.',
                      style: TextStyle(fontSize: 13, color: AppColors.muted(context)),
                    ),
                  ],
                ),
              )
            else
              _results(context, res, pal),
          ],
        ),
      ),
    );
  }

  Widget _results(BuildContext context, WgResult res, Pal pal) {
    final muted = AppColors.muted(context);
    final text = AppColors.text(context);
    return AppCard(
      key: _resKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBox(label: 'Daily calories to eat', big: res.calText, pal: pal),
          const SizedBox(height: 14),
          StatGrid(
            soft: pal.soft,
            items: [
              StatItem(res.tdeeText, 'Maintenance (TDEE)'),
              StatItem(res.surText, 'Extra per day'),
              StatItem(res.gainText, 'Total to gain'),
              StatItem(res.timeText, 'Estimated time'),
              StatItem(res.bmiText, 'BMI now'),
              StatItem(res.tbmiText, 'BMI at target'),
              StatItem(res.proText, 'Protein / day'),
              StatItem(res.dateText2, 'Target date'),
            ],
          ),
          const SectLabel('How many months each calorie level will take'),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.2),
            },
            children: [
              TableRow(
                children: [
                  for (final h in const ['Daily calories', 'Gain / week', 'Time to target'])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(h,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w800, color: muted)),
                    ),
                ],
              ),
              for (final s in res.scenarios)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.caloriesText,
                              style: TextStyle(fontWeight: FontWeight.w800, color: text)),
                          Text(s.extraText, style: TextStyle(fontSize: 12, color: muted)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(s.gramsText, style: TextStyle(color: text)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(s.monthsText,
                          style: TextStyle(fontWeight: FontWeight.w800, color: text)),
                    ),
                  ],
                ),
            ],
          ),
          if (res.warnings.isNotEmpty) NoteBox(res.warnText),
          const Tiny(
              'Calculated with the Mifflin-St Jeor formula. 1 kg of weight gain \u2248 7,700 kcal. These are estimates only and not medical advice. If you have a health condition, please consult a doctor or dietitian.'),
        ],
      ),
    );
  }
}
