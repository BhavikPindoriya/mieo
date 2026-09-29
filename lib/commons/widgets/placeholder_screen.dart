import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/localization/lang_keys.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER SCREEN
//
// Stand-in page for a registered route whose real screen doesn't exist yet
// (see core/routes/routes.dart). Shows only the app name, centered, on the
// theme's default scaffold background.
// ─────────────────────────────────────────────────────────────────────────────
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(LangKeys.appName.tr, style: Theme.of(context).textTheme.headlineMedium)),
    );
  }
}
