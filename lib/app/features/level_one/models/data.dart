// cada animacion debe venir con su propia velocidad y estado de bucle,
// agregar eso como parámtros
enum PlayerStates {
  stay('sheets/player/stay.png', 4, true, 0.2),
  walk('sheets/player/walk.png', 8, true, 0.1),
  attack('sheets/player/attack.png', 4, false, 0.05),
  dance('sheets/player/dance.png', 10, true, 0.2),
  jump('sheets/player/jump.png', 5, true, 0.1);

  final String sheet;
  final int frames;
  final bool loop;
  final double fps;
  const PlayerStates(
    this.sheet,
    this.frames,
    this.loop,
    this.fps,
  );
}

enum ShadowStates {
  sit('sheets/shadow/sit.png', 6, true, 0.2),
  walk('sheets/shadow/walk.png', 4, true, 0.15),
  bark('sheets/shadow/bark.png', 8, true, 0.1);

  final String sheet;
  final int frames;
  final bool loop;
  final double fps;
  const ShadowStates(
    this.sheet,
    this.frames,
    this.loop,
    this.fps,
  );
}

enum SpiderStates {
  stay('sheets/spider/stay.png', 5, true, 0.1),
  walk('sheets/spider/walk.png', 4, true, 0.1),
  attack('sheets/spider/attack.png', 16, true, 0.08),
  die('sheets/spider/die.png', 17, false, 0.05);

  final String sheet;
  final int frames;
  final bool loop;
  final double fps;
  const SpiderStates(
    this.sheet,
    this.frames,
    this.loop,
    this.fps,
  );
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
