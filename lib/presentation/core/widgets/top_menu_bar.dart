import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/presentation/core/widgets/floating_menu_widget.dart';
import 'package:va_monitoring/presentation/core/widgets/right_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_networking/hmi_networking.dart';

class TopMenuBar extends StatelessWidget {
  // static final _log = const Log('TopMenuBar')..level=LogLevel.debug;
  final AppUserStacked _users;
  final Widget? _indicator;
  ///
  /// if [indicator] not given connection state indicator will be displayed 
  const TopMenuBar({
    super.key,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
    Widget? indicator,
  }) : 
    _users = users,
    _indicator = indicator;
  //
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingMenuWidget(
            users: _users,
        ),
        Positioned(
          right: 0,
          child: RightIconWidget(
            users: _users,
            indicator: _indicator,
          ),
        ),
      ],
    );
  }
}
