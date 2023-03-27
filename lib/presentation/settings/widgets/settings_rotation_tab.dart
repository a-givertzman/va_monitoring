import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class SettingsRotationTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const SettingsRotationTab({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    _users = users,
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    
    log(_debug, '[$SettingsRotationTab.build]');
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.SpeedDown1PumpFactor', 
              ),
              labelText: const Localized('Speed deceleration on one pump').v,
              unitText: const Localized('%').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.SlowSpeedFactor', 
              ),
              labelText: const Localized('Speed limit for slow types of work').v,
              unitText: const Localized('%').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.SpeedDown2AxisFactor', 
              ),
              labelText: const Localized('Speed limit at > 2 movement').v,
              unitText: const Localized('%').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.SpeedAccelerationTime', 
              ),
              labelText: const Localized('Linear acceleration time').v,
              unitText: const Localized('ms').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.SpeedDecelerationTime', 
              ),
              labelText: const Localized('Linear deceleration time').v,
              unitText: const Localized('ms').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.FastStoppingTime', 
              ),
              labelText: const Localized('Quick Stop time').v,
              unitText: const Localized('ms').v,
              width: 350,
              showApplyButton: true,
            ),
          ],
        ),
        SizedBox(width: blockPadding * 8,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.PositionDefault', 
              ),
              labelText: const Localized('Default position').v,
              unitText: const Localized('º').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.PositionReset', 
              ),
              labelText: const Localized('Reset position').v,
              unitText: const Localized('º').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.PositionOffshore', 
              ),
              labelText: '${const Localized('Position').v} "${const Localized('Offshore').v}"',
              unitText: const Localized('º').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.PositionMarchingMode', 
              ),
              labelText: '${const Localized('Position').v} "${const Localized('MarchingMode').v}"',
              unitText: const Localized('º').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: blockPadding),
            Text(
              '${const Localized('Speed limit at position').v} "${const Localized('MarchingMode').v}":',
            ),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.SpeedDownMaxPos', 
              ),
              labelText: const Localized('Speed deceleration position').v,
              unitText: const Localized('º').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.Rotation.SpeedDownMaxPosFactor', 
              ),
              labelText: const Localized('Speed limit to').v,
              unitText: const Localized('%').v,
              width: 350,
              showApplyButton: true,
            ),
          ],
        ),
      ],
    );
  }
}
