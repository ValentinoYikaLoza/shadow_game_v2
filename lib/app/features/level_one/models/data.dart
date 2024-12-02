// cada animacion debe venir con su propia velocidad y estado de bucle,
// agregar eso como parámtros
enum PlayerStates {
  stay([
    'assets/frames/player/stay/frame_0.png',
    'assets/frames/player/stay/frame_1.png',
    'assets/frames/player/stay/frame_2.png',
    'assets/frames/player/stay/frame_3.png',
  ], 4, true, 0.2),
  walk([
    'assets/frames/player/walk/frame_0.png',
    'assets/frames/player/walk/frame_1.png',
    'assets/frames/player/walk/frame_2.png',
    'assets/frames/player/walk/frame_3.png',
    'assets/frames/player/walk/frame_4.png',
    'assets/frames/player/walk/frame_5.png',
    'assets/frames/player/walk/frame_6.png',
    'assets/frames/player/walk/frame_7.png',
  ], 8, true, 0.1),
  attack([
    'assets/frames/player/attack/frame_0.png',
    'assets/frames/player/attack/frame_1.png',
    'assets/frames/player/attack/frame_2.png',
    'assets/frames/player/attack/frame_3.png',
  ], 4, false, 0.05),
  dance([
    'assets/frames/player/dance/frame_0.png',
    'assets/frames/player/dance/frame_1.png',
    'assets/frames/player/dance/frame_2.png',
    'assets/frames/player/dance/frame_3.png',
    'assets/frames/player/dance/frame_4.png',
    'assets/frames/player/dance/frame_5.png',
    'assets/frames/player/dance/frame_6.png',
    'assets/frames/player/dance/frame_7.png',
    'assets/frames/player/dance/frame_8.png',
    'assets/frames/player/dance/frame_9.png',
  ], 10, true, 0.2),
  jump([
    'assets/frames/player/jump/frame_0.png',
    'assets/frames/player/jump/frame_1.png',
    'assets/frames/player/jump/frame_2.png',
    'assets/frames/player/jump/frame_3.png',
    'assets/frames/player/jump/frame_4.png',
  ], 5, true, 0.1);

  final List<String> images;
  final int frames;
  final bool loop;
  final double fps;
  const PlayerStates(
    this.images,
    this.frames,
    this.loop,
    this.fps,
  );
}

enum ShadowStates {
  sit([
    'assets/frames/shadow/sit/frame_0.png',
    'assets/frames/shadow/sit/frame_1.png',
    'assets/frames/shadow/sit/frame_2.png',
    'assets/frames/shadow/sit/frame_3.png',
    'assets/frames/shadow/sit/frame_4.png',
    'assets/frames/shadow/sit/frame_5.png',
  ], 6, true, 0.2),
  walk([
    'assets/frames/shadow/walk/frame_0.png',
    'assets/frames/shadow/walk/frame_1.png',
    'assets/frames/shadow/walk/frame_2.png',
    'assets/frames/shadow/walk/frame_3.png',
  ], 4, true, 0.15),
  bark([
    'assets/frames/shadow/bark/frame_0.png',
    'assets/frames/shadow/bark/frame_1.png',
    'assets/frames/shadow/bark/frame_2.png',
    'assets/frames/shadow/bark/frame_3.png',
    'assets/frames/shadow/bark/frame_4.png',
    'assets/frames/shadow/bark/frame_5.png',
    'assets/frames/shadow/bark/frame_6.png',
    'assets/frames/shadow/bark/frame_7.png',
  ], 8, true, 0.1);

  final List<String> images;
  final int frames;
  final bool loop;
  final double fps;
  const ShadowStates(
    this.images,
    this.frames,
    this.loop,
    this.fps,
  );
}

enum SpiderStates {
  stay([
    'assets/frames/spider/stay/frame_0.png',
    'assets/frames/spider/stay/frame_1.png',
    'assets/frames/spider/stay/frame_2.png',
    'assets/frames/spider/stay/frame_3.png',
    'assets/frames/spider/stay/frame_4.png',
  ], 5, true, 0.1),
  walk([
    'assets/frames/spider/walk/frame_0.png',
    'assets/frames/spider/walk/frame_1.png',
    'assets/frames/spider/walk/frame_2.png',
    'assets/frames/spider/walk/frame_3.png',
  ], 4, true, 0.2),
  attack([
    'assets/frames/spider/attack/frame_00.png',
    'assets/frames/spider/attack/frame_01.png',
    'assets/frames/spider/attack/frame_02.png',
    'assets/frames/spider/attack/frame_03.png',
    'assets/frames/spider/attack/frame_04.png',
    'assets/frames/spider/attack/frame_05.png',
    'assets/frames/spider/attack/frame_06.png',
    'assets/frames/spider/attack/frame_07.png',
    'assets/frames/spider/attack/frame_08.png',
    'assets/frames/spider/attack/frame_09.png',
    'assets/frames/spider/attack/frame_10.png',
    'assets/frames/spider/attack/frame_11.png',
    'assets/frames/spider/attack/frame_12.png',
    'assets/frames/spider/attack/frame_13.png',
    'assets/frames/spider/attack/frame_14.png',
    'assets/frames/spider/attack/frame_15.png',
  ], 16, true, 0.08),
  die([
    'assets/frames/spider/die/frame_00.png',
    'assets/frames/spider/die/frame_01.png',
    'assets/frames/spider/die/frame_02.png',
    'assets/frames/spider/die/frame_03.png',
    'assets/frames/spider/die/frame_04.png',
    'assets/frames/spider/die/frame_05.png',
    'assets/frames/spider/die/frame_06.png',
    'assets/frames/spider/die/frame_07.png',
    'assets/frames/spider/die/frame_08.png',
    'assets/frames/spider/die/frame_09.png',
    'assets/frames/spider/die/frame_10.png',
    'assets/frames/spider/die/frame_11.png',
    'assets/frames/spider/die/frame_12.png',
    'assets/frames/spider/die/frame_13.png',
    'assets/frames/spider/die/frame_14.png',
    'assets/frames/spider/die/frame_15.png',
    'assets/frames/spider/die/frame_16.png',
  ], 17, false, 0.05);

  final List<String> images;
  final int frames;
  final bool loop;
  final double fps;
  const SpiderStates(
    this.images,
    this.frames,
    this.loop,
    this.fps,
  );
}

enum CoinStates {
  looping([
    'assets/frames/objects/coin/frame_0.png',
    'assets/frames/objects/coin/frame_1.png',
    'assets/frames/objects/coin/frame_2.png',
    'assets/frames/objects/coin/frame_3.png',
    'assets/frames/objects/coin/frame_4.png',
    'assets/frames/objects/coin/frame_5.png',
    'assets/frames/objects/coin/frame_6.png',
    'assets/frames/objects/coin/frame_7.png',
    'assets/frames/objects/coin/frame_8.png',
    'assets/frames/objects/coin/frame_9.png',
  ], 10, true, 0.1),
  waiting([
    'assets/frames/objects/coin/frame_0.png',
    'assets/frames/objects/coin/frame_1.png',
    'assets/frames/objects/coin/frame_2.png',
    'assets/frames/objects/coin/frame_3.png',
    'assets/frames/objects/coin/frame_4.png',
    'assets/frames/objects/coin/frame_5.png',
    'assets/frames/objects/coin/frame_6.png',
    'assets/frames/objects/coin/frame_7.png',
    'assets/frames/objects/coin/frame_8.png',
    'assets/frames/objects/coin/frame_9.png',
  ], 10, false, 0.1);

  final List<String> images;
  final int frames;
  final bool loop;
  final double fps;

  const CoinStates(
    this.images,
    this.frames,
    this.loop,
    this.fps,
  );
}

enum DoorStates {
  open(['assets/images/level_one/door/open_door.png']),
  close(['assets/images/level_one/door/close_door.png']);

  final List<String> images;
  const DoorStates(this.images);
}

enum ChestStates {
  open(['assets/images/level_one/chest/open_chest.png']),
  close(['assets/images/level_one/chest/close_chest.png']);

  final List<String> images;
  const ChestStates(this.images);
}

enum Directions {
  right,
  left,
  up;
}
