import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadow_game_v2/app/config/router/router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

enum RouterType { 
  mobile
}

class AppRouter {

  static GoRouter getAppRouter() {
    return router;
  }
  static void go(String location) {
    router.go(location);
  }

  static void push(String location) {
    router.push(location);
  }

  static void pop(String location) {
    router.pop();
  }

  static void pushReplacement(String location) {
    router.pushReplacement(location);
  }
}