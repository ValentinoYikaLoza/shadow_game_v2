import 'package:flutter/material.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/gestures.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/interface_buttons.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/loader.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/skills_dialog.dart';

class App extends StatelessWidget {
  const App({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return LoaderProvider(
      child: SkillProvider(
        child: InterfaceButtons(
          child: Gestures(
            child: child,
          ),
        ),
      ),
    );
  }
}
