import 'package:va_monitoring/presentation/core/theme/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';

///
class RightIconWidget extends StatefulWidget {
  final AppUserStacked? _users;
  final Widget? _indicator;
  ///
  const RightIconWidget({
    Key? key,
    AppUserStacked? users,
    Widget? indicator,
  }) :
    _users = users,
    _indicator = indicator,
    super(key: key);
  //
  @override
  State<RightIconWidget> createState() => _RightIconWidgetState(
    users: _users,
    indicator: _indicator,
  );
}

///
class _RightIconWidgetState extends State<RightIconWidget> with TickerProviderStateMixin {
  // static const _debug = true;
  final AppUserStacked? _users;
  final Widget? _indicator;
  bool _hovered = false;
  ///
  _RightIconWidgetState({
    required AppUserStacked? users,
    required Widget? indicator,
  }) :
    _users = users,
    _indicator = indicator;
  //
  @override
  Widget build(BuildContext context) {
    final indicator = _indicator;
    final padding = const Setting('padding').toDouble;
    final floatingActionButtonSize = const Setting('floatingActionButtonSize').toDouble;
    return Row(
      children: [
        /// Индикатор | Связь
        if (indicator != null)
          SizedBox(
            width: floatingActionButtonSize * 0.95,
            height: floatingActionButtonSize * 0.95,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(floatingActionButtonSize * 0.9 * 0.95 * 0.5),
              ),
                  child: Center(child: indicator),
              ),
            // ),
          ),
        if (indicator != null && _users != null)
          SizedBox(width: padding),
        _buildUserIconWidget(),
      ],
    );
  }
  ///
  Widget _buildUserIconWidget() {
    final floatingActionButtonSize = const Setting('floatingActionButtonSize').toDouble;
    final padding = const Setting('padding').toDouble;
    final user = _users?.peek;
    final userGroup = user?.userGroup();
    final userGroupTextColor = _buildUserGroupTextColor(userGroup);
    if (_users != null) {
      return MouseRegion(
        onEnter: (event) {
          setState(() => _hovered = true);
        },
        onExit: (event) {
          setState(() => _hovered = false);
        },
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.5 * 0.9 * 0.95 * floatingActionButtonSize),
            ),
            child: Padding(
              padding: EdgeInsets.all(0.5 * 0.9 * 0.95 * 0.25 * floatingActionButtonSize),
              child: Row(
                children: [
                  if (_hovered) ...[
                    SizedBox(width: padding),
                    Column(
                      children: [
                        Text(user?['name'].value),
                        Text(
                          '${userGroup?.value}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: userGroupTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Icon(
                    Icons.account_circle_outlined, 
                    size: 0.9 * 0.95 * 0.75 * floatingActionButtonSize,
                    color: userGroupTextColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
  ///
  Color _buildUserGroupTextColor(UserGroup? userGroup) {
    final group = userGroup?.value;
    if (group != null) {
      if (group == UserGroupList.guest) {
        return colorShiftLightness(Theme.of(context).colorScheme.onBackground, 0.6);
      }
      if (group == UserGroupList.operator) {
        return Theme.of(context).colorScheme.primary;
      }
      if (group == UserGroupList.admin) {
        return Theme.of(context).colorScheme.secondary;
      }
    }
    return Theme.of(context).colorScheme.primary;
  }
}
