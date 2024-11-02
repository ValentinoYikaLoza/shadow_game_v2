import 'package:flutter_riverpod/flutter_riverpod.dart';

final objectProvider =
    StateNotifierProvider<ObjectNotifier, ObjectState>((ref) {
  return ObjectNotifier(ref);
});

class ObjectNotifier extends StateNotifier<ObjectState> {
  ObjectNotifier(this.ref) : super(ObjectState());
  final Ref ref;

  void updateXCoords(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;
    state = state.copyWith(
      initialPosition: newPosition.roundToDouble(),
    );
    print(state.initialPosition);
  }
}

class ObjectState {
  final double initialPosition;

  ObjectState({
    this.initialPosition = 100,
  });

  ObjectState copyWith({
    double? initialPosition,
  }) {
    return ObjectState(
      initialPosition: initialPosition ?? this.initialPosition,
    );
  }
}
