// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:va_monitoring/app_widget.dart';
import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/infrastructure/alarm/alarm_list_data_source.dart';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/settings/communication_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  testWidgets(
    'SignInPage', 
    (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final dsClient = DsClientReal(
      line: JdsLine(
        lineSocket: DsLineSocket(
          ip: AppCommunicationSettings.dsClientIp, 
          port: AppCommunicationSettings.dsClientPort,
        ),
      ),
    );
    final appThemeSwitch = AppThemeSwitch();
    await tester.pumpWidget(
      AppWidget(
          themeSwitch: appThemeSwitch,
          dsClient: dsClient, 
          alarmListData: AlarmListDataSource<AlarmListPoint>(
            stream: dsClient.streamMerged([
              'HPU.Pump1.Alarm',
              'HPU.Pump2.Alarm',
              'HPU.EmergencyHPU.Alarm',
              'HPU.OilTemp',
            ]),
          ),
      ),
    );
    // await tester.pump(const Duration(seconds: 3));
    // Wait for refresh indicator to stop spinning
    // await tester.pumpAndSettle();
    // await Future.delayed(const Duration(seconds: 3));
    // Verify that our counter starts at 0.
    // expect(find.text(const AppText('Authentication').local), findsOneWidget);
    // expect(find.text(const AppText('Crane monitoring').local), findsOneWidget);
    // expect(find.text(const AppText('Welcome').local), findsOneWidget);
    // expect(find.text(const AppText('Please authenticate to continue...').local), findsOneWidget);
    // expect(find.text(const AppText('Your login').local), findsOneWidget);
    // expect(find.text('1'), findsNothing);
    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  },);
}
