import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:flutter/services.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/presentation/core/widgets/right_icon_widget.dart';
import 'package:va_monitoring/presentation/menu/widgets/menu_body.dart';
import 'package:va_monitoring/presentation/nav/app_nav.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
/// Главное меню приложения
class MenuPage extends StatefulWidget {
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  ///
  const MenuPage({
    Key? key,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) : 
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<MenuPage> createState() => _MenuPageState(
    dsClient: _dsClient,
    alarmListData: _alarmListData,
    users: _users,
    themeSwitch: _themeSwitch,
  );
}

///
class _MenuPageState extends State<MenuPage> {
  final _log = const Log('_MenuPageState')..level = LogLevel.info;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  ///
  _MenuPageState({
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    _users = users,
    _themeSwitch = themeSwitch,
    super();
  //
  @override
  void initState() {
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    _log.info('[.build] user: $user');
    // final userGroup = AppUserGroup('${user['group']}');
    return _buildScaffold(context);
  }
  ///
  Widget _buildScaffold(BuildContext context) {
    // final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.all(blockPadding),
          child: _buildMenuWidget(context),
        ),
        // appBar: _appBar(userGroup),
        body: MenuBody(
          users: _users,
          dsClient: _dsClient,
          alarmListData: _alarmListData,
          themeSwitch: _themeSwitch,
        ),
      ),
    );    
  }
  ///
  Stack _buildMenuWidget(BuildContext context) {
    final floatingActionIconSize = const Setting('floatingActionIconSize').toDouble;
    final floatingActionButtonSize = const Setting('floatingActionButtonSize').toDouble;
    return Stack(
      children: [
        CircularFabWidget(
            key: UniqueKey(),
            buttonSize: floatingActionButtonSize,
            icon: Icon(Icons.menu, size: floatingActionIconSize),
            // onPressed: () {
            // },
            children: [
              FloatingActionButton(
                key: UniqueKey(),
                heroTag: 'FloatingActionButtonCloseApp', 
                child: Icon(Icons.close, size: floatingActionIconSize),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
              FloatingActionButton(
                key: UniqueKey(),
                heroTag: 'FloatingActionButtonTheme', 
                child: Icon(Icons.color_lens_outlined, size: floatingActionIconSize),
                onPressed: () {
                  final theme = _themeSwitch.theme == AppTheme.light
                    ? AppTheme.dark 
                    : AppTheme.light;
                  _themeSwitch.toggleTheme(theme);
                },
              ),
              // FloatingActionButton(
              //   heroTag: 'FloatingActionButtonUserAccount', 
              //   child: Icon(Icons.account_circle_outlined, size: floatingActionIconSize),
              //   onPressed: () {
              //   },
              // ),
              FloatingActionButton(
                heroTag: 'FloatingActionButtonHomeLogout', 
                child: Icon(Icons.logout, size: floatingActionIconSize),
                onPressed: () {
                  _users.clear();
                  AppNav.logout(context);
                },
              ),
            ],
          ),
        // CircularFabWidget(
        //     key: UniqueKey(),
        //     icon: const Icon(
        //       Icons.account_circle_outlined, 
        //       size: AppUiSettings.floatingActionButtonSize,
        //     ),
        //     children: [],
        // ),
        Positioned(
          right: 0,
          child: RightIconWidget(
            users: _users,
            // dsClient: _dsClient,
          ),
        ),
      ],
    );
  }
}
