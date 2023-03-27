import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:va_monitoring/presentation/compensation/compensation_page.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/accumulator/accumulator_page.dart';
import 'package:va_monitoring/presentation/alarm/alarm_page.dart';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/presentation/diagnostic/diagnostic_page.dart';
import 'package:va_monitoring/presentation/event/event_page.dart';
import 'package:va_monitoring/presentation/home/home_page.dart';
import 'package:va_monitoring/presentation/hpu/hpu_page.dart';
import 'package:va_monitoring/presentation/winch_1/winch_1_page.dart';
import 'package:va_monitoring/presentation/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class MenuBody extends StatelessWidget {
  static final _log = const Log('MenuBody')..level = LogLevel.info;
  final AppUserStacked _users;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  final AppThemeSwitch _themeSwitch;
  /// 
  /// Builds home body using current user
  const MenuBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
    required AppThemeSwitch themeSwitch,
  }) : 
    _users = users,
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    _themeSwitch = themeSwitch,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    _log.debug('[.build]');
    final user = _users.peek;
    // final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    // const dropDownControlButtonWidth = 118.0;
    // const dropDownControlButtonHeight = 44.0;
    final buttonTextStyle = Theme.of(context).textTheme.titleLarge;
    final buttonStyle = const ButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
      minimumSize: MaterialStateProperty.all(const Size(240.0, 128.0)),
    );
    final isAdmin = user.userGroup().value == UserGroupList.admin;
    return StreamBuilder<List<dynamic>>(
      // stream: dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: () {
            return Future<List<String>>.value([]);
            // return source.refresh();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Row 1
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///
                    /// Экран | Домашний
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        _log.debug('Экран | Домашний pressed');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              users: _users,
                              dsClient: _dsClient, 
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/homePage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Main page').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    SizedBox(width: blockPadding),
                    ///
                    /// Экран | HPU
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HpuPage(
                              users: _users,
                              dsClient: _dsClient, 
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/hpuPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('HPU').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    SizedBox(width: blockPadding),
                    ///
                    /// Экран | Accumulator
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AccumulatorPage(
                              users: _users,
                              dsClient: _dsClient, 
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/acumulatorPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Accumulator').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    SizedBox(width: blockPadding),
                    ///
                    /// Экран | Main winch
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Winch1Page(
                              users: _users,
                              dsClient: _dsClient, 
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/mainWinchPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Main winch').v,
                        style: buttonTextStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: blockPadding),
                /// Row 2
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///
                    /// Экран | Аварии
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AlarmPage(
                              users: _users,
                              dsClient: _dsClient, 
                              listData: _alarmListData,
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/alarmPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Alarm page').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    SizedBox(width: blockPadding),
                    ///
                    /// Экран | События
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventPage(
                              users: _users,
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/eventPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Event page').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Уставки
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(
                              users: _users,
                              dsClient: _dsClient, 
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/settingsPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Settings page').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    SizedBox(width: blockPadding),
                    ///
                    /// Экран | Графики компенсации
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CompensationPage(
                              users: _users,
                              dsClient: _dsClient, 
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/compensationPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Heave compensation').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    ///
                    /// Экран | Настройки приложения
                    // ElevatedButton(
                    //   style: buttonStyle,
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => PreferencesPage(
                    //           users: _users,
                    //           dsClient: _dsClient, 
                    //           themeSwitch: _themeSwitch,
                    //         ),
                    //         settings: const RouteSettings(name: "/preferencesPage"),
                    //       ),
                    //     );
                    //   }, 
                    //   child: Text(
                    //     const Localized('Preferences page').v,
                    //     style: buttonTextStyle,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: blockPadding,),
                /// Row 3
                /// Only for Admin user group
                if (isAdmin) Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///
                    /// Экран | Диагностика связи
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DiagnosticPage(
                              users: _users,
                              dsClient: _dsClient, 
                              themeSwitch: _themeSwitch,
                            ),
                            settings: const RouteSettings(name: "/diagnosticPage"),
                          ),
                        );
                      }, 
                      child: Text(
                        const Localized('Connection diagnostics').v,
                        style: buttonTextStyle,
                      ),
                    ),
                    SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Резерв
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: null,
                      child: Text(
                        const Localized('Reserved').v,
                        style: buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  ///
  // Future<AuthResult> _authenticate(BuildContext context) {
  //   return Navigator.of(context).push<AuthResult>(
  //     MaterialPageRoute(
  //       builder: (context) => AuthDialog(
  //         key: UniqueKey(),
  //         currentUser: _users.peek,
  //       ),
  //       settings: const RouteSettings(name: "/authDialog"),
  //     ),
  //   ).then((authResult) {
  //     log(_debug, '[$MenuBody._authenticate] authResult: ', authResult);
  //     final result = authResult;
  //     if (result != null) {
  //       if (result.authenticated) {
  //         _users.push(result.user);
  //       }
  //       return result;
  //     }
  //     throw Failure.unexpected(
  //       message: 'Authentication error, null returned instead of AuthResult ', 
  //       stackTrace: StackTrace.current,
  //     );
  //   });    
  // }
}
