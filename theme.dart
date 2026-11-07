import 'package:flutter/material.dart';

/// A section colour set: main, darker shade, soft background.
class Pal {
  final Color a;
  final Color b;
  final Color soft;
  const Pal(this.a, this.b, this.soft);
}

class AppColors {
  static bool isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  static Color bg(BuildContext c) =>
      isDark(c) ? const Color(0xFF0E1411) : const Color(0xFFF3F6F3);
  static Color card(BuildContext c) =>
      isDark(c) ? const Color(0xFF17211C) : const Color(0xFFFFFFFF);
  static Color text(BuildContext c) =>
      isDark(c) ? const Color(0xFFE8EFE9) : const Color(0xFF14231C);
  static Color muted(BuildContext c) =>
      isDark(c) ? const Color(0xFF9FB0A6) : const Color(0xFF5F6F66);
  static Color field(BuildContext c) =>
      isDark(c) ? const Color(0xFF202C26) : const Color(0xFFEEF2EE);
  static Color noteBg(BuildContext c) =>
      isDark(c) ? const Color(0xFF3A3217) : const Color(0xFFFFF4D6);
  static Color noteText(BuildContext c) =>
      isDark(c) ? const Color(0xFFF0D98A) : const Color(0xFF6B4E00);
  static Color onAccent(BuildContext c) =>
      isDark(c) ? const Color(0xFF0B1510) : const Color(0xFFFFFFFF);

  static List<BoxShadow> shadow(BuildContext c) => isDark(c)
      ? const <BoxShadow>[]
      : const <BoxShadow>[
          BoxShadow(color: Color(0x1410281C), blurRadius: 24, offset: Offset(0, 10)),
          BoxShadow(color: Color(0x0A10281C), blurRadius: 4, offset: Offset(0, 2)),
        ];

  static Pal green(BuildContext c) => isDark(c)
      ? const Pal(Color(0xFF4CC58A), Color(0xFF36A874), Color(0xFF1C2E26))
      : const Pal(Color(0xFF0F7A4F), Color(0xFF0A5D3C), Color(0xFFE1F4EA));
  static Pal blue(BuildContext c) => isDark(c)
      ? const Pal(Color(0xFF6AA5FF), Color(0xFF4A8AE8), Color(0xFF1B2638))
      : const Pal(Color(0xFF1769D6), Color(0xFF114FA8), Color(0xFFE5EEFC));
  static Pal orange(BuildContext c) => isDark(c)
      ? const Pal(Color(0xFFFF9A4D), Color(0xFFF0821F), Color(0xFF33261A))
      : const Pal(Color(0xFFEC6F0A), Color(0xFFC75A05), Color(0xFFFFF0E0));
  static Pal purple(BuildContext c) => isDark(c)
      ? const Pal(Color(0xFFA28DF0), Color(0xFF876FE0), Color(0xFF251F3A))
      : const Pal(Color(0xFF6A45D1), Color(0xFF5333B0), Color(0xFFECE7FB));
  static Pal pink(BuildContext c) => isDark(c)
      ? const Pal(Color(0xFFF06AAE), Color(0xFFDC4D93), Color(0xFF37202C))
      : const Pal(Color(0xFFD6247F), Color(0xFFA8185F), Color(0xFFFDE6F1));

  /// Colour of the bottom-nav tab at [i].
  static Color navColor(BuildContext c, int i) {
    switch (i) {
      case 0:
        return green(c).a;
      case 1:
        return blue(c).a;
      case 2:
        return orange(c).a;
      case 3:
        return purple(c).a;
      default:
        return pink(c).a;
    }
  }

  // Icon tile gradients (always the same, white icon on top).
  static const List<Color> icGreen = [Color(0xFF34C27F), Color(0xFF1A8F58)];
  static const List<Color> icBlue = [Color(0xFF4A8EF0), Color(0xFF1255C0)];
  static const List<Color> icOrange = [Color(0xFFFF9A3D), Color(0xFFE0600A)];
  static const List<Color> icPurple = [Color(0xFF8C6DF0), Color(0xFF5334B8)];
  static const List<Color> icPink = [Color(0xFFF04E9C), Color(0xFFC01C70)];
  static const List<Color> icTeal = [Color(0xFF25B8C4), Color(0xFF0B8795)];
  static const List<Color> icRed = [Color(0xFFFF6B70), Color(0xFFD63A40)];
}

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  return ThemeData(
    useMaterial3: true,
    brightness: b,
    colorSchemeSeed: const Color(0xFF0F7A4F),
    scaffoldBackgroundColor: dark ? const Color(0xFF0E1411) : const Color(0xFFF3F6F3),
    splashFactory: InkRipple.splashFactory,
  );
}
