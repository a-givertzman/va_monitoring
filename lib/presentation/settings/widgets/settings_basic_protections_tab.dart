import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class SettingsBasicProtectionsTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const SettingsBasicProtectionsTab({
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
    log(_debug, '[$SettingsBasicProtectionsTab.build]');
    final padding = const Setting('padding').toDouble;
    // final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NetworkEditField<double>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName('/line1/ied12/db902_panel_controls/Settings.Art.TorqueLimit'),
          labelText: const Localized('ART Torque limitation').v,
          unitText: const Localized('%').v,
          fractionDigits: 1,
          width: 350,
          showApplyButton: true,
        ),
        SizedBox(height: padding),
        NetworkEditField<double>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName('/line1/ied12/db902_panel_controls/Settings.AOPS.RotationLimit1'),
          labelText: const Localized('AOPS Rotation angle limit 5/7.5t').v,
          unitText: const Localized('º').v,
          fractionDigits: 1,
          width: 350,
          showApplyButton: true,
        ),
        SizedBox(height: padding),
        NetworkEditField<double>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName('/line1/ied12/db902_panel_controls/Settings.AOPS.RotationLimit2'),
          labelText: const Localized('AOPS Rotation angle limit 20/23t').v,
          unitText: const Localized('º').v,
          fractionDigits: 1,
          width: 350,
          showApplyButton: true,
        ),
      ],
    );
  }
}
