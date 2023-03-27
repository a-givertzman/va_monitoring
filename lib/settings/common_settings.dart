import 'package:flutter/material.dart';

///
class AppUiSettings {
  // static const displaySize = Size(1024.0, 768.0);
  // static const flushBarDurationLong = Duration(seconds: 8);
  // static const flushBarDurationMedium = Duration(seconds: 4);
  // static const flushBarDurationShort = Duration(seconds: 2);
  // static const smsResendTimeout = 60;
  // static const padding = 8.0;
  // static const blockPadding = padding * 2;
  // static const floatingActionButtonSize = 60.0;
  // static const floatingActionIconSize = 0.75 * floatingActionButtonSize;
  /// возвращает [ColorFilter] для неактивного виджета
  static ColorFilter colorFilterDisabled(BuildContext context, bool disabled) {
    return ColorFilter.mode(
      Theme.of(context).colorScheme.background.withOpacity(0.7),
      disabled ? BlendMode.darken : BlendMode.dst,
    );
  }
}
