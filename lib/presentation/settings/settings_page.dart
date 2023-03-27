import 'package:va_monitoring/presentation/core/widgets/connection_status_indicator/connection_status_indicator.dart';
import 'package:va_monitoring/presentation/core/widgets/top_menu_bar.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/core/theme/app_theme_switch.dart';
import 'package:va_monitoring/presentation/settings/widgets/settings_basic_protections_tab.dart';
import 'package:va_monitoring/presentation/settings/widgets/settings_hpu_tab.dart';
import 'package:va_monitoring/presentation/settings/widgets/settings_main_boom_tab.dart';
import 'package:va_monitoring/presentation/settings/widgets/settings_main_winch_tab.dart';
import 'package:va_monitoring/presentation/settings/widgets/settings_rotary_boom_tab.dart';
import 'package:va_monitoring/presentation/settings/widgets/settings_rotation_tab.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class SettingsPage extends StatefulWidget {
  final AppUserStacked _users;
  final DsClient _dsClient;
  final AppThemeSwitch _themeSwitch;
  ///
  const SettingsPage({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
    required AppThemeSwitch themeSwitch,
  })  : _dsClient = dsClient,
        _users = users,
        _themeSwitch = themeSwitch,
        super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<SettingsPage> createState() => _SettingsPageState(
        dsClient: _dsClient,
        users: _users,
        themeSwitch: _themeSwitch,
      );
}

///
class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  static const _debug = true;
  final DsClient _dsClient;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  late TabController _tabController;
  int _prevTabIndex = -1;
  // late List<String> _statusList;
  ///
  _SettingsPageState({
    required DsClient dsClient,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  })  : _dsClient = dsClient,
        _users = users,
        _themeSwitch = themeSwitch,
        super();
  //
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });    
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (_dsClient.isConnected()) {
    //     _dsClient.requestAll();
    //   }
    // });
    _tabController = TabController(
      initialIndex: 0,
      length: 6,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_prevTabIndex != _tabController.index) {
        _prevTabIndex = _tabController.index;
        log(_debug, '[$_SettingsPageState._tabController.addListener] tabIndex: $_prevTabIndex',);
        if (_dsClient.isConnected()) {
          _dsClient.requestAll();
        }
      }
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    log(_debug, '[_SettingsPageState.build] user: ', user);
    // final userGroup = AppUserGroup('${user['group']}');
    return _buildScaffold(context);
  }
  ///
  Widget _buildScaffold(BuildContext context) {
    // final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    final tabTextStyle = Theme.of(context).textTheme.bodyMedium;
    final tabIconColor = Theme.of(context).colorScheme.onBackground;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.all(blockPadding),
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
        body: _buildTabControllerWidget(tabTextStyle, tabIconColor),
      ),
    );
  }
  ///
  DefaultTabController _buildTabControllerWidget(TextStyle? tabTextStyle, Color tabIconColor) {
    final floatingActionButtonSize = const Setting('floatingActionButtonSize').toDouble;
    return DefaultTabController(
      length: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: floatingActionButtonSize * 2,
                  right: floatingActionButtonSize * 2,
              ),
              child: _buildTabBar(tabTextStyle, tabIconColor),
          ),
          Flexible(
            child: _buildTabBarView(),
          ),
        ],
      ),
    );
  }
  ///
  TabBarView _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        SettingsBasicProtectionsTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsHpuTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsMainWinchTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsMainBoomTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsRotaryBoomTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsRotationTab(
          users: _users,
          dsClient: _dsClient,
        ),
      ],
    );
  }
  ///
  TabBar _buildTabBar(TextStyle? tabTextStyle, Color tabIconColor) {
    final tabNames = [
      {
        'text': const Localized('Basic protections'),
        'icon': Icon(Icons.settings_outlined, color: tabIconColor),
      },
      {
        'text': const Localized('HPU'),
        'icon': Icon(Icons.settings_outlined, color: tabIconColor),
      },
      {
        'text': const Localized('Winch 1'),
        'icon': ImageIcon(Image.asset('assets/icons/winch.png').image, color: tabIconColor),
      },
      {
        'text': const Localized('Main boom'),
        'icon': ImageIcon(Image.asset('assets/icons/main-boom.png').image, color: tabIconColor),
      },
      {
        'text': const Localized('Knuckle jib '),
        'icon': ImageIcon(Image.asset('assets/icons/rotary-boom.png').image, color: tabIconColor),
      },
      {
        'text': const Localized('Rotation'),
        'icon': Icon(Icons.settings_outlined, color: tabIconColor),
      },
    ];
    return TabBar(
      controller: _tabController,
      tabs: tabNames.map((e) {
        return Tab(
          icon: e['icon'] as Widget,
          child: Text('${e['text']}', textAlign: TextAlign.center, style: tabTextStyle),
        );
      }).toList(),
    );
  }
  //
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
