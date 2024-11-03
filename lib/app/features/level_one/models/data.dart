enum PlayerStates {
  stay('assets/gifs/player/stay.gif'),
  walk('assets/gifs/player/walk.gif'),
  attack('assets/gifs/player/attack.gif'),
  dance('assets/gifs/player/dance.gif'),
  jump('assets/gifs/player/jump.gif');

  final String gif;
  const PlayerStates(this.gif);
}

enum ShadowStates {
  sit('assets/gifs/shadow/sit.gif'),
  walk('assets/gifs/shadow/walk.gif');

  final String gif;
  const ShadowStates(this.gif);
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

enum SpiderStates {
  stay('assets/gifs/spider/stay.gif'),
  walk('assets/gifs/spider/walk.gif'),
  attack('assets/gifs/spider/attack.gif'),
  die('assets/gifs/spider/die.gif');

  final String gif;
  const SpiderStates(this.gif);
}

enum Directions {
  right,
  left,
  up;
}
