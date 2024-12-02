import 'package:flutter/widgets.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';

class DoorWidget extends StatelessWidget {
  final Door door;
  const DoorWidget({
    super.key,
    required this.door,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 63,
      left: door.initialPosition,
      child: Column(
        children: [
          door.doorType == DoorType.start
              ? Image.asset('assets/gifs/home.gif')
              : Image.asset('assets/gifs/next_level.gif'),
          const SizedBox(height: 10),
          SizedBox(
            width: 100,
            child: Image.asset(
              door.currentState.image,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
