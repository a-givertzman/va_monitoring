import 'dart:math';
import 'package:va_monitoring/domain/crane/crane_mode_state.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/core/widgets/common_container_widget.dart';
import 'package:va_monitoring/presentation/home/widgets/crane_load_card.dart';
import 'package:va_monitoring/presentation/home/widgets/crane_mode_control_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class HomeBody extends StatelessWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  final DsClient _dsClient;
  final CraneModeState _craneModeState;
  /// 
  /// Builds home body using current user
  const HomeBody({
    Key? key,
    // required AppUserStacked users,
    required DsClient dsClient,
    required CraneModeState craneModeState,
  }) : 
    // _users = users,
    _dsClient = dsClient,
    _craneModeState = craneModeState,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$HomeBody.build]');
    // final user = _users.peek;
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    const dropDownControlButtonWidth = 118.0;
    const dropDownControlButtonHeight = 44.0;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final displaySizeWidth = const Setting('displaySizeWidth').toDouble;
    final displaySizeHeight = const Setting('displaySizeHeight').toDouble;
    final stateColors = Theme.of(context).stateColors;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Future.delayed(const Duration(seconds: 1), () {
      //   if (_dsClient.isConnected()) {
      //     _dsClient.requestAll();
      //   }
      // });
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });
    return Transform.scale(
      scale: min(
        width / displaySizeWidth, 
        height /displaySizeHeight,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Row 1
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Кнопки управления режимом
                CraneModeControlWidget(
                  dsClient: _dsClient,
                  craneModeState: _craneModeState,
                  buttonWidth: dropDownControlButtonWidth,
                  buttonHeight: dropDownControlButtonHeight,
                ),
                SizedBox(width: blockPadding,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Индикатор | Постоянное натяжение
                    StatusIndicatorWidget(
                      width: 150.0,
                      indicator: BoolColorIndicator(
                        // iconData: Icons.account_tree_outlined,
                        stream: _dsClient.streamBool('ConstantTension.Active'),
                      ), 
                      caption: Text(const Localized('Constant tension').v),
                    ),
                    /// Индикатор | Степень натяжения
                    TextIndicatorWidget(
                      width: 150.0 - 22.0,
                      indicator: TextValueIndicator(
                        stream: _dsClient.streamInt('ConstantTension.Level'),
                        valueUnit: '%',
                      ),
                      caption: Text(
                        const Localized('Tension factor').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),                      
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Постоянное натяжение | Убавить
                        ElevatedButton(
                          style: const ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(75.0, 50.0)),
                          ),
                          onPressed: () {
                            if (_craneModeState.constantTensionLevel > 0) {
                              DsSend<int>(
                                dsClient: _dsClient, 
                                pointName: DsPointName(
                                  '/line1/ied12/db902_panel_controls/Settings.CraneMode.ConstantTensionLevel', 
                                ),
                              ).exec(_craneModeState.constantTensionLevel.toInt() - 1);
                            }
                          }, 
                          child: Icon(
                            Icons.remove, 
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        SizedBox(width: padding,),
                        /// Постоянное натяжение | Прибавить
                        ElevatedButton(
                          style: const ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(75.0, 50.0)),
                          ),
                          onPressed: () {
                            if (_craneModeState.constantTensionLevel < 100) {
                              DsSend<int>(
                                dsClient: _dsClient, 
                                pointName: DsPointName(
                                  '/line1/ied12/db902_panel_controls/Settings.CraneMode.ConstantTensionLevel', 
                                ),
                              ).exec(_craneModeState.constantTensionLevel.toInt() + 1);
                            }
                          }, 
                          child: Icon(
                            Icons.add, 
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3,),
                  ],
                ),
                SizedBox(width: blockPadding * 3,),
                Image.asset(
                  'assets/img/brand_icon.png',
                  scale: 4.0,
                  opacity: const AlwaysStoppedAnimation<double>(0.2),
                ),
                SizedBox(width: blockPadding * 3,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Скорость ветра
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextValueIndicator(
                        stream: _dsClient.streamReal('Crane.Wind'),
                        fractionDigits: 2,
                        valueUnit: const Localized('m/c').v,
                      ),
                      caption: Text(
                        const Localized('Wind').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                    ///  Температура масла
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextValueIndicator(
                        stream: _dsClient.streamReal('HPU.OilTemp'),
                        fractionDigits: 0,
                        valueUnit: '℃',
                      ),
                      caption: Text(
                        const Localized('Oil temp').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                  ],
                ),
                SizedBox(width: blockPadding,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Дифферент/ Pitch
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextValueIndicator(
                        stream: _dsClient.streamReal('Crane.Pitch'),
                        fractionDigits: 2,
                        valueUnit: 'º',
                      ),
                      caption: Text(
                        const Localized('Pitch').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                    /// Крен / Roll
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextValueIndicator(
                        stream: _dsClient.streamReal('Crane.Roll'),
                        fractionDigits: 2,
                        valueUnit: 'º',
                      ),
                      caption: Text(
                        const Localized('Roll').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: blockPadding,),
            /// Row 2
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.CraneOffshore'),
                  ), 
                  caption: Text(const Localized('Offshore').v),
                ),
                // SizedBox(width: padding,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.ParkingModeActive'),
                  ), 
                  caption: Text(const Localized('Parking').v),
                ),
                SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.MOPS'),
                  ), 
                  caption: Text(const Localized('MOPS').v),
                ),
                SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.AOPS'),
                  ), 
                  caption: Text(const Localized('AOPS').v),
                ),
                SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.AHC'),
                  ), 
                  caption: Text(const Localized('АHC').v),
                ),
                SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.WinchBrake'),
                  ), 
                  caption: Text(const Localized('Brake').v),
                ),
                SizedBox(width: padding * 2,),
                /// Индикатор | HPU
                Tooltip(
                  message: const Localized('Hydraulic power unit').v,
                  child: StatusIndicatorWidget(
                    indicator: DpsIconIndicator(
                      key: const GlobalObjectKey('HPU.Pump12.State'),
                      stream: StreamMerged<DsDataPoint<int>>([
                        _dsClient.streamInt('HPU.Pump1.State'),
                        _dsClient.streamInt('HPU.Pump2.State'),
                      ], handler: (values) {
                        return _buildHpuPumpStateValue(values[0]?.value, values[1]?.value);
                      },).stream,
                    ), 
                    caption: Text(const Localized('HPU').v),
                  ),
                ),                
                /// Индикатор | HPUR
                Tooltip(
                  message: const Localized('Emergency hydraulic power unit').v,
                  child: StatusIndicatorWidget(
                    indicator: DpsIconIndicator(
                      key: const GlobalObjectKey('HPU.EmergencyHPU.State'),
                      stream: _dsClient.streamInt('HPU.EmergencyHPU.State'),
                    ), 
                    caption: Text(const Localized('HPUR').v),
                  ),
                ),                
                // AlarmedStatusIndicatorWidget(
                //   stateIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).primaryColor,
                //     stream: StreamMergedOr([
                //       _dsClient.streamBool('HPU.Pump1.Active'),
                //       _dsClient.streamBool('HPU.Pump2.Active'),
                //     ]).stream,
                //   ),
                //   alarmIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).highColor,
                //     falseColor: Colors.transparent,
                //     stream: StreamMergedOr([
                //       _dsClient.streamBool('HPU.Pump1.Alarm'),
                //       _dsClient.streamBool('HPU.Pump2.Alarm'),
                //     ]).stream,
                //   ), 
                //   caption: Text(const Localized('HPU')),.v 
                // ),
                // AlarmedStatusIndicatorWidget(
                //   stateIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).primaryColor,
                //     stream: _dsClient.streamBool('HPU.EmergencyHPU.Active'),
                //   ),
                //   alarmIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).highColor,
                //     falseColor: Colors.transparent,
                //     stream: _dsClient.streamBool('HPU.EmergencyHPU.Alarm'),
                //   ), 
                //   caption: Text(const Localized('HPUR')),.v 
                // ),
                // SizedBox(width: padding * 2,),
                // /// Индикатор | Связь
                // StatusIndicatorWidget(
                //   indicator: SpsIconIndicator(
                //     trueIcon: Icon(Icons.account_tree_sharp, color: stateColors.on),
                //     falseIcon: Icon(Icons.account_tree_outlined, color: stateColors.off),
                //     stream: _dsClient.streamBool('Local.System.Connection')
                //       .map((event) {
                //         log(_debug, '[$HomeBody] Local.System.Connection: ', event.value);
                //         return event;
                //       }),
                //   ), 
                //   caption: Text(const Localized('Connection')),.v 
                // ),
              ],
            ),
            SizedBox(height: blockPadding,),
            /// Row 3
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Row 3 | Column 1
                Column(children: [
                  TextIndicatorWidget(
                    width: 216,
                    indicator: TextValueIndicator(
                      stream: _dsClient.streamReal('Winch1.SWL'),
                      fractionDigits: 1,
                      valueUnit: const Localized('t').v,
                    ),
                    caption: Text(
                      const Localized('SWL').v,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    alignment: Alignment.centerLeft, 
                  ),
                  TextIndicatorWidget(
                    width: 216,
                    indicator: TextValueIndicator(
                      stream: _dsClient.streamReal('Winch1.Load'),
                      fractionDigits: 1,
                      valueUnit: const Localized('t').v,
                    ),
                    caption: Text(
                      const Localized('Load').v,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    alignment: Alignment.centerLeft, 
                  ),
                  InvalidStatusIndicator(
                    stream: _loadFactorStream([
                      _dsClient.streamReal('Winch1.SWL'),
                      _dsClient.streamReal('Winch1.Load'),
                    ]),
                    stateColors: stateColors,
                    child: CommonContainerWidget(
                      header: Text(
                        const Localized('% of SWL').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      children: [CircularValueIndicator(
                        low: 20,
                        high: 80,
                        stream: _loadFactorStream([
                          _dsClient.streamReal('Winch1.SWL'),
                          _dsClient.streamReal('Winch1.Load'),
                        ]),
                        valueUnit: '%',
                        size: 200.0,
                      ),],
                    ),
                  ),
                ],),
                SizedBox(width: blockPadding,),
                /// Row 3 | Column 2
                CraneLoadCard(
                  dsClient: _dsClient,
                  swlData: SwlData(
                    xCsvFile: const TextFile.asset('assets/swl/x.csv'),
                    yCsvFile: const TextFile.asset('assets/swl/y.csv'),
                    swlCsvFiles: const [
                      TextFile.asset('assets/swl/swl_0.csv'),
                      TextFile.asset('assets/swl/swl_1.csv'),
                    ],
                  ),
                ),
                SizedBox(width: blockPadding,),
                /// Row 3 | Column 1 | Row 1 | Column 2
                Column(children: [
                    Tooltip(
                      message: const Localized('Absolute depth').v,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextValueIndicator(
                          key: const GlobalObjectKey('Crane.Depth'),
                          stream: _dsClient.streamReal('Crane.Depth'),
                          valueUnit: const Localized('m').v,
                          fractionDigits: 1,
                        ),
                        caption: Text(
                          const Localized('Depth abs').v,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    /// Относительная глубина | Индикатор
                    Row(
                      children: [
                        Tooltip(
                          message: const Localized('Relative depth').v,
                          child: TextIndicatorWidget(
                            width: 216 - 48 * 2 + padding,
                            indicator: TextValueIndicator(
                              key: const GlobalObjectKey('Crane.DeckDepth'),
                              stream: _dsClient.streamReal('Crane.DeckDepth'),
                              valueUnit: const Localized('m').v,
                              fractionDigits: 1,
                            ),
                            caption: Text(
                              const Localized('Rel depth').v,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            alignment: Alignment.centerLeft, 
                          ),
                        ),
                        /// Относительная глубина | Установить
                        ElevatedButton(
                          style: const ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            maximumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          onPressed: () {
                            DsSend<int>(
                              dsClient: _dsClient, 
                              pointName: DsPointName(
                                '/line1/ied12/db902_panel_controls/Settings.CraneMode.SetRelativeDepth', 
                              ),
                            ).exec(1);
                          }, 
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        SizedBox(width: padding * 0.5),
                        /// Относительная глубина | Сбросить
                        ElevatedButton(
                          style: const ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            maximumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          onPressed: () {
                            DsSend<int>(
                              dsClient: _dsClient, 
                              pointName: DsPointName(
                                '/line1/ied12/db902_panel_controls/Settings.CraneMode.ResetRelativeDepth', 
                              ),
                            ).exec(1);                          }, 
                          child: Icon(
                            Icons.cancel_outlined, 
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        SizedBox(width: padding * 0.5),
                      ],
                    ),
                    TextIndicatorWidget(
                      width: 216,
                      indicator: TextValueIndicator(
                        stream: _dsClient.streamReal('Hook.Speed'),
                        valueUnit: const Localized('m/min').v,
                        fractionDigits: 1,
                      ),
                      caption: Text(
                        const Localized('Hook speed').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.centerLeft, 
                    ),
                    // Row(
                    //   children: [
                    //     /// Индикатор | Скорость высокая
                    //     SingleStatusIndicatorWidget(
                    //     width: 118.0,
                    //       indicator: BoolColorIndicator(
                    //         trueColor: Theme.of(context).highColor,
                    //         stream: _dsClient.streamBool('Other.Hook.HighSpeed'),
                    //       ), 
                    //       caption: Text(const Localized('High')),.v 
                    //     ),
                    //     /// Индикатор | Скорость посадочная
                    //     SingleStatusIndicatorWidget(
                    //       width: 118.0,
                    //       indicator: BoolColorIndicator(
                    //         stream: _dsClient.streamBool('Other.Hook.LandingSpeed'),
                    //       ), 
                    //       caption: Text(const Localized('Landing')),.v 
                    //     ),
                    //   ],
                    // ),                          
                    SizedBox(height: blockPadding,),
                    Tooltip(
                      message: const Localized('Main boom angle').v,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextValueIndicator(
                          key: const GlobalObjectKey('Crane.BoomAngle'),
                          stream: _dsClient.streamReal('Crane.BoomAngle'),
                          valueUnit: const Localized('º').v,
                        ),
                        caption: Text(
                          const Localized('Main boom').v,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    Tooltip(
                      message: const Localized('Knuckle jib angle').v,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextValueIndicator(
                          key: const GlobalObjectKey('Crane.JibAngle'),
                          stream: _dsClient.streamReal('Crane.JibAngle'),
                          valueUnit: const Localized('º').v,
                        ),
                        caption: Text(
                          const Localized('Knuckle jib').v,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    Tooltip(
                      message: const Localized('Crane slewing angle').v,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextValueIndicator(
                          key: const GlobalObjectKey('Crane.Slewing'),
                          stream: _dsClient.streamReal('Crane.Slewing'),
                          valueUnit: const Localized('º').v,
                        ),
                        caption: Text(
                          const Localized('Slewing').v,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    TextIndicatorWidget(
                      width: 216,
                      indicator: TextValueIndicator(
                        stream: _dsClient.streamReal('Crane.Radius'),
                        valueUnit: const Localized('m').v,
                      ),
                      caption: Text(
                        const Localized('Radius').v,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.centerLeft, 
                    ),
                ],),
              ],
            ),
          ],
        ),
      ),
    );
  }
  ///
  Stream<DsDataPoint<double>> _loadFactorStream(List<Stream<DsDataPoint<double>>> streams) {
    return StreamMerged<DsDataPoint<double>>(
      streams, 
      handler: (values) {
        final winch1SwlValue = values[0];
        final winch1LoadValue = values[1];
        if (
          winch1SwlValue != null && winch1LoadValue != null 
          && winch1SwlValue.value.isFinite && winch1LoadValue.value.isFinite 
          && winch1SwlValue.value != 0
        ) {
          return DsDataPoint(
            type: DsDataType.real,
            name: DsPointName('/'),
            value: 100 * (winch1LoadValue.value / winch1SwlValue.value),
            status: winch1LoadValue.status,
            timestamp: DateTime.now().toIso8601String(),
          );
        }
        return DsDataPoint(
          type: DsDataType.real,
          name: DsPointName('/'),
          value: 0.0,
          status: DsStatus.invalid,
          timestamp: DateTime.now().toIso8601String(),
        );
      },
    ).stream;
  }
  ///
  DsDataPoint<int> _buildHpuPumpStateValue(
    int? pump1State, 
    int? pump2State,
  ) {
    int value = 0;
    if (pump1State != null && pump2State != null) {
      if (pump1State == 1 && pump2State == 1) {
        value = 1;
      }
      if (pump1State == 2 || pump2State == 2) {
        value = 2;
      }
      if (pump1State == 0 || pump2State == 0) {
        value = 0;
      }
      if (pump1State == 3 || pump2State == 3) {
        value = 3;
      }
    }
    return DsDataPoint<int>(
      type: DsDataType.integer, 
      name: DsPointName('/'), 
      value: value, 
      status: DsStatus.ok, 
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
