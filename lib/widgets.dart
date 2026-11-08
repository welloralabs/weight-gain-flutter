import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'logic/calc.dart';
import 'theme.dart';

/// Tab navigation shared by the main shell and pushed screens.
class Nav {
  static final ValueNotifier<int> tab = ValueNotifier<int>(0);
  static void goTab(BuildContext context, int i) {
    tab.value = i;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }
}

class AppNav extends StatelessWidget {
  final int current;
  const AppNav({super.key, required this.current});

  static const List<String> labels = ['Home', 'Calculators', 'Nutrition', 'Workout', 'Profile'];
  static const List<IconData> icons = [
    Icons.home_rounded,
    Icons.calculate_rounded,
    Icons.restaurant_rounded,
    Icons.fitness_center_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.muted(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(color: Color(0x1F10281C), blurRadius: 28, offset: Offset(0, -8)),
        ],
      ),
      child: Material(
        color: AppColors.card(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                for (var i = 0; i < 5; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () => Nav.goTab(context, i),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: 3,
                            width: i == current ? 30 : 0,
                            decoration: BoxDecoration(
                              color: AppColors.navColor(context, i),
                              borderRadius:
                                  const BorderRadius.vertical(bottom: Radius.circular(3)),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Icon(icons[i],
                              size: 24,
                              color: i == current ? AppColors.navColor(context, i) : muted),
                          const SizedBox(height: 2),
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: i == current ? AppColors.navColor(context, i) : muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? color;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 14),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.shadow(context),
      ),
      child: Material(
        color: color ?? AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String title;
  final String? sub;
  const Heading(this.title, {super.key, this.sub});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text(context))),
          if (sub != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(sub!, style: TextStyle(fontSize: 14.5, color: AppColors.muted(context))),
            ),
        ],
      ),
    );
  }
}

class SectLabel extends StatelessWidget {
  final String text;
  const SectLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 10),
      child: Text(text.toUpperCase(),
          style: TextStyle(
              fontSize: 13,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w800,
              color: AppColors.muted(context))),
    );
  }
}

class Lbl extends StatelessWidget {
  final String text;
  const Lbl(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(text,
          style: TextStyle(
              fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.muted(context))),
    );
  }
}

class PillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool small;
  const PillButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.textColor,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: small ? 16 : 20, vertical: small ? 8 : 11),
          child: Text(text,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: small ? 14 : 15)),
        ),
      ),
    );
  }
}

class GoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Pal pal;
  const GoButton({super.key, required this.text, required this.onTap, required this.pal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [pal.a, pal.b]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 6)),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: SizedBox(
              height: 54,
              width: double.infinity,
              child: Center(
                child: Text(text,
                    style: TextStyle(
                        color: AppColors.onAccent(context),
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Seg extends StatelessWidget {
  final List<String> items;
  final int index;
  final ValueChanged<int> onChanged;
  final Pal pal;
  const Seg({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
    required this.pal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.field(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: i == index ? pal.a : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(items[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: i == index
                                ? AppColors.onAccent(context)
                                : AppColors.text(context))),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NumBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool decimal;
  const NumBox({super.key, required this.controller, required this.hint, this.decimal = true});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(decimal ? r'[0-9.,]' : r'[0-9]')),
      ],
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text(context)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.muted(context), fontWeight: FontWeight.w500),
        filled: true,
        fillColor: AppColors.field(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class DropBox<T> extends StatelessWidget {
  final T value;
  final List<MapEntry<String, T>> items;
  final ValueChanged<T> onChanged;
  const DropBox({super.key, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.field(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.card(context),
          style: TextStyle(
              fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.text(context)),
          items: [
            for (final e in items) DropdownMenuItem<T>(value: e.value, child: Text(e.key)),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class HeroBox extends StatelessWidget {
  final String label;
  final String big;
  final Pal pal;
  const HeroBox({super.key, required this.label, required this.big, required this.pal});

  @override
  Widget build(BuildContext context) {
    final on = AppColors.onAccent(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [pal.a, pal.b]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: on)),
          const SizedBox(height: 4),
          Text(big,
              style: TextStyle(fontSize: 32, height: 1.15, fontWeight: FontWeight.w800, color: on)),
        ],
      ),
    );
  }
}

class StatGrid extends StatelessWidget {
  final List<StatItem> items;
  final Color soft;
  const StatGrid({super.key, required this.items, required this.soft});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final w = (box.maxWidth - 10) / 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final s in items)
            Container(
              width: w,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: soft, borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.value,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text(context))),
                  const SizedBox(height: 2),
                  Text(s.label,
                      style: TextStyle(fontSize: 12, color: AppColors.muted(context))),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class NoteBox extends StatelessWidget {
  final String text;
  const NoteBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.noteBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: TextStyle(fontSize: 13.5, height: 1.4, color: AppColors.noteText(context))),
    );
  }
}

class Tiny extends StatelessWidget {
  final String text;
  const Tiny(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(text,
          style: TextStyle(fontSize: 12.5, height: 1.45, color: AppColors.muted(context))),
    );
  }
}

class IconTile extends StatelessWidget {
  final IconData icon;
  final List<Color> colors;
  const IconTile({super.key, required this.icon, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x29000000), blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

class ListCard extends StatelessWidget {
  final IconData icon;
  final List<Color> colors;
  final String title;
  final String sub;
  final VoidCallback onTap;
  const ListCard({
    super.key,
    required this.icon,
    required this.colors,
    required this.title,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
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
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconTile(icon: icon, colors: colors),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text(context))),
                        const SizedBox(height: 2),
                        Text(sub,
                            style: TextStyle(fontSize: 13, color: AppColors.muted(context))),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.muted(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Height input with Feet/Inch and cm modes (values convert when you switch).
class HeightInput extends StatelessWidget {
  final bool isFt;
  final TextEditingController ft;
  final TextEditingController inch;
  final TextEditingController cm;
  final ValueChanged<bool> onUnit;
  final Pal pal;
  const HeightInput({
    super.key,
    required this.isFt,
    required this.ft,
    required this.inch,
    required this.cm,
    required this.onUnit,
    required this.pal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Lbl('Height'),
        Seg(
          items: const ['Feet / Inch', 'cm'],
          index: isFt ? 0 : 1,
          onChanged: (i) => onUnit(i == 0),
          pal: pal,
        ),
        const SizedBox(height: 8),
        if (isFt)
          Row(
            children: [
              Expanded(child: NumBox(controller: ft, hint: 'Feet (5)', decimal: false)),
              const SizedBox(width: 10),
              Expanded(child: NumBox(controller: inch, hint: 'Inch (7)')),
            ],
          )
        else
          NumBox(controller: cm, hint: 'Height in cm (170)'),
      ],
    );
  }
}

class BackRow extends StatelessWidget {
  final String label;
  final Color color;
  const BackRow({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.of(context).maybePop(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 6, 12, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chevron_left_rounded, color: color, size: 24),
              Text(label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
