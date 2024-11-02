enum PlayerState {
  stay('assets/gifs/player/stay.gif', 4),
  walk('assets/gifs/player/walk.gif', 8),
  attack('assets/gifs/player/attack.gif', 4),
  cut('assets/gifs/player/cut.gif', 4),
  jump('assets/gifs/player/jump.gif', 5);

  final String gif;
  final int frames;
  const PlayerState(this.gif, this.frames);
}

enum PlayerDirection {
  right,
  left,
  up;
}
