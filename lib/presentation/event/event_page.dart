import 'dart:async';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/presentation/core/widgets/top_menu_bar.dart';
import 'package:va_monitoring/presentation/event/widgets/event_body.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class EventPage extends StatefulWidget {
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  ///
  const EventPage({
    Key? key,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<EventPage> createState() => _EventPageState(
    users: _users,
    themeSwitch: _themeSwitch,
  );
}

///
class _EventPageState extends State<EventPage> {
  static const _debug = true;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  final StreamController<OperationState> _stateController = StreamController<OperationState>();
  late Stream<OperationState> _stateStream;
  // late List<String> _statusList;
  ///
  _EventPageState({
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _users = users,
    _themeSwitch = themeSwitch,
    super();
  //
  @override
  void initState() {
    super.initState();
    _stateStream = _stateController.stream;
  }
  //
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    log(_debug, '[_EventPageState.build] user: ', user);
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
            indicator: CircularProgressIndicatorStreamed(stream: _stateStream),
          ),
        ),
        body: EventBody(
          onState: (state) {
            _stateController.add(state);
          },
        ),
      ),
    );    
  }
}
