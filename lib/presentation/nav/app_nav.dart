import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class AppNav {
  static final _log = const Log('AppNav')..level = LogLevel.debug;
  ///
  const AppNav();
  ///
  static void logout(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      _log.debug('route: ${route.settings.name}');
      return route.settings.name == '/signInPage';
    });
  }
}
