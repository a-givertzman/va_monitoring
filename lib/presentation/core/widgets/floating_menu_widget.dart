import 'package:va_monitoring/presentation/nav/app_nav.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class FloatingMenuWidget extends StatelessWidget {
  final AppUserStacked _users;
  ///
  const FloatingMenuWidget({
    super.key,
    required AppUserStacked users,
  }) : 
    _users = users;
  //
  @override
  Widget build(BuildContext context) {
    final floatingActionIconSize = const Setting('floatingActionIconSize').toDouble;
    final floatingActionButtonSize = const Setting('floatingActionButtonSize').toDouble;
    return CircularFabWidget(
      key: UniqueKey(),
      buttonSize: floatingActionButtonSize,
      icon: GestureDetector(
        onDoubleTap: () => Navigator.of(context).pop(false),
        child: Icon(Icons.menu, size: floatingActionIconSize),
      ),
      children: [
        FloatingActionButton(
          heroTag: 'FloatingActionButtonHome',
          child: Icon(Icons.home, size: floatingActionIconSize),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FloatingActionButton(
          heroTag: 'FloatingActionButtonHomeLogout', 
          child: Icon(Icons.logout, size: floatingActionIconSize),
          onPressed: () {
            _users.clear();
            AppNav.logout(context);
          },
        ),
      ],
    );
  }
}
