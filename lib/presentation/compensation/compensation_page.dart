import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/presentation/core/widgets/connection_status_indicator/connection_status_indicator.dart';
import 'package:va_monitoring/presentation/core/widgets/top_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'compensation_body.dart';

///
class CompensationPage extends StatelessWidget {
  final AppUserStacked _users;
  final DsClient _dsClient;
  final AppThemeSwitch _themeSwitch;
  ///
  const CompensationPage({
    super.key, 
    required AppUserStacked users, 
    required DsClient dsClient, 
    required AppThemeSwitch themeSwitch,
  }) :
    _users = users,
    _dsClient = dsClient,
    _themeSwitch = themeSwitch;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(const Setting('blockPadding').toDouble),
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
      body: CompensationBody(dsClient: _dsClient),
    );
  }
}
