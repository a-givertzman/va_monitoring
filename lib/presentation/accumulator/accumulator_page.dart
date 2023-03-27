import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/presentation/accumulator/widgets/accumulator_body.dart';
import 'package:va_monitoring/presentation/core/widgets/connection_status_indicator/connection_status_indicator.dart';
import 'package:va_monitoring/presentation/core/widgets/top_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
///
class AccumulatorPage extends StatefulWidget {
  final AppUserStacked _users;
  final DsClient _dsClient;
  final AppThemeSwitch _themeSwitch;
  ///
  const AccumulatorPage({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
    required AppThemeSwitch themeSwitch,
  }) : 
    _dsClient = dsClient,
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<AccumulatorPage> createState() => _AccumulatorPageState(
    dsClient: _dsClient,
    users: _users,
    themeSwitch: _themeSwitch,
  );
}

///
class _AccumulatorPageState extends State<AccumulatorPage> {
  static const _debug = true;
  final DsClient _dsClient;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  // late List<String> _statusList;
  ///
  _AccumulatorPageState({
    required DsClient dsClient,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _dsClient = dsClient,
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
    log(_debug, '[_AccumulatorPageState.build] user: ', user);
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
        // appBar: _appBar(userGroup),
        body: AccumulatorBody(
          // users: _users,
          dsClient: _dsClient,
        ),
      ),
    );
  }
}
