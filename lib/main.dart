import 'dart:async';
import 'package:va_monitoring/app_widget.dart';
import 'package:va_monitoring/domain/alarm/alarm_data.dart';
import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/domain/core/debug_stream_events.dart';
import 'package:va_monitoring/infrastructure/alarm/alarm_list_data_source.dart';
import 'package:va_monitoring/infrastructure/datasource/app_data_source_map.dart';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/settings/communication_settings.dart';
import 'package:flutter/material.dart' hide Localizations;
import 'package:flutter/rendering.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

Future<void> main() async {
  debugRepaintRainbowEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  Log.initialize(level: LogLevel.all);
  await Localizations.initialize(
    AppLang.ru,
    jsonMap: JsonMap.fromTextFile(
      const TextFile.asset('assets/translations/translations.json'),
    ),
  );
  DataSource.initialize(dataSourceMap);
  await AppSettings.initialize(
    jsonMap: JsonMap.fromTextFile(
      const TextFile.asset(
        'assets/settings/app-settings.json',
      ),
    ),
  );
  runZonedGuarded(
    () async {
      // final _dsClient = DsClientEmulate(
      final dsClient = DsClientReal(
        line: JdsLine(
          lineSocket: DsLineSocket(
            ip: AppCommunicationSettings.dsClientIp, 
            port: AppCommunicationSettings.dsClientPort,
          ),
        ),
      );
      DebugStreamEvents(stream: dsClient.streamMerged([
          // 'CraneMode.WaveHeightLevel',
          // 'HPU.OilLevel',
          'system.db902_panel_controls.status',
          'system.db905_visual_data_fast.status',
          'system.db906_visual_data.status',
          // 'HPU.OilTemp',
        ])).run();
      // setupDsClientEmulate(_dsClient);
      final appThemeSwitch = AppThemeSwitch();
      runApp(
        AppWidget(
          themeSwitch: appThemeSwitch,
          dsClient: dsClient,
          alarmListData: AlarmListDataSource<AlarmListPoint>(
            stream: dsClient.streamMerged(
              await AlarmData(assetName: 'assets/alarm/alarm-list.json').names(),
            ),
          ),
        ),
      );
    },
    (error, stackTrace) {
      final trace = stackTrace.toString().isEmpty ? StackTrace.current : stackTrace.toString();
      const Log('main').error('message: $error\nstackTrace: $trace'); 
    },
  );
}
///
///
/// настраивает эмулятор сервера потока данных
// void setupDsClientEmulate(DsClientEmulate _dsClient) {
//   _dsClient.streamEmulatedInt('CraneMode.MainMode',
//     firstEventDelay: 5000,
//     delay: 10000,
//     // min: 0,
//     max: 2,
//   );
//               // 'CraneMode.ActiveWinch',
//   _dsClient.streamEmulatedInt('CraneMode.Winch1Mode',
//     firstEventDelay: 5000,
//     delay: 5000,
//     // min: 0,
//     max: 3,
//   );
//               // 'CraneMode.Winch1Mode',
//               // 'CraneMode.Winch2Mode',
//               // 'CraneMode.Winch3Mode',
//   _dsClient.streamEmulatedInt('CraneMode.waveHeightLevel',
//     firstEventDelay: 2000,
//     delay: 3000,
//     // min: 0,
//     max: 3,
//   );
//   _dsClient.streamEmulatedInt('CraneMode.ConstantTensionLevel',
//     firstEventDelay: 2000,
//     delay: 3000,
//     min: -1,
//     max: 10,
//   );
// }
