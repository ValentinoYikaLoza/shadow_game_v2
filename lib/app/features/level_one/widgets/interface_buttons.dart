import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/config/constants/app_colors.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/custom_button.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/skills_dialog.dart';

class InterfaceButtons extends ConsumerWidget {
  final Widget child;
  const InterfaceButtons({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, ref) {
    final screen = MediaQuery.of(context);
    final backgroundState = ref.watch(backgroundProvider);
    return Stack(
      children: [
        child,
        // coords
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            'x: ${backgroundState.initialPosition}',
            style: const TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                height: 21 / 18,
                decoration: TextDecoration.none),
          ),
        ),
        // skill button
        Positioned(
          bottom: 40,
          left: screen.size.width / 2 - 36.5,
          child: CustomButton(
            imagePath: 'assets/images/shared/skillButton.png',
            scale: 2,
            onPressed: () {
              SkillDialog.show();
            },
          ),
        ),
      ],
    );
  }
}
