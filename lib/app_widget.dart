import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:va_monitoring/presentation/home/home_page.dart';
import 'package:va_monitoring/presentation/menu/menu_page.dart';
import 'package:window_manager/window_manager.dart';

///
class AppWidget extends StatefulWidget {
  final DsClient _dsClient;
  final AppThemeSwitch _themeSwitch;
  final EventListData<AlarmListPoint> _alarmListData;
  ///
  const AppWidget({
    Key? key,
    required AppThemeSwitch themeSwitch,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
  }) : 
    _themeSwitch = themeSwitch,
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    super(key: key);
  //
  @override
  State<AppWidget> createState() => _AppWidgetState(
    themeSwitch: _themeSwitch,
    dsClient: _dsClient,
    alarmListData: _alarmListData,
  );
}

///
class _AppWidgetState extends State<AppWidget> {
  final AppThemeSwitch _themeSwitch;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(debugLabel: 'ScaffoldMessengerState');
  ///
  _AppWidgetState({
    required AppThemeSwitch themeSwitch,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
  }) : 
    _themeSwitch = themeSwitch,
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    super();
  //
  @override
  void dispose() {
    _themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
  }
  //
  @override
  void initState() {
    super.initState();
    _themeSwitch.addListener(_themeSwitchListener);
    Future.delayed(
      Duration.zero,
      () async {
        await windowManager.ensureInitialized();
        windowManager.setFullScreen(true);
        windowManager.setTitleBarStyle(TitleBarStyle.hidden);
        windowManager.setBackgroundColor(Colors.transparent);
        // windowManager.setSize(const Size(1024, 768));
        // windowManager.center();
        windowManager.focus();
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {true;}));
      },
    );
  }
  ///
  void _themeSwitchListener() {
    if (mounted) {
      setState(() {true;});
    }
  }
  //
  @override
  Widget build(BuildContext context) {
    final homePage = MenuPage(
      users: AppUserStacked(
        appUser: AppUserSingle.guest(),
      ), 
      themeSwitch: _themeSwitch,
      dsClient: _dsClient,
      alarmListData: _alarmListData,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage,
      initialRoute: '/signInPage',
      routes: {
        '/signInPage': (context) => homePage,
      },
      theme: _themeSwitch.themeData,
      scaffoldMessengerKey: _scaffoldMessengerKey,
    );
  }
}
