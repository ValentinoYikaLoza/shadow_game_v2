import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shadow_game_v2/app/config/constants/app_colors.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_gif.dart';

final GlobalKey<_SnackbarContentState> _snackbarKey =
    GlobalKey<_SnackbarContentState>();

class SnackbarService {
  static SnackbarModel? show(String message) {
    if (_snackbarKey.currentState != null) {
      final newSnackbar = _snackbarKey.currentState!.addSnackbar(message);
      return newSnackbar;
    }

    return null;
  }

  static remove(SnackbarModel? snackbar) {
    if (_snackbarKey.currentState != null) {
      _snackbarKey.currentState!.removeSnackbar(snackbar);
    }
  }
}

class SnackbarProvider extends StatelessWidget {
  const SnackbarProvider({
    super.key,
    this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _SnackbarContent(
      key: _snackbarKey,
      child: child,
    );
  }
}

class _SnackbarContent extends StatefulWidget {
  const _SnackbarContent({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<_SnackbarContent> createState() => _SnackbarContentState();
}

class _SnackbarContentState extends State<_SnackbarContent> {
  List<SnackbarModel> snackbars = [];

  SnackbarModel addSnackbar(String message) {
    final SnackbarModel newSnackbar =
        SnackbarModel(id: _generateRandomString(10), message: message);

    setState(() {
      snackbars.add(newSnackbar);
    });
    Future.delayed(const Duration(seconds: 4), () {
      removeSnackbar(newSnackbar);
    });

    return newSnackbar;
  }

  removeSnackbar(SnackbarModel? snackbar) {
    if (snackbar == null) return;
    setState(() {
      snackbars.remove(snackbar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          if (widget.child != null) widget.child!,
          Positioned(
            top: 20,
            left: screen.width / 2 - 200,
            child: Wrap(
              direction: Axis.vertical,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              children: snackbars.reversed.toList().map((snackbar) {
                return _CustomSnackbarMobile(
                  message: snackbar.message,
                  onClose: () {
                    removeSnackbar(snackbar);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

String _generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

class _CustomSnackbarMobile extends StatelessWidget {
  const _CustomSnackbarMobile({
    required this.message,
    required this.onClose,
  });

  final String message;
  final void Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: MediaQuery.of(context).size.width / 2,
              minHeight: 74,
            ),
            padding: const EdgeInsets.only(),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: AppColors.blue,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 83,
                  color: AppColors.blue,
                ),
                const SizedBox(
                  width: 11,
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: const CustomGif(
                    images: ['assets/icon.jpg'],
                    width: 50,
                    loop: false,
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue,
                      height: 20 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SnackbarModel {
  final String id;
  final String message;

  SnackbarModel({
    required this.id,
    required this.message,
  });
}
