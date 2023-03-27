import 'dart:math';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/core/widgets/common_container_widget.dart';
import 'package:va_monitoring/presentation/hpu/widgets/hpu_double_pump_widget.dart';
import 'package:va_monitoring/presentation/hpu/widgets/hpu_pump_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class HpuBody extends StatelessWidget {
  static const _debug = true;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const HpuBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$HpuBody.build]');
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final displaySizeWidth = const Setting('displaySizeWidth').toDouble;
    final displaySizeHeight = const Setting('displaySizeHeight').toDouble;
    final stateColors = Theme.of(context).stateColors;
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
    return Transform.scale(
      scale: min(
        width / displaySizeWidth, 
        height /displaySizeHeight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Индикаторы | Уровень и температура масла
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/brand_icon.png',
                    scale: 4.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.2),
                  ),
                  SizedBox(height: blockPadding,),
                  Text(const Localized('Hydraulic tank').v),
                  SizedBox(height: padding,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 80.0,),
                          /// Индикатор | Высокий уровень масла
                          Tooltip(
                            message: const Localized('High oil level').v,
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: const GlobalObjectKey('HPU.HighOilLevel'),
                                stream: _dsClient.streamBool('HPU.HighOilLevel'),
                                trueColor: stateColors.lowLevel,
                              ), 
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          /// Индикатор | Низкий уровень масла
                          Tooltip(
                            message: const Localized('Low oil level').v,
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: const GlobalObjectKey('HPU.LowOilLevel'),
                                stream: _dsClient.streamBool('HPU.LowOilLevel'),
                                trueColor: stateColors.lowLevel,
                              ), 
                            ),
                          ),
                          /// Индикатор | Аварийно низкий уровень масла
                          Tooltip(
                            message: const Localized('Emergency low oil level').v,
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: const GlobalObjectKey('HPU.AlarmLowOilLevel'),
                                stream: _dsClient.streamBool('HPU.AlarmLowOilLevel'),
                                trueColor: stateColors.alarmLowLevel,
                              ), 
                            ),
                          ),
                        ],
                      ),
                      InvalidStatusIndicator(
                        stream: _dsClient.streamReal('HPU.OilLevel'),
                        stateColors: stateColors,
                        child: CommonContainerWidget(
                          header: Text(
                            const Localized('Oil level').v.replaceAll(' ', '\n'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          children: [
                            LinearValueIndicator(
                              title: const Localized('%').v,
                              angle: 90.0,
                              indicatorLength: 200.0 - 14 - blockPadding - padding,
                              strokeWidth: 36.0,
                              stream: _dsClient.streamReal('HPU.OilLevel'),
                            ),
                          ],
                        ),
                      ),
                      InvalidStatusIndicator(
                        stream: _dsClient.streamReal('HPU.OilTemp'),
                        stateColors: stateColors,
                        child: CommonContainerWidget(
                          header: Text(
                            '${const Localized('Temp').v}\n',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          children: [
                            LinearValueIndicator(
                              title: const Localized('℃').v,
                              min: 0,
                              max: 80,
                              angle: 90.0,
                              indicatorLength: 200.0 - 14 - blockPadding - padding,
                              strokeWidth: 24.0,
                              stream: _dsClient.streamReal('HPU.OilTemp'),
                          ),
                        ],),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 80.0,),
                          Tooltip(
                            message: const Localized('Emergency high oil temperature').v,
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: const GlobalObjectKey('HPU.AlarmHighOilTemp'),
                                stream: _dsClient.streamBool('HPU.AlarmHighOilTemp'),
                                trueColor: stateColors.alarmHighLevel,
                              ), 
                            ),
                          ),
                          /// Индикатор | Высокая температура масла
                          Tooltip(
                            message: const Localized('High oil temperature').v,
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: const GlobalObjectKey('HPU.HighOilTemp'),
                                stream: _dsClient.streamBool('HPU.HighOilTemp'),
                                trueColor: stateColors.highLevel,
                              ), 
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          /// Индикатор | Низкая температура масла
                          const SizedBox(height: 46.0,),
                          // Tooltip(
                          //   child: StatusIndicatorWidget(
                          //     indicator: BoolColorIndicator(
                          //       key: GlobalObjectKey('HPU.LowOilTemp'),
                          //       stream: _dsClient.streamBool('HPU.LowOilTemp'),
                          //       trueColor: stateColors.lowLevel,
                          //     ), 
                          //   ),
                          //   message: const Localized('Low oil temperature').v,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: blockPadding * 4.5,),
              /// Блок | Компрессор с приводом 1
              HpuDoublePumpWidget(
                inUseStream: _dsClient.streamInt('Settings.HPU.Pump1InUse'),
                driveStream: _dsClient.streamInt('HPU.Pump1.State'),
                presure1Stream: _dsClient.streamReal('HPU.PressureOutPump1'),
                presure2Stream: _dsClient.streamReal('HPU.PressureInPump1'),
                caption: Text(const Localized('HPU 1').v),
                driveCaption: const Localized('M1').v,
                pump1Caption: const Localized('P1.1').v,
                pump2Caption: const Localized('P1.2').v,
                onChanged: (value) {
                  DsSend<int>(
                    dsClient: _dsClient, 
                    pointName: DsPointName(
                      '/line1/ied12/db902_panel_controls/Settings.HPU.Pump1InUse',
                    ),
                  ).exec(value);
                },
              ),
              SizedBox(width: blockPadding * 4.5,),
              /// Блок | Компрессор с приводом 2
              HpuDoublePumpWidget(
                inUseStream: _dsClient.streamInt('Settings.HPU.Pump2InUse'),
                driveStream: _dsClient.streamInt('HPU.Pump2.State'),
                presure1Stream: _dsClient.streamReal('HPU.PressureOutPump2'),
                presure2Stream: _dsClient.streamReal('HPU.PressureInPump2'),
                caption: Text(const Localized('HPU 2').v),
                driveCaption: const Localized('M2').v,
                pump1Caption: const Localized('P2.1').v,
                pump2Caption: const Localized('P2.2').v,
                onChanged: (value) {
                  DsSend<int>(
                    dsClient: _dsClient, 
                    pointName: DsPointName(
                      '/line1/ied12/db902_panel_controls/Settings.HPU.Pump2InUse',
                    ),
                  ).exec(value);
                },
              ),
              SizedBox(width: blockPadding * 4.5,),
              /// Блок | Компрессор с приводом резервный
              HpuPumpWidget(
                stream: _dsClient.streamInt('HPU.EmergencyHPU.State'),
                caption: Text(const Localized('Emergency HPU').v),
                driveCaption: const Localized('M3').v,
                pumpCaption: const Localized('P3').v,
              ),
            ],
          ),
          SizedBox(height: blockPadding * 4.5),
          /// Блок | Теплообменник
          Text(const Localized('Cooler').v),
          SizedBox(height: padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonContainerWidget(
                header: Text(
                  const Localized('Pressure').v,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularValueIndicator(
                    min: 0,
                    max: 20,
                    size: 50.0,
                    valueUnit: 'bar',
                    stream: _dsClient.streamReal('HPU.CoolerPressureIn'),
                  ),
                ],
              ),
              SizedBox(width: blockPadding,),
              CommonContainerWidget(
                header: Text(
                  const Localized('Temp').v,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularValueIndicator(
                    min: -20,
                    max: 60,
                    size: 50.0,
                    valueUnit: '℃',
                    stream: _dsClient.streamReal('HPU.CoolerTemperatureIn'),
                  ),
                ],
              ),
              SizedBox(width: blockPadding,),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/icons/heat-exchanger.png',
                    width: 100.0 - padding * 2,
                    height: 100.0 - padding * 2,
                    color: Theme.of(context).colorScheme.tertiary,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                    // color: Colors.blueAccent,
                  ),
                  // Text(_pump1Caption, textAlign: TextAlign.center),
                ],
              ),
            ),
              SizedBox(width: blockPadding,),
              CommonContainerWidget(
                disabled: false,
                // disabled: !_inUse,
                header: Text(
                  const Localized('Pressure').v,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularValueIndicator(
                    min: 0,
                    max: 20,
                    size: 50.0,
                    valueUnit: 'bar',
                    stream: _dsClient.streamReal('HPU.CoolerPressureOut'),
                  ),
                ],
              ),
              SizedBox(width: blockPadding,),
              CommonContainerWidget(
                disabled: false,
                // disabled: !_inUse,
                header: Text(
                  const Localized('Temp').v,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularValueIndicator(
                    min: -20,
                    max: 60,
                    size: 50.0,
                    valueUnit: '℃',
                    stream: _dsClient.streamReal('HPU.CoolerTemperatureOut'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
