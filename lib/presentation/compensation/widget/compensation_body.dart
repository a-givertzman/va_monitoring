import 'package:va_monitoring/presentation/core/widgets/common_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class CompensationBody extends StatelessWidget {
  final DsClient _dsClient;
  ///
  const CompensationBody({
    super.key,
    required DsClient dsClient,
  }) : 
    _dsClient = dsClient;
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    final cardPadding = EdgeInsets.all(const Setting('padding').toDouble);
    const infoFieldWidth = 135.0;
    const infoFieldAlignment = Alignment.topRight;
    const statusIndicatorsWidth = 105.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });    
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
                Expanded(
                  child: Card(
                    margin: cardPadding,
                    child: Padding(
                      padding: cardPadding,
                      child: LiveChartWidget(
                        axes: [
                          // LiveAxis(
                          //   stream: _dsClient.streamReal('Platform.i'),
                          //   signalName: 'Platform.i', 
                          //   caption: const Localized('i').v,
                          //   color: Colors.blue,
                          //   bufferLength: 16384,
                          // ),
                          LiveAxis(
                            stream: _dsClient.streamReal('Platform.phi'),
                            signalName: 'Platform.phi', 
                            caption: const Localized('phi').v,
                            color: Colors.lightGreenAccent,
                            bufferLength: 16384,
                          ),
                          // LiveAxis(
                          //   stream: _dsClient.streamReal('Platform.sin'),
                          //   signalName: 'Platform.sin',
                          //   caption: const Localized('sin').v, 
                          //   color: Colors.green,
                          //   bufferLength: 16384,
                          // ),
                        ],
                        legendWidth: 240,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
                Expanded(
                  child: Card(
                    margin: cardPadding,
                    child: Padding(
                      padding: cardPadding,
                      child: LiveChartWidget(
                        axes: [
                          // LiveAxis(
                          //   stream: _dsClient.streamReal('Platform.i'),
                          //   signalName: 'Platform.i', 
                          //   caption: const Localized('i').v,
                          //   color: Colors.blue,
                          //   bufferLength: 16384,
                          // ),
                          // LiveAxis(
                          //   stream: _dsClient.streamReal('Platform.phi'),
                          //   signalName: 'Platform.phi', 
                          //   caption: const Localized('phi').v,
                          //   color: Colors.lightGreenAccent,
                          //   bufferLength: 16384,
                          // ),
                          LiveAxis(
                            stream: _dsClient.streamReal('Platform.sin'),
                            signalName: 'Platform.sin',
                            caption: const Localized('sin').v, 
                            color: Colors.green,
                            bufferLength: 16384,
                          ),
                        ],
                        legendWidth: 240,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     SizedBox(width: blockPadding),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         TextIndicatorWidget(
        //           width: infoFieldWidth,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('Winch1.SWL'),
        //             fractionDigits: 1,
        //             valueUnit: const Localized('t').v,
        //           ),
        //           caption: Text(
        //             const Localized('SWL').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: infoFieldAlignment, 
        //         ),
        //         TextIndicatorWidget(
        //           width: infoFieldWidth,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('Winch1.Load'),
        //             fractionDigits: 1,
        //             valueUnit: const Localized('t').v,
        //           ),
        //           caption: Text(
        //             const Localized('Load').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: infoFieldAlignment, 
        //         ),
        //         TextIndicatorWidget(
        //           width: infoFieldWidth,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('HPU.OilTemp'),
        //             fractionDigits: 0,
        //             valueUnit: '℃',
        //           ),
        //           caption: Text(
        //             const Localized('Oil temp').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: infoFieldAlignment, 
        //         ),
        //       ],
        //     ),
        //     SizedBox(width: blockPadding),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         InvalidStatusIndicator(
        //           stream: _loadFactorStream([
        //             _dsClient.streamReal('Winch1.SWL'),
        //             _dsClient.streamReal('Winch1.Load'),
        //           ]),
        //           stateColors: Theme.of(context).stateColors,
        //           child: CommonContainerWidget(
        //             header: Text(
        //               const Localized('% of SWL').v,
        //               style: Theme.of(context).textTheme.bodySmall,
        //               textAlign: TextAlign.center,
        //             ),
        //             children: [
        //               CircularValueIndicator(
        //                 size: 135,
        //                 low: 20,
        //                 high: 80,
        //                 valueUnit: '%',
        //                 stream: _loadFactorStream([
        //                   _dsClient.streamReal('Winch1.SWL'),
        //                   _dsClient.streamReal('Winch1.Load'),
        //                 ]),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //     SizedBox(width: blockPadding),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Row(
        //           children: [
        //             StatusIndicatorWidget(
        //               width: statusIndicatorsWidth,
        //               indicator: BoolColorIndicator(
        //                 stream: _dsClient.streamBool('CraneMode.MOPS'),
        //               ), 
        //               caption: Text(const Localized('MOPS').v),
        //             ),
        //             StatusIndicatorWidget(
        //               width: statusIndicatorsWidth,
        //               indicator: BoolColorIndicator(
        //                 stream: _dsClient.streamBool('CraneMode.AOPS'),
        //               ), 
        //               caption: Text(const Localized('AOPS').v),
        //             ),
        //           ],
        //         ),
        //         Row(
        //           children: [
        //             StatusIndicatorWidget(
        //               width: statusIndicatorsWidth,
        //               indicator: BoolColorIndicator(
        //                 stream: _dsClient.streamBool('CraneMode.AHC'),
        //               ), 
        //               caption: Text(const Localized('АHC').v),
        //             ),
        //             StatusIndicatorWidget(
        //               width: statusIndicatorsWidth,
        //               indicator: BoolColorIndicator(
        //                 stream: _dsClient.streamBool('CraneMode.WinchBrake'),
        //               ), 
        //               caption: Text(const Localized('Brake').v),
        //             ),     
        //           ],
        //         ),
        //         Row(
        //           children: [
        //             Tooltip(
        //               message: const Localized('Hydraulic power unit').v,
        //               child: StatusIndicatorWidget(
        //                 width: statusIndicatorsWidth,
        //                 indicator: DpsIconIndicator(
        //                   key: const GlobalObjectKey('HPU.Pump12.State'),
        //                   stream: StreamMerged<DsDataPoint<int>>([
        //                     _dsClient.streamInt('HPU.Pump1.State'),
        //                     _dsClient.streamInt('HPU.Pump2.State'),
        //                   ], handler: (values) {
        //                     return _buildHpuPumpStateValue(values[0]?.value, values[1]?.value);
        //                   },).stream,
        //                 ), 
        //                 caption: Text(const Localized('HPU').v),
        //               ),
        //             ),                
        //             Tooltip(
        //               message: const Localized('Emergency hydraulic power unit').v,
        //               child: StatusIndicatorWidget(
        //                 width: statusIndicatorsWidth,
        //                 indicator: DpsIconIndicator(
        //                   key: const GlobalObjectKey('HPU.EmergencyHPU.State'),
        //                   stream: _dsClient.streamInt('HPU.EmergencyHPU.State'),
        //                 ), 
        //                 caption: Text(const Localized('HPUR').v),
        //               ),
        //             ),           
        //           ],  
        //         ),
        //         TextIndicatorWidget(
        //           width: 188,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('Crane.Radius'),
        //             valueUnit: const Localized('m').v,
        //           ),
        //           caption: Text(
        //             const Localized('Radius').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: Alignment.centerLeft, 
        //         ),
        //       ],
        //     ),
        //     SizedBox(width: blockPadding),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         TextIndicatorWidget(
        //           width: infoFieldWidth,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('Crane.Wind'),
        //             fractionDigits: 2,
        //             valueUnit: const Localized('m/c').v,
        //           ),
        //           caption: Text(
        //             const Localized('Wind').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: infoFieldAlignment, 
        //         ),
        //         TextIndicatorWidget(
        //           width: infoFieldWidth,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('Crane.Pitch'),
        //             fractionDigits: 2,
        //             valueUnit: 'º',
        //           ),
        //           caption: Text(
        //             const Localized('Pitch').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: infoFieldAlignment, 
        //         ),
        //         TextIndicatorWidget(
        //           width: infoFieldWidth,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('Crane.Roll'),
        //             fractionDigits: 2,
        //             valueUnit: 'º',
        //           ),
        //           caption: Text(
        //             const Localized('Roll').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: infoFieldAlignment, 
        //         ),
        //       ],
        //     ),
        //     SizedBox(width: blockPadding),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         TextIndicatorWidget(
        //           width: infoFieldWidth,
        //           indicator: TextValueIndicator(
        //             stream: _dsClient.streamReal('Hook.Speed'),
        //             valueUnit: const Localized('m/min').v,
        //             fractionDigits: 1,
        //           ),
        //           caption: Text(
        //             const Localized('Hook speed').v,
        //             style: Theme.of(context).textTheme.bodySmall,
        //           ),
        //           alignment: infoFieldAlignment, 
        //         ),
        //         Tooltip(
        //           message: const Localized('Absolute depth').v,
        //           child: TextIndicatorWidget(
        //             width: infoFieldWidth,
        //             indicator: TextValueIndicator(
        //               key: const GlobalObjectKey('Crane.Depth'),
        //               stream: _dsClient.streamReal('Crane.Depth'),
        //               valueUnit: const Localized('m').v,
        //               fractionDigits: 1,
        //             ),
        //             caption: Text(
        //               const Localized('Depth abs').v,
        //               style: Theme.of(context).textTheme.bodySmall,
        //             ),
        //             alignment: infoFieldAlignment, 
        //           ),
        //         ),
        //         Tooltip(
        //           message: const Localized('Relative depth').v,
        //           child: TextIndicatorWidget(
        //             width: infoFieldWidth,
        //             indicator: TextValueIndicator(
        //               key: const GlobalObjectKey('Crane.DeckDepth'),
        //               stream: _dsClient.streamReal('Crane.DeckDepth'),
        //               valueUnit: const Localized('m').v,
        //               fractionDigits: 1,
        //             ),
        //             caption: Text(
        //               const Localized('Rel depth').v,
        //               style: Theme.of(context).textTheme.bodySmall,
        //             ),
        //             alignment: infoFieldAlignment, 
        //           ),
        //         ),
        //       ],
        //     ),
        //     SizedBox(width: blockPadding),
        //   ],
        // ),
      ],
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
