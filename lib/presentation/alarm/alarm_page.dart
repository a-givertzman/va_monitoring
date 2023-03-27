import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:va_monitoring/presentation/core/widgets/connection_status_indicator/connection_status_indicator.dart';
import 'package:va_monitoring/presentation/core/widgets/top_menu_bar.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/alarm/widgets/alarm_body.dart';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
class AlarmPage extends StatefulWidget {
  final AppUserStacked _users;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _listData;
  final AppThemeSwitch _themeSwitch;
  ///
  const AlarmPage({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    required AppThemeSwitch themeSwitch,
  }) : 
    _dsClient = dsClient,
    _listData = listData,
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<AlarmPage> createState() => _AlarmPageState(
    dsClient: _dsClient,
    listData: _listData,
    users: _users,
    themeSwitch: _themeSwitch,
  );
}

///
class _AlarmPageState extends State<AlarmPage> {
  static const _debug = true;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _listData;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  // late List<String> _statusList;
  ///
  _AlarmPageState({
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _dsClient = dsClient,
    _listData = listData,
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
    log(_debug, '[_AlarmPageState.build] user: ', user);
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
          child: TopMenuBar(
            users: _users, 
            themeSwitch: _themeSwitch,
            indicator: ConnectionStatusIndicator(
              stream: _dsClient.streamMerged([
                'Local.System.Connection',
                'system.db902_panel_controls.status',
                'system.db905_visual_data_fast.status',
                'system.db906_visual_data.status',
              ]),
            ),
          ),
        ),
        body: AlarmBody(
          // users: _users,
          dsClient: _dsClient,
          listData: _listData,
        ),
      ),
    );
  }
}
