enum PlayerStates {
  stay('sheets/player/stay.png', 4),
  walk('sheets/player/walk.png', 8),
  attack('sheets/player/attack.png', 4),
  dance('sheets/player/dance.png', 10),
  jump('sheets/player/jump.png', 5);

  final String sheet;
  final int frames;
  const PlayerStates(this.sheet, this.frames);
}

enum ShadowStates {
  sit('sheets/shadow/sit.png', 6),
  walk('sheets/shadow/walk.png', 4),
  bark('sheets/shadow/bark.png', 8);

  final String sheet;
  final int frames;
  const ShadowStates(this.sheet, this.frames);
}

enum SpiderStates {
  stay('sheets/spider/stay.png', 5),
  walk('sheets/spider/walk.png', 4),
  attack('sheets/spider/attack.png', 16),
  die('sheets/spider/die.png', 17);

  final String sheet;
  final int frames;
  const SpiderStates(this.sheet, this.frames);
}

enum DoorStates {
  open('assets/images/level_one/door/open_door.png'),
  close('assets/images/level_one/door/close_door.png');

  final String image;
  const DoorStates(this.image);
}

enum ChestStates {
  open('assets/images/level_one/chest/open_chest.png'),
  close('assets/images/level_one/chest/close_chest.png');

  final String image;
  const ChestStates(this.image);
}

enum Directions {
  right,
  left,
  up;
}
