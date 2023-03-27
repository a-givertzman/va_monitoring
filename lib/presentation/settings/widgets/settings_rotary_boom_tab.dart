import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class SettingsRotaryBoomTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const SettingsRotaryBoomTab({
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
    log(_debug, '[$SettingsRotaryBoomTab.build]');
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedDown1PumpFactor', 
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SlowSpeedFactor', 
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedDown2AxisFactor', 
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedAccelerationTime', 
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedDecelerationTime', 
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.FastStoppingTime', 
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
            Text(
              '${const Localized('Speed limit at the maximum position').v}:',
            ),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedDownMaxPos', 
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedDownMaxPosFactor', 
              ),
              labelText: const Localized('Speed limit to').v,
              unitText: const Localized('%').v,
              width: 350,
              showApplyButton: true,
            ),
            SizedBox(height: blockPadding),
            Text(
              '${const Localized('Speed limit at the minimum position').v}:',
            ),
            // SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: const ['admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointName(
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedDownMinPos', 
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
                '/line1/ied12/db902_panel_controls/Settings.RotaryBoom.SpeedDownMinPosFactor', 
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
