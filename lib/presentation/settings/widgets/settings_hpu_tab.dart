import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class SettingsHpuTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const SettingsHpuTab({
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
    log(_debug, '[$SettingsHpuTab.build]');
    log(_debug, '[$SettingsHpuTab.build _users: ${_users.toList()}');
    log(_debug, '[$SettingsHpuTab.build _user: ${_users.peek}');
    final padding = const Setting('padding').toDouble;
    // final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NetworkDropdownFormField(
          // onAuthRequested: _authenticate,
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.HPU.OilType', 
          ),
          labelText: const Localized('Oil Type').v,
          width: 350,
          oilData: OilData(
            jsonMap: JsonMap.fromTextFile(
              const TextFile.asset('assets/settings/oil-list.json'),
            ),
          ),
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.HPU.AlarmLowOilLevel', 
          ),
          labelText: const Localized('Emergency low oil level').v,
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
            '/line1/ied12/db902_panel_controls/Settings.HPU.LowOilLevel', 
          ),
          labelText: const Localized('Low oil level').v,
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
            '/line1/ied12/db902_panel_controls/Settings.HPU.HighOilTemp', 
          ),
          labelText: const Localized('High oil temperature').v,
          unitText: const Localized('℃').v,
          width: 350,
          showApplyButton: true,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.HPU.AlarmHighOilTemp', 
          ),
          labelText: const Localized('Emergency high oil temperature').v,
          unitText: const Localized('℃').v,
          width: 350,
          showApplyButton: true,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.HPU.LowOilTemp', 
          ),
          labelText: const Localized('Low oil temperature').v,
          unitText: const Localized('℃').v,
          width: 350,
          showApplyButton: true,
        ),
        SizedBox(height: padding),
        // TODO from Oleg: следующие поля убрать,
        //                 дополнительно вывести текущие значеения:
        //                   - давления
        //                   - температуры
        //                   - вычисленное значение перепада температуры
        NetworkEditField<int>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.HPU.OilCooling', 
          ),
          labelText: const Localized('Oil cooling').v,
          unitText: const Localized('℃').v,
          width: 350,
          showApplyButton: true,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.HPU.OilTempHysteresis', 
          ),
          labelText: const Localized('Oil temperature hysteresis').v,
          unitText: const Localized('℃').v,
          width: 350,
          showApplyButton: true,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: const ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.HPU.WhaterFlowTrackingTimeout', 
          ),
          labelText: const Localized('Water flow tracking timeout').v,
          unitText: const Localized('ms').v,
          width: 350,
          showApplyButton: true,
        ),
      ],
    );
  }
}
