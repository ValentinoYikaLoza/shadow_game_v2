class ObjectAnimation {
  final List<String> images;
  final int frames;
  final bool loop;
  final double fps;

  const ObjectAnimation({
    required this.images,
    required this.frames,
    required this.loop,
    required this.fps,
  });
}

class PlayerAnimation extends ObjectAnimation {
  const PlayerAnimation({
    required super.images,
    required super.frames,
    required super.loop,
    required super.fps,
  });
}

class ShadowAnimation extends ObjectAnimation {
  const ShadowAnimation({
    required super.images,
    required super.frames,
    required super.loop,
    required super.fps,
  });
}

class SpiderAnimation extends ObjectAnimation {
  const SpiderAnimation({
    required super.images,
    required super.frames,
    required super.loop,
    required super.fps,
  });
}

class CoinAnimation extends ObjectAnimation {
  const CoinAnimation({
    required super.images,
    required super.frames,
    required super.loop,
    required super.fps,
  });
}

class DoorSprite {
  final List<String> images;

  const DoorSprite(this.images);
}

class ChestSprite {
  final List<String> images;

  const ChestSprite(this.images);
}

enum PlayerAnimations {
  stay(PlayerAnimation(
    images: [
      'assets/frames/player/stay/frame_0.png',
      'assets/frames/player/stay/frame_1.png',
      'assets/frames/player/stay/frame_2.png',
      'assets/frames/player/stay/frame_3.png',
    ],
    frames: 4,
    loop: true,
    fps: 0.2,
  )),
  walk(PlayerAnimation(
    images: [
      'assets/frames/player/walk/frame_0.png',
      'assets/frames/player/walk/frame_1.png',
      'assets/frames/player/walk/frame_2.png',
      'assets/frames/player/walk/frame_3.png',
      'assets/frames/player/walk/frame_4.png',
      'assets/frames/player/walk/frame_5.png',
      'assets/frames/player/walk/frame_6.png',
      'assets/frames/player/walk/frame_7.png',
    ],
    frames: 8,
    loop: true,
    fps: 0.1,
  )),
  attack(PlayerAnimation(
    images: [
      'assets/frames/player/attack/frame_0.png',
      'assets/frames/player/attack/frame_1.png',
      'assets/frames/player/attack/frame_2.png',
      'assets/frames/player/attack/frame_3.png',
    ],
    frames: 4,
    loop: false,
    fps: 0.05,
  )),
  dance(PlayerAnimation(
    images: [
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
    ],
    frames: 10,
    loop: true,
    fps: 0.2,
  )),
  jump(PlayerAnimation(
    images: [
      'assets/frames/player/jump/frame_0.png',
      'assets/frames/player/jump/frame_1.png',
      'assets/frames/player/jump/frame_2.png',
      'assets/frames/player/jump/frame_3.png',
      'assets/frames/player/jump/frame_4.png',
    ],
    frames: 5,
    loop: true,
    fps: 0.1,
  ));

  final PlayerAnimation state;

  const PlayerAnimations(this.state);
}

enum ShadowAnimations {
  sit(ShadowAnimation(
    images: [
      'assets/frames/shadow/sit/frame_0.png',
      'assets/frames/shadow/sit/frame_1.png',
      'assets/frames/shadow/sit/frame_2.png',
      'assets/frames/shadow/sit/frame_3.png',
      'assets/frames/shadow/sit/frame_4.png',
      'assets/frames/shadow/sit/frame_5.png',
    ],
    frames: 6,
    loop: true,
    fps: 0.2,
  )),
  walk(ShadowAnimation(
    images: [
      'assets/frames/shadow/walk/frame_0.png',
      'assets/frames/shadow/walk/frame_1.png',
      'assets/frames/shadow/walk/frame_2.png',
      'assets/frames/shadow/walk/frame_3.png',
    ],
    frames: 4,
    loop: true,
    fps: 0.15,
  )),
  bark(ShadowAnimation(
    images: [
      'assets/frames/shadow/bark/frame_0.png',
      'assets/frames/shadow/bark/frame_1.png',
      'assets/frames/shadow/bark/frame_2.png',
      'assets/frames/shadow/bark/frame_3.png',
      'assets/frames/shadow/bark/frame_4.png',
      'assets/frames/shadow/bark/frame_5.png',
      'assets/frames/shadow/bark/frame_6.png',
      'assets/frames/shadow/bark/frame_7.png',
    ],
    frames: 8,
    loop: true,
    fps: 0.1,
  ));

  final ShadowAnimation state;

  const ShadowAnimations(this.state);
}

enum SpiderAnimations {
  stay(SpiderAnimation(
    images: [
      'assets/frames/spider/stay/frame_0.png',
      'assets/frames/spider/stay/frame_1.png',
      'assets/frames/spider/stay/frame_2.png',
      'assets/frames/spider/stay/frame_3.png',
      'assets/frames/spider/stay/frame_4.png',
    ],
    frames: 5,
    loop: true,
    fps: 0.1,
  )),
  walk(SpiderAnimation(
    images: [
      'assets/frames/spider/walk/frame_0.png',
      'assets/frames/spider/walk/frame_1.png',
      'assets/frames/spider/walk/frame_2.png',
      'assets/frames/spider/walk/frame_3.png',
    ],
    frames: 4,
    loop: true,
    fps: 0.2,
  )),
  attack(SpiderAnimation(
    images: [
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
    ],
    frames: 16,
    loop: true,
    fps: 0.08,
  )),
  die(SpiderAnimation(
    images: [
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
    ],
    frames: 17,
    loop: false,
    fps: 0.05,
  ));

  final SpiderAnimation state;

  const SpiderAnimations(this.state);
}

enum CoinAnimations {
  looping(CoinAnimation(
    images: [
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
    ],
    frames: 10,
    loop: true,
    fps: 0.1,
  )),
  waiting(CoinAnimation(
    images: [
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
    ],
    frames: 10,
    loop: false,
    fps: 0.1,
  ));

  final CoinAnimation state;

  const CoinAnimations(this.state);
}

enum DoorSprites {
  open(DoorSprite(['assets/images/level_one/door/open_door.png'])),
  close(DoorSprite(['assets/images/level_one/door/close_door.png']));

  final DoorSprite state;

  const DoorSprites(this.state);
}

enum ChestSprites {
  open(ChestSprite(['assets/images/level_one/chest/open_chest.png'])),
  close(ChestSprite(['assets/images/level_one/chest/close_chest.png']));

  final ChestSprite state;

  const ChestSprites(this.state);
}

enum Directions { right, left }
