import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE HEADING
//
// The title and description over a form — Figma "Heading" on Login
// (364:15101), Create Profile (366:15349) and Create Account: the title in
// headline/large with the description right under it in body/large, both
// centred in Texts/Heading.
// ─────────────────────────────────────────────────────────────────────────────
class PageHeading extends StatelessWidget {
  const PageHeading({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, textAlign: TextAlign.center, style: textTheme.headlineLarge),
        Text(description, textAlign: TextAlign.center, style: textTheme.bodyLarge),
      ],
    );
  }
}
