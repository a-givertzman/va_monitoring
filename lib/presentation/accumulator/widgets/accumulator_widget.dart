import 'package:va_monitoring/presentation/core/widgets/common_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
/// Два насоса с приводом
class AccumulatorWidget extends StatefulWidget {
  final DsClient? _dsClient;
  final double? _minNitroPressure;
  final double? _maxNitroPressure;
  final double? _lowNitroPressure;
  final double? _highNitroPressure;
  final String? _pistonMaxLimitTagName;
  final String? _pistonMinLimitTagName;
  final String? _pressureOfNitroTagName;
  final String? _alarmNitroPressureTagName;
  final Widget? _caption;
  ///
  /// - [inUseStream] - поток состояния задействована/незадействована насосная группа
  /// - [_driveStream] - поток состояния привода насосов
  const AccumulatorWidget({
    Key? key,
    DsClient? dsClient,
    double? minNitroPressure,
    double? maxNitroPressure,
    double? lowNitroPressure,
    double? highNitroPressure,
    String? pistonMaxLimitTagName,
    String? pistonMinLimitTagName,
    String? pressureOfNitroTagName,
    String? alarmNitroPressureTagName,
    Widget? caption,
  }) : 
    _dsClient = dsClient,
    _minNitroPressure = minNitroPressure,
    _maxNitroPressure = maxNitroPressure,
    _lowNitroPressure = lowNitroPressure,
    _highNitroPressure = highNitroPressure,
    _pistonMaxLimitTagName = pistonMaxLimitTagName,
    _pistonMinLimitTagName = pistonMinLimitTagName,
    _pressureOfNitroTagName = pressureOfNitroTagName,
    _alarmNitroPressureTagName = alarmNitroPressureTagName,
    _caption = caption,
    super(key: key);
  //
  @override
  State<AccumulatorWidget> createState() => _AccumulatorWidgetState(
    dsClient: _dsClient,
    minNitroPressure: _minNitroPressure,
    maxNitroPressure: _maxNitroPressure,
    lowNitroPressure: _lowNitroPressure,
    highNitroPressure: _highNitroPressure,
    pistonMaxLimitTagName: _pistonMaxLimitTagName,
    pistonMinLimitTagName: _pistonMinLimitTagName,
    pressureOfNitroTagName: _pressureOfNitroTagName,
    alarmNitroPressureTagName: _alarmNitroPressureTagName,
    caption: _caption,
  );
}

///
class _AccumulatorWidgetState extends State<AccumulatorWidget> {
  // static const _debug = true;
  final DsClient? _dsClient;
  final double? _minNitroPressure;
  final double? _maxNitroPressure;
  final double? _lowNitroPressure;
  final double? _highNitroPressure;
  final String? _pistonMaxLimitTagName;
  final String? _pistonMinLimitTagName;
  final String? _pressureOfNitroTagName;
  final String? _alarmNitroPressureTagName;
  final Widget? _caption;
  ///
  _AccumulatorWidgetState({
    required DsClient? dsClient,
    double? minNitroPressure,
    double? maxNitroPressure,
    double? lowNitroPressure,
    double? highNitroPressure,
    required String? pistonMaxLimitTagName,
    required String? pistonMinLimitTagName,
    required String? pressureOfNitroTagName,
    required String? alarmNitroPressureTagName,
    required Widget? caption,
  }) : 
    _dsClient = dsClient,
    _minNitroPressure = minNitroPressure,
    _maxNitroPressure = maxNitroPressure,
    _lowNitroPressure = lowNitroPressure,
    _highNitroPressure = highNitroPressure,
    _pistonMaxLimitTagName = pistonMaxLimitTagName,
    _pistonMinLimitTagName = pistonMinLimitTagName,
    _pressureOfNitroTagName = pressureOfNitroTagName,
    _alarmNitroPressureTagName = alarmNitroPressureTagName,
    _caption = caption,
    super();
  //
  @override
  void initState() {
    // final inUseStream = _inUseStream;
    // if (inUseStream != null) {
    //   inUseStream.listen((event) {
    //     if (mounted) {
    //       setState(() {
    //         _inUse = event.value == 2;
    //         _inUseSwitchDisabled = false;
    //       });
    //     }
    //   });
    // }
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    // final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    final stateColors = Theme.of(context).stateColors;
    final dsClient = _dsClient;
    final pistonMaxLimitTagName = _pistonMaxLimitTagName;
    final pistonMinLimitTagName = _pistonMinLimitTagName;
    final pressureOfNitroTagName = _pressureOfNitroTagName;
    final alarmNitroPressureTagName = _alarmNitroPressureTagName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140.0,
          child: Center(child: _caption),
        ),
        SizedBox(height: blockPadding,),
        StatusIndicatorWidget(
          width: 230.0,
          indicator: BoolColorIndicator(
            // iconData: Icons.account_tree_outlined,
            stream: (dsClient != null && pistonMaxLimitTagName != null) ? dsClient.streamBool(pistonMaxLimitTagName) : null,
          ),
          caption: Text(const Localized('Piston max limit').v),
        ),
        StatusIndicatorWidget(
          width: 230.0,
          indicator: BoolColorIndicator(
            // iconData: Icons.account_tree_outlined,
            stream: (dsClient != null && pistonMinLimitTagName != null) ? dsClient.streamBool(pistonMinLimitTagName) : null,
          ),
          caption: Text(const Localized('Piston min limit').v),
        ),
        SizedBox(height: blockPadding,),
        InvalidStatusIndicator(
          stream: (dsClient != null && pressureOfNitroTagName != null) ? dsClient.streamBool(pressureOfNitroTagName) : null,
          stateColors: stateColors,
          child: CommonContainerWidget(
            header: Text(
              const Localized('Pressure of nitro').v,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            children: [
              CircularValueIndicator(
                size: 192.0,
                min: _minNitroPressure ?? 0,
                max: _maxNitroPressure ?? 0,
                low: _lowNitroPressure,
                high: _highNitroPressure,
                valueUnit: 'bar',
                stream: dsClient != null && pressureOfNitroTagName != null
                  ? dsClient.streamInt(pressureOfNitroTagName) 
                  : null,
              ),
            ],
          ),
        ),
        StatusIndicatorWidget(
          width: 230.0,
          indicator: BoolColorIndicator(
            // iconData: Icons.account_tree_outlined,
            stream: (dsClient != null && alarmNitroPressureTagName != null) ? dsClient.streamBool(alarmNitroPressureTagName) : null,
          ),
          caption: Expanded(child: Text(const Localized('Emergency high nitro pressure').v, textAlign: TextAlign.center,)),
        ),
      ],
    );
  }
}
