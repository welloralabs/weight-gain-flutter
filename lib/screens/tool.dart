import 'package:flutter/material.dart';

import '../logic/calc.dart';
import '../logic/format.dart';
import '../theme.dart';
import '../widgets.dart';

class ToolScreen extends StatefulWidget {
  final ToolKind kind;
  const ToolScreen({super.key, required this.kind});

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  final _age = TextEditingController();
  final _wt = TextEditingController();
  final _tw = TextEditingController();
  final _ft = TextEditingController();
  final _inch = TextEditingController();
  final _cm = TextEditingController();
  final _resKey = GlobalKey();

  String _gender = 'M';
  bool _isFt = true;
  double _act = 1.375;
  double _rate = 500;
  String _goal = 'g';
  ToolResult? _res;

  @override
  void dispose() {
    for (final c in [_age, _wt, _tw, _ft, _inch, _cm]) {
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
    final k = widget.kind;
    final cm = k.has('h')
        ? (_isFt ? heightCmFromFtIn(_ft.text, _inch.text) : heightCmFromCm(_cm.text))
        : 0.0;
    setState(() {
      _res = runTool(
        k,
        gender: _gender,
        age: numOf(_age.text),
        weight: numOf(_wt.text),
        cm: cm,
        isFt: _isFt,
        activity: _act,
        target: numOf(_tw.text),
        rate: _rate,
        goal: _goal,
      );
    });
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
    final k = widget.kind;
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
            Heading(k.title, sub: k.subtitle),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (k.has('g')) ...[
                    const Text('Gender',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Seg(
                      items: const ['Male', 'Female'],
                      index: _gender == 'M' ? 0 : 1,
                      onChanged: (i) => setState(() => _gender = i == 0 ? 'M' : 'F'),
                      pal: pal,
                    ),
                  ],
                  if (k.has('a')) ...[
                    const Lbl('Age (years)'),
                    NumBox(controller: _age, hint: '25', decimal: false),
                  ],
                  if (k.has('w')) ...[
                    const Lbl('Weight (kg)'),
                    NumBox(controller: _wt, hint: '55'),
                  ],
                  if (k.has('h'))
                    HeightInput(
                      isFt: _isFt,
                      ft: _ft,
                      inch: _inch,
                      cm: _cm,
                      onUnit: _switchUnit,
                      pal: pal,
                    ),
                  if (k.has('c')) ...[
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
                  ],
                  if (k.has('t')) ...[
                    const Lbl('Target Weight (kg)'),
                    NumBox(controller: _tw, hint: '50'),
                  ],
                  if (k.has('l')) ...[
                    const Lbl('Weight Loss per Week'),
                    DropBox<double>(
                      value: _rate,
                      items: const [
                        MapEntry('250 g / week (slow)', 250.0),
                        MapEntry('500 g / week (recommended)', 500.0),
                        MapEntry('750 g / week (fast)', 750.0),
                      ],
                      onChanged: (v) => setState(() => _rate = v),
                    ),
                  ],
                  if (k.has('r')) ...[
                    const Lbl('Your goal'),
                    DropBox<String>(
                      value: _goal,
                      items: const [
                        MapEntry('Stay healthy', 'm'),
                        MapEntry('Build muscle / gain weight', 'g'),
                        MapEntry('Lose weight', 'l'),
                      ],
                      onChanged: (v) => setState(() => _goal = v),
                    ),
                  ],
                  GoButton(text: 'Calculate', onTap: _calc, pal: pal),
                  if (res != null && !res.ok) NoteBox(res.error!),
                ],
              ),
            ),
            if (res != null && res.ok)
              AppCard(
                key: _resKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroBox(label: res.heroLabel, big: res.heroBig, pal: pal),
                    const SizedBox(height: 14),
                    StatGrid(items: res.stats, soft: pal.soft),
                    for (final n in res.notes) NoteBox(n),
                    const Tiny(
                        'These are estimates only and not medical advice. If you have a health condition, please consult a doctor or dietitian.'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
