import 'package:flutter/material.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/loader.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/snackbar.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SnackbarProvider(
      child: LoaderProvider(
        child: child,
      ),
    );
  }
}
