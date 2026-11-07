const List<String> kMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

/// Parses a number the same way the web app does (comma allowed, empty = 0).
double numOf(String s) {
  final v = double.tryParse(s.trim().replaceAll(',', '.'));
  if (v == null || v.isNaN || v.isInfinite) return 0;
  return v;
}

/// 2604 -> "2,604" (rounded, thousands separators).
String fmt(num n) {
  final s = n.round().toString();
  final neg = s.startsWith('-');
  final digits = neg ? s.substring(1) : s;
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return (neg ? '-' : '') + buf.toString();
}

/// Rounds to one decimal.
double r1(num x) => (x * 10).round() / 10;

/// One decimal, but whole numbers print without ".0" (like JavaScript).
String rs(num x) {
  final v = r1(x);
  return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
}

/// Prints a number like JavaScript does (1.0 -> "1", 0.8 -> "0.8").
String jsNum(double x) => x == x.roundToDouble() ? x.toInt().toString() : x.toString();

String dateText(DateTime d) => '${d.day} ${kMonths[d.month - 1]} ${d.year}';

/// "170 cm (5 ft 7 in)"
String hText(double cm) {
  final inch = (cm / 2.54).round();
  final ft = inch ~/ 12;
  return '${cm.round()} cm ($ft ft ${inch - ft * 12} in)';
}

/// Feet + inch text -> cm (rounded to 1 decimal). Returns 0 when invalid.
double heightCmFromFtIn(String ftS, String inchS) {
  final ft = int.tryParse(ftS.trim()) ?? 0;
  final inch = numOf(inchS);
  if (ft < 3 || ft > 8 || inch < 0 || inch >= 12) return 0;
  return r1((ft * 12 + inch) * 2.54);
}

/// cm text -> cm (rounded to 1 decimal). Returns 0 when invalid.
double heightCmFromCm(String s) {
  final n = numOf(s);
  return (n < 100 || n > 250) ? 0 : r1(n);
}

/// cm -> ["5", "7"] (feet, inch) for the unit switch.
List<String> ftInFromCm(double cm) {
  final t = (cm / 2.54).round();
  final f = t ~/ 12;
  return [f.toString(), (t - f * 12).toString()];
}
