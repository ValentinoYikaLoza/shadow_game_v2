import 'package:flutter_riverpod/flutter_riverpod.dart';

final skillProvider = StateNotifierProvider<SkillNotifier, SkillState>((ref) {
  return SkillNotifier(ref);
});

class SkillNotifier extends StateNotifier<SkillState> {
  SkillNotifier(this.ref) : super(SkillState());
  final Ref ref;

  void levelUPDamage() {
    if (state.currentLevelDamage >= 3) return;
    final newLevel = state.currentLevelDamage + 1;
    state = state.copyWith(
      currentLevelDamage: newLevel,
      currentDamageImage: _getSkillGif('damage', newLevel),
    );
  }

  void levelUPEndurance() {
    if (state.currentLevelEndurance >= 3) return;
    final newLevel = state.currentLevelEndurance + 1;
    state = state.copyWith(
      currentLevelEndurance: newLevel,
      currentEnduranceImage: _getSkillGif('endurance', newLevel),
    );
  }

  void levelUPLife() {
    if (state.currentLevelLife >= 3) return;
    final newLevel = state.currentLevelLife + 1;
    state = state.copyWith(
      currentLevelLife: newLevel,
      currentLifeImage: _getSkillGif('life', newLevel),
    );
  }

  void levelUPSpeed() {
    if (state.currentLevelSpeed >= 3) return;
    final newLevel = state.currentLevelSpeed + 1;
    state = state.copyWith(
      currentLevelSpeed: newLevel,
      currentSpeedImage: _getSkillGif('speed', newLevel),
    );
  }

  SkillLevels _getSkillGif(String skillType, double level) {
    switch (skillType) {
      case 'damage':
        return level == 1
            ? SkillLevels.damageLevel1
            : level == 2
                ? SkillLevels.damageLevel2
                : SkillLevels.damageLevel3;
      case 'endurance':
        return level == 1
            ? SkillLevels.enduranceLevel1
            : level == 2
                ? SkillLevels.enduranceLevel2
                : SkillLevels.enduranceLevel3;
      case 'life':
        return level == 1
            ? SkillLevels.lifeLevel1
            : level == 2
                ? SkillLevels.lifeLevel2
                : SkillLevels.lifeLevel3;
      case 'speed':
        return level == 1
            ? SkillLevels.speedLevel1
            : level == 2
                ? SkillLevels.speedLevel2
                : SkillLevels.speedLevel3;
      default:
        return SkillLevels.damageLevel1;
    }
  }
}

class SkillState {
  final double currentLevelDamage;
  final double currentLevelEndurance;
  final double currentLevelLife;
  final double currentLevelSpeed;
  final SkillLevels currentDamageImage;
  final SkillLevels currentEnduranceImage;
  final SkillLevels currentLifeImage;
  final SkillLevels currentSpeedImage;

  SkillState({
    this.currentDamageImage = SkillLevels.damageLevel1,
    this.currentEnduranceImage = SkillLevels.enduranceLevel1,
    this.currentLifeImage = SkillLevels.lifeLevel1,
    this.currentSpeedImage = SkillLevels.speedLevel1,
    this.currentLevelDamage = 1,
    this.currentLevelEndurance = 1,
    this.currentLevelLife = 1,
    this.currentLevelSpeed = 1,
  });

  SkillState copyWith({
    double? currentLevelDamage,
    double? currentLevelEndurance,
    double? currentLevelLife,
    double? currentLevelSpeed,
    SkillLevels? currentDamageImage,
    SkillLevels? currentEnduranceImage,
    SkillLevels? currentLifeImage,
    SkillLevels? currentSpeedImage,
  }) {
    return SkillState(
      currentDamageImage: currentDamageImage ?? this.currentDamageImage,
      currentEnduranceImage:
          currentEnduranceImage ?? this.currentEnduranceImage,
      currentLifeImage: currentLifeImage ?? this.currentLifeImage,
      currentSpeedImage: currentSpeedImage ?? this.currentSpeedImage,
      currentLevelDamage: currentLevelDamage ?? this.currentLevelDamage,
      currentLevelEndurance:
          currentLevelEndurance ?? this.currentLevelEndurance,
      currentLevelLife: currentLevelLife ?? this.currentLevelLife,
      currentLevelSpeed: currentLevelSpeed ?? this.currentLevelSpeed,
    );
  }
}

enum SkillLevels {
  // Damage Skills
  damageLevel1('assets/images/shared/damage/damage_level1.png'),
  damageLevel2('assets/images/shared/damage/damage_level2.png'),
  damageLevel3('assets/images/shared/damage/damage_level3.png'),

  // Endurance Skills
  enduranceLevel1('assets/images/shared/endurance/endurance_level1.png'),
  enduranceLevel2('assets/images/shared/endurance/endurance_level2.png'),
  enduranceLevel3('assets/images/shared/endurance/endurance_level3.png'),

  // Life Skills
  lifeLevel1('assets/images/shared/life/life_level1.png'),
  lifeLevel2('assets/images/shared/life/life_level2.png'),
  lifeLevel3('assets/images/shared/life/life_level3.png'),

  // Speed Skills
  speedLevel1('assets/images/shared/speed/speed_level1.png'),
  speedLevel2('assets/images/shared/speed/speed_level2.png'),
  speedLevel3('assets/images/shared/speed/speed_level3.png');

  final String image;
  const SkillLevels(this.image);
}
