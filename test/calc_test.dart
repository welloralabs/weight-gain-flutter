// Golden tests: every expected value below was produced by running the
// ORIGINAL web app's calculators in a browser. If a number here fails,
// the Dart port does not match the web app.
import 'package:flutter_test/flutter_test.dart';
import 'package:wgcalc_hp_2610/logic/calc.dart';
import 'package:wgcalc_hp_2610/logic/format.dart';

WgInput wgIn(String g, String age, String w, String hu, String hv, String tw,
    String pl, String pv, String act) {
  var ft = 0;
  var inch = 0.0;
  var cm = 0.0;
  if (hu == 'ft') {
    final parts = hv.split('.');
    ft = int.tryParse(parts[0]) ?? 0;
    inch = (parts.length > 1 && parts[1].isNotEmpty) ? numOf(parts[1]) : 0.0;
  } else {
    cm = numOf(hv);
  }
  final isRate = pl == 'rate';
  return WgInput(
    gender: g,
    age: numOf(age),
    weight: numOf(w),
    target: numOf(tw),
    isFt: hu == 'ft',
    ft: ft,
    inch: inch,
    cmIn: cm,
    activity: double.parse(act),
    isRatePlan: isRate,
    rate: isRate ? double.parse(pv) : 0,
    months: isRate ? 0 : numOf(pv),
  );
}

List<String> statsOf(ToolResult r) => [
      for (final s in r.stats)
        if (s.label != 'Target date') '${s.value}|${s.label}'
    ];

void main() {
  group('format helpers', () {
    test('fmt', () {
      expect(fmt(2604.2), '2,604');
      expect(fmt(999), '999');
      expect(fmt(1000), '1,000');
      expect(fmt(1234567), '1,234,567');
    });
    test('rs and hText', () {
      expect(rs(70), '70');
      expect(rs(66.14), '66.1');
      expect(hText(170.18), '170 cm (5 ft 7 in)');
    });
    test('height parsing', () {
      expect(heightCmFromFtIn('5', '7'), 170.2);
      expect(heightCmFromFtIn('9', '0'), 0);
      expect(heightCmFromFtIn('5', '12'), 0);
      expect(heightCmFromCm('170'), 170);
      expect(heightCmFromCm('90'), 0);
    });
  });

  group('Weight Gain calculator - results', () {
    test('case 1', () {
      final r = computeWeightGain(wgIn('M', '25', '55', 'ft', '5.7', '65', 'rate', '500', '1.375'), now: DateTime(2026, 11, 5));
      expect(r.error, isNull);
      expect(r.calText, '2,604 kcal');
      expect(r.tdeeText, '2,054 kcal');
      expect(r.surText, '+550 kcal');
      expect(r.gainText, '10.0 kg (500 g/week)');
      expect(r.timeText, '20 weeks (~4.6 mo)');
      expect(r.bmiText, '19.0');
      expect(r.tbmiText, '22.4');
      expect(r.proText, '88–110 g');
      expect(r.warnText, '');
      expect([for (final s in r.scenarios) '${s.caloriesText}|${s.extraText}|${s.gramsText}|${s.monthsText}'], ['2,304 kcal|+250 extra|227 g|10.1 months', '2,404 kcal|+350 extra|318 g|7.2 months', '2,554 kcal|+500 extra|455 g|5.1 months', '2,704 kcal|+650 extra|591 g|3.9 months', '2,854 kcal|+800 extra|727 g|3.2 months']);
    });
    test('case 2', () {
      final r = computeWeightGain(wgIn('F', '30', '48', 'ft', '5.2', '58', 'rate', '250', '1.2'), now: DateTime(2026, 11, 5));
      expect(r.error, isNull);
      expect(r.calText, '1,659 kcal');
      expect(r.tdeeText, '1,384 kcal');
      expect(r.surText, '+275 kcal');
      expect(r.gainText, '10.0 kg (250 g/week)');
      expect(r.timeText, '40 weeks (~9.2 mo)');
      expect(r.bmiText, '19.4');
      expect(r.tbmiText, '23.4');
      expect(r.proText, '77–96 g');
      expect(r.warnText, '');
      expect([for (final s in r.scenarios) '${s.caloriesText}|${s.extraText}|${s.gramsText}|${s.monthsText}'], ['1,634 kcal|+250 extra|227 g|10.1 months', '1,734 kcal|+350 extra|318 g|7.2 months', '1,884 kcal|+500 extra|455 g|5.1 months', '2,034 kcal|+650 extra|591 g|3.9 months', '2,184 kcal|+800 extra|727 g|3.2 months']);
    });
    test('case 3', () {
      final r = computeWeightGain(wgIn('M', '19', '60', 'cm', '175', '72', 'mon', '8', '1.55'), now: DateTime(2026, 11, 5));
      expect(r.error, isNull);
      expect(r.calText, '2,866 kcal');
      expect(r.tdeeText, '2,486 kcal');
      expect(r.surText, '+380 kcal');
      expect(r.gainText, '12.0 kg (345 g/week)');
      expect(r.timeText, '35 weeks (~8.0 mo)');
      expect(r.bmiText, '19.6');
      expect(r.tbmiText, '23.5');
      expect(r.proText, '96–120 g');
      expect(r.warnText, '');
      expect([for (final s in r.scenarios) '${s.caloriesText}|${s.extraText}|${s.gramsText}|${s.monthsText}'], ['2,736 kcal|+250 extra|227 g|12.2 months', '2,836 kcal|+350 extra|318 g|8.7 months', '2,986 kcal|+500 extra|455 g|6.1 months', '3,136 kcal|+650 extra|591 g|4.7 months', '3,286 kcal|+800 extra|727 g|3.8 months']);
    });
    test('case 4', () {
      final r = computeWeightGain(wgIn('M', '40', '70', 'ft', '5.10', '75', 'rate', '750', '1.725'), now: DateTime(2026, 11, 5));
      expect(r.error, isNull);
      expect(r.calText, '3,613 kcal');
      expect(r.tdeeText, '2,788 kcal');
      expect(r.surText, '+825 kcal');
      expect(r.gainText, '5.0 kg (750 g/week)');
      expect(r.timeText, '7 weeks (~1.5 mo)');
      expect(r.bmiText, '22.1');
      expect(r.tbmiText, '23.7');
      expect(r.proText, '112–140 g');
      expect(r.warnText, '750 g/week is fast and may add more fat. Include strength training.');
      expect([for (final s in r.scenarios) '${s.caloriesText}|${s.extraText}|${s.gramsText}|${s.monthsText}'], ['3,038 kcal|+250 extra|227 g|5.1 months', '3,138 kcal|+350 extra|318 g|3.6 months', '3,288 kcal|+500 extra|455 g|2.5 months', '3,438 kcal|+650 extra|591 g|1.9 months', '3,588 kcal|+800 extra|727 g|1.6 months']);
    });
    test('case 5', () {
      final r = computeWeightGain(wgIn('F', '16', '45', 'cm', '158', '50', 'rate', '500', '1.375'), now: DateTime(2026, 11, 5));
      expect(r.error, isNull);
      expect(r.calText, '2,195 kcal');
      expect(r.tdeeText, '1,645 kcal');
      expect(r.surText, '+550 kcal');
      expect(r.gainText, '5.0 kg (500 g/week)');
      expect(r.timeText, '10 weeks (~2.3 mo)');
      expect(r.bmiText, '18.0');
      expect(r.tbmiText, '20.0');
      expect(r.proText, '72–90 g');
      expect(r.warnText, 'If you are under 18, do not follow a calorie plan without a doctor’s advice.');
      expect([for (final s in r.scenarios) '${s.caloriesText}|${s.extraText}|${s.gramsText}|${s.monthsText}'], ['1,895 kcal|+250 extra|227 g|5.1 months', '1,995 kcal|+350 extra|318 g|3.6 months', '2,145 kcal|+500 extra|455 g|2.5 months', '2,295 kcal|+650 extra|591 g|1.9 months', '2,445 kcal|+800 extra|727 g|1.6 months']);
    });
    test('case 6', () {
      final r = computeWeightGain(wgIn('M', '25', '80', 'cm', '170', '95', 'mon', '3', '1.375'), now: DateTime(2026, 11, 5));
      expect(r.error, isNull);
      expect(r.calText, '3,662 kcal');
      expect(r.tdeeText, '2,396 kcal');
      expect(r.surText, '+1,266 kcal');
      expect(r.gainText, '15.0 kg (1,151 g/week)');
      expect(r.timeText, '14 weeks (~3.0 mo)');
      expect(r.bmiText, '27.7');
      expect(r.tbmiText, '32.9');
      expect(r.proText, '128–160 g');
      expect(r.warnText, 'Target BMI 32.9 is above the healthy range (18.5–24.9). Consider a slightly lower target. Your current BMI is already 25 or higher. Please consult a doctor instead of aiming to gain weight. This plan needs a gain of about 1,151 g/week, which is much faster than the healthy limit (about 500–750 g/week). Try increasing the number of months.');
      expect([for (final s in r.scenarios) '${s.caloriesText}|${s.extraText}|${s.gramsText}|${s.monthsText}'], ['2,646 kcal|+250 extra|227 g|15.2 months', '2,746 kcal|+350 extra|318 g|10.8 months', '2,896 kcal|+500 extra|455 g|7.6 months', '3,046 kcal|+650 extra|591 g|5.8 months', '3,196 kcal|+800 extra|727 g|4.7 months']);
    });
    test('case 7', () {
      final r = computeWeightGain(wgIn('F', '27', '52', 'ft', '5.4', '60', 'mon', '6.5', '1.55'), now: DateTime(2026, 11, 5));
      expect(r.error, isNull);
      expect(r.calText, '2,234 kcal');
      expect(r.tdeeText, '1,922 kcal');
      expect(r.surText, '+312 kcal');
      expect(r.gainText, '8.0 kg (283 g/week)');
      expect(r.timeText, '29 weeks (~6.5 mo)');
      expect(r.bmiText, '19.7');
      expect(r.tbmiText, '22.7');
      expect(r.proText, '83–104 g');
      expect(r.warnText, '');
      expect([for (final s in r.scenarios) '${s.caloriesText}|${s.extraText}|${s.gramsText}|${s.monthsText}'], ['2,172 kcal|+250 extra|227 g|8.1 months', '2,272 kcal|+350 extra|318 g|5.8 months', '2,422 kcal|+500 extra|455 g|4.1 months', '2,572 kcal|+650 extra|591 g|3.1 months', '2,722 kcal|+800 extra|727 g|2.5 months']);
    });
  });

  group('Weight Gain calculator - validation messages', () {
    test('error 1', () {
      final r = computeWeightGain(wgIn('M', '', '55', 'ft', '5.7', '65', 'rate', '500', '1.375'));
      expect(r.error, 'Please fill in all fields (age, weight, height, target weight).');
    });
    test('error 2', () {
      final r = computeWeightGain(wgIn('M', '25', '55', 'ft', '5.7', '50', 'rate', '500', '1.375'));
      expect(r.error, 'Target weight must be higher than your current weight.');
    });
    test('error 3', () {
      final r = computeWeightGain(wgIn('M', '5', '55', 'ft', '5.7', '65', 'rate', '500', '1.375'));
      expect(r.error, 'Enter an age between 10 and 100.');
    });
    test('error 4', () {
      final r = computeWeightGain(wgIn('M', '25', '10', 'ft', '5.7', '65', 'rate', '500', '1.375'));
      expect(r.error, 'Enter a weight between 20 and 300 kg.');
    });
    test('error 5', () {
      final r = computeWeightGain(wgIn('M', '25', '55', 'ft', '5.7', '130', 'rate', '500', '1.375'));
      expect(r.error, 'Enter a valid target weight (20 to 300 kg, and not more than 60 kg above your current weight).');
    });
    test('error 6', () {
      final r = computeWeightGain(wgIn('M', '25', '55', 'ft', '9.0', '65', 'rate', '500', '1.375'));
      expect(r.error, 'Enter a height of 3 to 8 feet and 0 to 11 inches (for example 5.7).');
    });
    test('error 7', () {
      final r = computeWeightGain(wgIn('M', '25', '55', 'cm', '90', '65', 'rate', '500', '1.375'));
      expect(r.error, 'Enter a height between 100 and 250 cm.');
    });
    test('error 8', () {
      final r = computeWeightGain(wgIn('M', '25', '55', 'cm', '170', '65', 'mon', '0.3', '1.375'));
      expect(r.error, 'Enter months between 0.5 and 60.');
    });
    test('error 9', () {
      final r = computeWeightGain(wgIn('M', '25', '55', 'cm', '170', '65', 'mon', '', '1.375'));
      expect(r.error, 'Please fill in all fields (age, weight, height, target weight, months).');
    });
  });

  group('Other calculators - results', () {
    test('bmr case 1', () {
      final r = runTool(ToolKind.bmr, gender: 'M', age: 25.0, weight: 60.0, cm: heightCmFromCm('170'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Daily calories to maintain weight');
      expect(r.heroBig, '2,121 kcal');
      expect(statsOf(r), ['1,543 kcal|BMR (at rest)', '1,571 kcal|To lose ~0.5 kg/week', '2,671 kcal|To gain ~0.5 kg/week', '20.8|BMI now']);
      expect(r.notes, []);
    });
    test('bmr case 2', () {
      final r = runTool(ToolKind.bmr, gender: 'F', age: 40.0, weight: 70.0, cm: heightCmFromCm('160'), isFt: false, activity: 1.2, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Daily calories to maintain weight');
      expect(r.heroBig, '1,607 kcal');
      expect(statsOf(r), ['1,339 kcal|BMR (at rest)', '1,057 kcal|To lose ~0.5 kg/week', '2,157 kcal|To gain ~0.5 kg/week', '27.3|BMI now']);
      expect(r.notes, []);
    });
    test('bmr case 3', () {
      final r = runTool(ToolKind.bmr, gender: 'M', age: 15.0, weight: 50.0, cm: heightCmFromCm('165'), isFt: false, activity: 1.55, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Daily calories to maintain weight');
      expect(r.heroBig, '2,265 kcal');
      expect(statsOf(r), ['1,461 kcal|BMR (at rest)', '1,715 kcal|To lose ~0.5 kg/week', '2,815 kcal|To gain ~0.5 kg/week', '18.4|BMI now']);
      expect(r.notes, ['If you are under 18, do not follow a calorie plan without a doctor’s advice.']);
    });
    test('bmi case 4', () {
      final r = runTool(ToolKind.bmi, gender: 'M', age: 0.0, weight: 60.0, cm: heightCmFromCm('170'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Your BMI');
      expect(r.heroBig, '20.8 · Normal');
      expect(statsOf(r), ['53.5–72 kg|Healthy weight range', 'Normal|Category (adults)']);
      expect(r.notes, ['BMI is meant for adults. It can be misleading for athletes, children and teens.']);
    });
    test('bmi case 5', () {
      final r = runTool(ToolKind.bmi, gender: 'M', age: 0.0, weight: 90.0, cm: heightCmFromCm('170'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Your BMI');
      expect(r.heroBig, '31.1 · Obese');
      expect(statsOf(r), ['53.5–72 kg|Healthy weight range', 'Obese|Category (adults)']);
      expect(r.notes, ['Your BMI is outside the healthy range (18.5–24.9). Please talk to a doctor or dietitian about a safe plan.', 'BMI is meant for adults. It can be misleading for athletes, children and teens.']);
    });
    test('bmi case 6', () {
      final r = runTool(ToolKind.bmi, gender: 'M', age: 0.0, weight: 45.0, cm: heightCmFromCm('170'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Your BMI');
      expect(r.heroBig, '15.6 · Underweight');
      expect(statsOf(r), ['53.5–72 kg|Healthy weight range', 'Underweight|Category (adults)']);
      expect(r.notes, ['Your BMI is outside the healthy range (18.5–24.9). Please talk to a doctor or dietitian about a safe plan.', 'BMI is meant for adults. It can be misleading for athletes, children and teens.']);
    });
    test('protein case 7', () {
      final r = runTool(ToolKind.protein, gender: 'M', age: 0.0, weight: 60.0, cm: 0, isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'm');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Protein per day');
      expect(r.heroBig, '48–60 g');
      expect(statsOf(r), ['0.8–1 g/kg|Per kg body weight', '~14 g|Per meal (4 meals)']);
      expect(r.notes, ['If you have kidney problems or any medical condition, ask a doctor before changing your protein intake.']);
    });
    test('protein case 8', () {
      final r = runTool(ToolKind.protein, gender: 'M', age: 0.0, weight: 60.0, cm: 0, isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Protein per day');
      expect(r.heroBig, '96–120 g');
      expect(statsOf(r), ['1.6–2 g/kg|Per kg body weight', '~27 g|Per meal (4 meals)']);
      expect(r.notes, ['If you have kidney problems or any medical condition, ask a doctor before changing your protein intake.']);
    });
    test('protein case 9', () {
      final r = runTool(ToolKind.protein, gender: 'M', age: 0.0, weight: 60.0, cm: 0, isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'l');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Protein per day');
      expect(r.heroBig, '72–96 g');
      expect(statsOf(r), ['1.2–1.6 g/kg|Per kg body weight', '~21 g|Per meal (4 meals)']);
      expect(r.notes, ['If you have kidney problems or any medical condition, ask a doctor before changing your protein intake.']);
    });
    test('loss case 10', () {
      final r = runTool(ToolKind.loss, gender: 'M', age: 25.0, weight: 80.0, cm: heightCmFromCm('175'), isFt: false, activity: 1.375, target: 70.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Daily calories to eat');
      expect(r.heroBig, '1,889 kcal');
      expect(statsOf(r), ['2,439 kcal|Maintenance (TDEE)', '−550 kcal|Deficit per day', '10.0 kg|Total to lose', '20 weeks (~4.6 mo)|Estimated time', '22.9|BMI at target']);
      expect(r.notes, []);
    });
    test('loss case 11', () {
      final r = runTool(ToolKind.loss, gender: 'F', age: 35.0, weight: 65.0, cm: heightCmFromCm('160'), isFt: false, activity: 1.2, target: 50.0, rate: 750.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Daily calories to eat');
      expect(r.heroBig, '752 kcal');
      expect(statsOf(r), ['1,577 kcal|Maintenance (TDEE)', '−825 kcal|Deficit per day', '15.0 kg|Total to lose', '20 weeks (~4.6 mo)|Estimated time', '19.5|BMI at target']);
      expect(r.notes, ['This is below 1,200 kcal a day, which is too low to follow without a doctor. Choose a slower rate or consult a doctor or dietitian.']);
    });
    test('loss case 12', () {
      final r = runTool(ToolKind.loss, gender: 'M', age: 17.0, weight: 50.0, cm: heightCmFromCm('170'), isFt: false, activity: 1.375, target: 45.0, rate: 250.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Daily calories to eat');
      expect(r.heroBig, '1,763 kcal');
      expect(statsOf(r), ['2,038 kcal|Maintenance (TDEE)', '−275 kcal|Deficit per day', '5.0 kg|Total to lose', '20 weeks (~4.6 mo)|Estimated time', '15.6|BMI at target']);
      expect(r.notes, ['Target BMI 15.6 is below the healthy range (18.5–24.9). Consider a higher target.', 'Your BMI is already below 18.5. Please consult a doctor instead of aiming to lose weight.', 'If you are under 18, do not follow a calorie plan without a doctor’s advice.']);
    });
    test('ideal case 13', () {
      final r = runTool(ToolKind.ideal, gender: 'M', age: 0.0, weight: 0.0, cm: heightCmFromCm('175'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Ideal body weight (Devine formula)');
      expect(r.heroBig, '70.5 kg');
      expect(statsOf(r), ['56.7–76.3 kg|Healthy range (BMI 18.5–24.9)', '175 cm (5 ft 9 in)|Your height']);
      expect(r.notes, []);
    });
    test('ideal case 14', () {
      final r = runTool(ToolKind.ideal, gender: 'F', age: 0.0, weight: 0.0, cm: heightCmFromCm('150'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, isNull);
      expect(r.heroLabel, 'Ideal body weight (Devine formula)');
      expect(r.heroBig, '43.3 kg');
      expect(statsOf(r), ['41.6–56 kg|Healthy range (BMI 18.5–24.9)', '150 cm (4 ft 11 in)|Your height']);
      expect(r.notes, ['The Devine formula is made for adults of average height. Use the healthy range as a better guide.']);
    });
  });

  group('Other calculators - validation messages', () {
    test('loss error 1', () {
      final r = runTool(ToolKind.loss, gender: 'M', age: 25.0, weight: 80.0, cm: heightCmFromCm('175'), isFt: false, activity: 1.375, target: 85.0, rate: 500.0, goal: 'g');
      expect(r.error, 'Target weight must be lower than your current weight.');
    });
    test('loss error 2', () {
      final r = runTool(ToolKind.loss, gender: 'M', age: 25.0, weight: 80.0, cm: heightCmFromCm('175'), isFt: false, activity: 1.375, target: 10.0, rate: 500.0, goal: 'g');
      expect(r.error, 'Enter a target weight between 20 and 300 kg.');
    });
    test('bmr error 3', () {
      final r = runTool(ToolKind.bmr, gender: 'M', age: 25.0, weight: 60.0, cm: heightCmFromCm('90'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, 'Enter a height between 100 and 250 cm.');
    });
    test('bmr error 4', () {
      final r = runTool(ToolKind.bmr, gender: 'M', age: 5.0, weight: 60.0, cm: heightCmFromCm('170'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, 'Enter an age between 10 and 100.');
    });
    test('bmi error 5', () {
      final r = runTool(ToolKind.bmi, gender: 'M', age: 0.0, weight: 10.0, cm: heightCmFromCm('170'), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, 'Enter a weight between 20 and 300 kg.');
    });
    test('ideal error 6', () {
      final r = runTool(ToolKind.ideal, gender: 'M', age: 0.0, weight: 0.0, cm: heightCmFromCm(''), isFt: false, activity: 1.375, target: 0.0, rate: 500.0, goal: 'g');
      expect(r.error, 'Enter a height between 100 and 250 cm.');
    });
  });
}
