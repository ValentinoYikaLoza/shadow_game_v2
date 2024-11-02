import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/loader.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key, required this.child});
  final Widget child;

  @override
  AppState createState() => AppState();
}

class AppState extends ConsumerState<App> {
  // bool getStorage = false;

  @override
  void initState() {
    super.initState();
    initStorage();
  }

  //inicializa las variables de storage importantes y no empieza la app hasta que termine
  initStorage() async {
    // await ref.read(monedaProvider.notifier).initMoneda();
    // await ref.read(fideicomisosProvider.notifier).initFideicomiso();
    // await ref.read(fideicomisosProvider.notifier).listarPermisos();
    // setState(() {
    //   getStorage = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderProvider(
      child: widget.child,
    );
  }
}
