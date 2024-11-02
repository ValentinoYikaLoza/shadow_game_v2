import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/custom_button.dart';

class SkillsDialog extends ConsumerWidget {
  const SkillsDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Dialog(
        child: Stack(
      children: [
        Image.asset('assets/images/shared/skillBackground.png'),
        Positioned(
          top: 20,
          left: 25,
          child: Row(
            children: [
              CustomButton(
                imagePath:
                    'assets/images/shared/damage/damageLevelOneButton.png',
                scale: 0.8,
                onPressed: () {
                  context.pop();
                },
              ),
              const SizedBox(width: 10),
              CustomButton(
                imagePath:
                    'assets/images/shared/endurance/enduranceLevelOneButton.png',
                scale: 0.8,
                onPressed: () {
                  context.pop();
                },
              ),
              const SizedBox(width: 10),
              CustomButton(
                imagePath:
                    'assets/images/shared/life/lifeLevelOneButton.png',
                scale: 0.8,
                onPressed: () {
                  context.pop();
                },
              ),
              const SizedBox(width: 10),
              CustomButton(
                imagePath:
                    'assets/images/shared/speed/speedLevelOneButton.png',
                scale: 0.8,
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}
