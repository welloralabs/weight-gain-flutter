import 'format.dart';

class StatItem {
  final String value;
  final String label;
  const StatItem(this.value, this.label);
}

// ---------------------------------------------------------------------------
// Weight Gain Calculator (same formulas as the web app)
// ---------------------------------------------------------------------------

class WgInput {
  final String gender; // 'M' or 'F'
  final double age;
  final double weight;
  final double target;
  final bool isFt;
  final int ft;
  final double inch;
  final double cmIn;
  final double activity;
  final bool isRatePlan;
  final double rate; // g per week (rate plan)
  final double months; // months plan

  const WgInput({
    required this.gender,
    required this.age,
    required this.weight,
    required this.target,
    required this.isFt,
    required this.ft,
    required this.inch,
    required this.cmIn,
    required this.activity,
    required this.isRatePlan,
    required this.rate,
    required this.months,
  });
}

class WgScenario {
  final double calories;
  final int extra;
  final double gramsPerWeek;
  final double months;
  const WgScenario(this.calories, this.extra, this.gramsPerWeek, this.months);

  String get caloriesText => '${fmt(calories)} kcal';
  String get extraText => '+$extra extra';
  String get gramsText => '${fmt(gramsPerWeek)} g';
  String get monthsText => '${months.toStringAsFixed(1)} months';
}

class WgResult {
  final String? error;
  final double cm;
  final double bmr;
  final double tdee;
  final double surplus;
  final double calories;
  final double kg;
  final double rate;
  final double weeks;
  final double months;
  final double bmi;
  final double targetBmi;
  final int proLo;
  final int proHi;
  final DateTime? targetDate;
  final List<WgScenario> scenarios;
  final List<String> warnings;

  const WgResult({
    this.error,
    this.cm = 0,
    this.bmr = 0,
    this.tdee = 0,
    this.surplus = 0,
    this.calories = 0,
    this.kg = 0,
    this.rate = 0,
    this.weeks = 0,
    this.months = 0,
    this.bmi = 0,
    this.targetBmi = 0,
    this.proLo = 0,
    this.proHi = 0,
    this.targetDate,
    this.scenarios = const [],
    this.warnings = const [],
  });

  bool get ok => error == null;

  String get calText => '${fmt(calories)} kcal';
  String get tdeeText => '${fmt(tdee)} kcal';
  String get surText => '+${fmt(surplus)} kcal';
  String get gainText => '${kg.toStringAsFixed(1)} kg (${fmt(rate)} g/week)';
  String get timeText => '${weeks.ceil()} weeks (~${months.toStringAsFixed(1)} mo)';
  String get bmiText => bmi.toStringAsFixed(1);
  String get tbmiText => targetBmi.toStringAsFixed(1);
  String get proText => '$proLo\u2013$proHi g';
  String get dateText2 => targetDate == null ? '-' : dateText(targetDate!);
  String get warnText => warnings.join(' ');
}

WgResult computeWeightGain(WgInput i, {DateTime? now}) {
  final isMon = !i.isRatePlan;
  final missing = i.age == 0 ||
      i.weight == 0 ||
      i.target == 0 ||
      (i.isFt ? i.ft == 0 : i.cmIn == 0) ||
      (isMon && i.months == 0);
  if (missing) {
    return WgResult(
        error:
            'Please fill in all fields (age, weight, height, target weight${isMon ? ', months' : ''}).');
  }
  if (i.target <= i.weight) {
    return const WgResult(error: 'Target weight must be higher than your current weight.');
  }
  String bad = '';
  if (i.age < 10 || i.age > 100) {
    bad = 'Enter an age between 10 and 100.';
  } else if (i.weight < 20 || i.weight > 300) {
    bad = 'Enter a weight between 20 and 300 kg.';
  } else if (i.target < 20 || i.target > 300 || i.target - i.weight > 60) {
    bad =
        'Enter a valid target weight (20 to 300 kg, and not more than 60 kg above your current weight).';
  } else if (i.isFt && (i.ft < 3 || i.ft > 8 || i.inch < 0 || i.inch >= 12)) {
    bad = 'Enter a height of 3 to 8 feet and 0 to 11 inches (for example 5.7).';
  } else if (!i.isFt && (i.cmIn < 100 || i.cmIn > 250)) {
    bad = 'Enter a height between 100 and 250 cm.';
  } else if (isMon && (i.months < 0.5 || i.months > 60)) {
    bad = 'Enter months between 0.5 and 60.';
  }
  if (bad.isNotEmpty) return WgResult(error: bad);

  final w = i.weight;
  final tw = i.target;
  final cm = i.isFt ? (i.ft * 12 + i.inch) * 2.54 : i.cmIn;
  final m = cm / 100;
  final kg = tw - w;
  var rate = i.rate;
  if (isMon) rate = kg * 1000 / (i.months * 4.345);
  final bmr = 10 * w + 6.25 * cm - 5 * i.age + (i.gender == 'M' ? 5 : -161);
  final tdee = bmr * i.activity;
  final sur = rate * 7.7 / 7;
  final cal = tdee + sur;
  final weeks = kg / (rate / 1000);
  final months = weeks / 4.345;
  final bmi = w / (m * m);
  final tbmi = tw / (m * m);
  final n = now ?? DateTime.now();
  final date = DateTime(n.year, n.month, n.day + (weeks * 7).round());

  const extras = [250, 350, 500, 650, 800];
  final scenarios = <WgScenario>[];
  for (final ex in extras) {
    final c = tdee + ex;
    final g = ex * 7 / 7.7;
    final mm = kg * 1000 / g / 4.345;
    scenarios.add(WgScenario(c, ex, g, mm));
  }

  final msgs = <String>[];
  if (tbmi > 24.9) {
    msgs.add(
        'Target BMI ${tbmi.toStringAsFixed(1)} is above the healthy range (18.5\u201324.9). Consider a slightly lower target.');
  }
  if (bmi >= 25) {
    msgs.add(
        'Your current BMI is already 25 or higher. Please consult a doctor instead of aiming to gain weight.');
  }
  if (rate > 1000) {
    msgs.add(
        'This plan needs a gain of about ${fmt(rate)} g/week, which is much faster than the healthy limit (about 500\u2013750 g/week). Try increasing the number of months.');
  } else if (rate >= 750) {
    msgs.add('750 g/week is fast and may add more fat. Include strength training.');
  }
  if (i.age < 18) {
    msgs.add('If you are under 18, do not follow a calorie plan without a doctor\u2019s advice.');
  }

  return WgResult(
    cm: cm,
    bmr: bmr,
    tdee: tdee,
    surplus: sur,
    calories: cal,
    kg: kg,
    rate: rate,
    weeks: weeks,
    months: months,
    bmi: bmi,
    targetBmi: tbmi,
    proLo: (w * 1.6).round(),
    proHi: (w * 2).round(),
    targetDate: date,
    scenarios: scenarios,
    warnings: msgs,
  );
}

// ---------------------------------------------------------------------------
// Other calculators: BMR, BMI, Protein, Weight Loss, Ideal Weight
// ---------------------------------------------------------------------------

enum ToolKind { bmr, bmi, protein, loss, ideal }

extension ToolKindInfo on ToolKind {
  String get title {
    switch (this) {
      case ToolKind.bmr:
        return 'Calorie & BMR Calculator';
      case ToolKind.bmi:
        return 'BMI Calculator';
      case ToolKind.protein:
        return 'Protein Calculator';
      case ToolKind.loss:
        return 'Weight Loss Calculator';
      case ToolKind.ideal:
        return 'Ideal Weight Calculator';
    }
  }

  String get subtitle {
    switch (this) {
      case ToolKind.bmr:
        return 'Know your daily calorie needs and BMR.';
      case ToolKind.bmi:
        return 'Check your BMI and health range.';
      case ToolKind.protein:
        return 'Find your daily protein needs.';
      case ToolKind.loss:
        return 'Set your weight loss goal.';
      case ToolKind.ideal:
        return 'Know your ideal body weight.';
    }
  }

  /// Which input fields this calculator shows: g a w h c t l r
  String get fields {
    switch (this) {
      case ToolKind.bmr:
        return 'g a w h c';
      case ToolKind.bmi:
        return 'w h';
      case ToolKind.protein:
        return 'w r';
      case ToolKind.loss:
        return 'g a w h c t l';
      case ToolKind.ideal:
        return 'g h';
    }
  }

  bool has(String f) => (' $fields ').contains(' $f ');
}

class ToolResult {
  final String? error;
  final String heroLabel;
  final String heroBig;
  final List<StatItem> stats;
  final List<String> notes;
  const ToolResult({
    this.error,
    this.heroLabel = '',
    this.heroBig = '',
    this.stats = const [],
    this.notes = const [],
  });
  bool get ok => error == null;
}

/// [cm] must already be validated/parsed (0 means missing or invalid).
ToolResult runTool(
  ToolKind k, {
  String gender = 'M',
  double age = 0,
  double weight = 0,
  double cm = 0,
  bool isFt = true,
  double activity = 1.375,
  double target = 0,
  double rate = 500,
  String goal = 'g',
  DateTime? now,
}) {
  String msg = '';
  if (k.has('h') && cm == 0) {
    msg = isFt
        ? 'Enter a height of 3 to 8 feet and 0 to 11 inches (for example 5.7).'
        : 'Enter a height between 100 and 250 cm.';
  }
  if (msg.isEmpty && k.has('a') && (age < 10 || age > 100)) {
    msg = 'Enter an age between 10 and 100.';
  }
  if (msg.isEmpty && k.has('w') && (weight < 20 || weight > 300)) {
    msg = 'Enter a weight between 20 and 300 kg.';
  }
  if (msg.isEmpty && k.has('t') && (target < 20 || target > 300)) {
    msg = 'Enter a target weight between 20 and 300 kg.';
  }
  if (msg.isEmpty && k.has('t') && target >= weight) {
    msg = 'Target weight must be lower than your current weight.';
  }
  if (msg.isEmpty && k.has('t') && weight - target > 60) {
    msg = 'Target weight cannot be more than 60 kg below your current weight.';
  }
  if (msg.isNotEmpty) return ToolResult(error: msg);

  final m = cm / 100;
  final w = weight;
  double bmr = 0;
  double td = 0;
  if (k.has('a')) {
    bmr = 10 * w + 6.25 * cm - 5 * age + (gender == 'M' ? 5 : -161);
    td = bmr * activity;
  }
  final bmi = m > 0 ? w / (m * m) : 0.0;
  final stats = <StatItem>[];
  final notes = <String>[];
  String hl = '';
  String big = '';

  switch (k) {
    case ToolKind.bmr:
      hl = 'Daily calories to maintain weight';
      big = '${fmt(td)} kcal';
      stats.add(StatItem('${fmt(bmr)} kcal', 'BMR (at rest)'));
      stats.add(StatItem('${fmt(td - 550)} kcal', 'To lose ~0.5 kg/week'));
      stats.add(StatItem('${fmt(td + 550)} kcal', 'To gain ~0.5 kg/week'));
      stats.add(StatItem(bmi.toStringAsFixed(1), 'BMI now'));
      if (age < 18) {
        notes.add('If you are under 18, do not follow a calorie plan without a doctor\u2019s advice.');
      }
      break;
    case ToolKind.bmi:
      final cat = bmi < 18.5
          ? 'Underweight'
          : (bmi < 25 ? 'Normal' : (bmi < 30 ? 'Overweight' : 'Obese'));
      hl = 'Your BMI';
      big = '${bmi.toStringAsFixed(1)} \u00b7 $cat';
      stats.add(StatItem('${rs(18.5 * m * m)}\u2013${rs(24.9 * m * m)} kg', 'Healthy weight range'));
      stats.add(StatItem(cat, 'Category (adults)'));
      if (bmi < 18.5 || bmi >= 25) {
        notes.add(
            'Your BMI is outside the healthy range (18.5\u201324.9). Please talk to a doctor or dietitian about a safe plan.');
      }
      notes.add('BMI is meant for adults. It can be misleading for athletes, children and teens.');
      break;
    case ToolKind.protein:
      double lo = 0.8;
      double hi = 1.0;
      if (goal == 'g') {
        lo = 1.6;
        hi = 2.0;
      } else if (goal == 'l') {
        lo = 1.2;
        hi = 1.6;
      }
      final pLo = (w * lo).round();
      final pHi = (w * hi).round();
      hl = 'Protein per day';
      big = '$pLo\u2013$pHi g';
      stats.add(StatItem('${jsNum(lo)}\u2013${jsNum(hi)} g/kg', 'Per kg body weight'));
      stats.add(StatItem('~${((pLo + pHi) / 8).round()} g', 'Per meal (4 meals)'));
      notes.add(
          'If you have kidney problems or any medical condition, ask a doctor before changing your protein intake.');
      break;
    case ToolKind.loss:
      final kg = w - target;
      final def = rate * 7.7 / 7;
      final cal = td - def;
      final wk = kg / (rate / 1000);
      final fl = gender == 'M' ? 1500 : 1200;
      final n = now ?? DateTime.now();
      final d = DateTime(n.year, n.month, n.day + (wk * 7).round());
      final tb = target / (m * m);
      hl = 'Daily calories to eat';
      big = '${fmt(cal)} kcal';
      stats.add(StatItem('${fmt(td)} kcal', 'Maintenance (TDEE)'));
      stats.add(StatItem('\u2212${fmt(def)} kcal', 'Deficit per day'));
      stats.add(StatItem('${kg.toStringAsFixed(1)} kg', 'Total to lose'));
      stats.add(StatItem('${wk.ceil()} weeks (~${(wk / 4.345).toStringAsFixed(1)} mo)', 'Estimated time'));
      stats.add(StatItem(dateText(d), 'Target date'));
      stats.add(StatItem(tb.toStringAsFixed(1), 'BMI at target'));
      if (cal < fl) {
        notes.add(
            'This is below ${fmt(fl)} kcal a day, which is too low to follow without a doctor. Choose a slower rate or consult a doctor or dietitian.');
      }
      if (tb < 18.5) {
        notes.add(
            'Target BMI ${tb.toStringAsFixed(1)} is below the healthy range (18.5\u201324.9). Consider a higher target.');
      }
      if (bmi < 18.5) {
        notes.add(
            'Your BMI is already below 18.5. Please consult a doctor instead of aiming to lose weight.');
      }
      if (age < 18) {
        notes.add('If you are under 18, do not follow a calorie plan without a doctor\u2019s advice.');
      }
      break;
    case ToolKind.ideal:
      final dv = (gender == 'M' ? 50 : 45.5) + 2.3 * (cm / 2.54 - 60);
      hl = 'Ideal body weight (Devine formula)';
      big = '${rs(dv)} kg';
      stats.add(StatItem('${rs(18.5 * m * m)}\u2013${rs(24.9 * m * m)} kg', 'Healthy range (BMI 18.5\u201324.9)'));
      stats.add(StatItem(hText(cm), 'Your height'));
      if (cm < 152) {
        notes.add(
            'The Devine formula is made for adults of average height. Use the healthy range as a better guide.');
      }
      break;
  }
  return ToolResult(heroLabel: hl, heroBig: big, stats: stats, notes: notes);
}
