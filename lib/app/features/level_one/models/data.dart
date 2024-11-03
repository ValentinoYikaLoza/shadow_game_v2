enum PlayerStates {
  stay('assets/gifs/player/stay.gif'),
  walk('assets/gifs/player/walk.gif'),
  attack('assets/gifs/player/attack.gif'),
  cut('assets/gifs/player/cut.gif'),
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

enum Directions {
  right,
  left,
  up;
}


