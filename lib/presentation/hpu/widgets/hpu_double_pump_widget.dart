
import 'package:va_monitoring/presentation/core/widgets/common_container_widget.dart';
import 'package:va_monitoring/settings/common_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
/// Два насоса с приводом
class HpuDoublePumpWidget extends StatefulWidget {
  final Stream<DsDataPoint<int>>? _inUseStream;
  final Stream<DsDataPoint<int>>? _driveStream;
  final Stream<DsDataPoint<double>>? _presure1Stream;
  final Stream<DsDataPoint<double>>? _presure2Stream;
  final Widget _caption;
  final String _driveCaption;
  final String _pump1Caption;
  final String _pump2Caption;
  final void Function(int)? _onChanged;
  ///
  /// - [inUseStream] - поток состояния задействована/незадействована насосная группа
  /// - [_driveStream] - поток состояния привода насосов
  const HpuDoublePumpWidget({
    Key? key,
    Stream<DsDataPoint<int>>? inUseStream,
    Stream<DsDataPoint<int>>? driveStream,
    Stream<DsDataPoint<double>>? presure1Stream,
    Stream<DsDataPoint<double>>? presure2Stream,
    required Widget caption,
    required String driveCaption,
    required String pump1Caption,
    required String pump2Caption,
    required void Function(int)? onChanged,
  }) : 
    _inUseStream = inUseStream,
    _driveStream = driveStream,
    _presure1Stream = presure1Stream,
    _presure2Stream = presure2Stream,
    _caption = caption,
    _driveCaption = driveCaption,
    _pump1Caption = pump1Caption,
    _pump2Caption = pump2Caption,
    _onChanged = onChanged,
    super(key: key);
  //
  @override
  State<HpuDoublePumpWidget> createState() => _HpuDoublePumpWidgetState(
    inUseStream: _inUseStream,
    driveStream: _driveStream,
    presure1Stream: _presure1Stream,
    presure2Stream: _presure2Stream,
    caption: _caption,
    driveCaption: _driveCaption,
    pump1Caption: _pump1Caption,
    pump2Caption: _pump2Caption,
    onChanged: _onChanged,
  );
}

///
class _HpuDoublePumpWidgetState extends State<HpuDoublePumpWidget> {
  // static const _debug = true;
  final Stream<DsDataPoint<int>>? _inUseStream;
  final Stream<DsDataPoint<int>>? _driveStream;
  final Stream<DsDataPoint<double>>? _presure1Stream;
  final Stream<DsDataPoint<double>>? _presure2Stream;
  final Widget _caption;
  final String _driveCaption;
  final String _pump1Caption;
  final String _pump2Caption;
  final void Function(int)? _onChanged;
  bool _inUseSwitchDisabled = false;
  bool _inUse = false;
  ///
  _HpuDoublePumpWidgetState({
    Stream<DsDataPoint<int>>? inUseStream,
    Stream<DsDataPoint<int>>? driveStream,
    Stream<DsDataPoint<double>>? presure1Stream,
    Stream<DsDataPoint<double>>? presure2Stream,
    required Widget caption,
    required String driveCaption,
    required String pump1Caption,
    required String pump2Caption,
    required void Function(int)? onChanged,
  }) : 
    _inUseStream = inUseStream,
    _driveStream = driveStream,
    _presure1Stream = presure1Stream,
    _presure2Stream = presure2Stream,
    _caption = caption,
    _driveCaption = driveCaption,
    _pump1Caption = pump1Caption,
    _pump2Caption = pump2Caption,
    _onChanged = onChanged,
    super();
  //
  @override
  void initState() {
    final inUseStream = _inUseStream;
    if (inUseStream != null) {
      inUseStream.listen((event) {
        // log(_debug, '[$_HpuDoublePumpWidgetState.inUseStream.listen] event: ', event);
        if (mounted) {
          setState(() {
            _inUse = event.value == DsDps.on.value;
            _inUseSwitchDisabled = false;
          });
        }
      });
    }
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    // final blockPadding = const Setting('blockPadding').toDouble;
    final stateColors = Theme.of(context).stateColors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 100.0,
          child: Center(child: _caption),
        ),
        SizedBox(height: padding),
        /// Компрессор | В работу / В Резерв
        InvalidStatusIndicator(
          stream: _inUseStream,
          stateColors: stateColors,
          child: SizedBox(
            width: 100.0,
            height: 50.0,
            child: ColorFiltered(
              colorFilter: AppUiSettings.colorFilterDisabled(context, _inUseSwitchDisabled),
              child: AbsorbPointer(
                absorbing: _inUseSwitchDisabled,
                child: CupertinoSwitch(
                  activeColor: stateColors.on,
                  thumbColor: Theme.of(context).colorScheme.primary,
                  value: _inUse, 
                  onChanged: (value) {
                    final onChanged = _onChanged;
                    if (onChanged != null) {
                      if (mounted) {
                        setState(() {
                          _inUseSwitchDisabled = true;
                          Future.delayed(
                            const Duration(seconds: 5),
                            () {
                              if (mounted) {
                                setState(() {
                                  _inUseSwitchDisabled = false;
                                });
                              }
                            },
                          );
                        });
                      }
                      onChanged(value ? 2 : 1);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: padding),
        AcDriveWidget(
          stream: _driveStream,
          caption: _driveCaption,
          disabled: !_inUse,
          acMotorIcon: Image.asset('assets/icons/ac_motor.png'),
          acMotorFailureIcon: Image.asset('assets/icons/ac_motor_failure.png'),
        ),
        SizedBox(height: padding),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InvalidStatusIndicator(
              stream: _presure1Stream,
              stateColors: stateColors,
              child: CommonContainerWidget(
                disabled: !_inUse,
                header: Text(
                  const Localized('Pressure').v,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularValueIndicator(
                    min: 0,
                    max: 400,
                    size: 50.0,
                    valueUnit: 'bar',
                    stream: _presure1Stream,
                  ),
                ],
              ),
            ),
            SizedBox(width: padding),
            Padding(
              padding: EdgeInsets.all(padding),
              child: ColorFiltered(
                colorFilter: AppUiSettings.colorFilterDisabled(context, !_inUse),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/pump-left-var-left.png',
                      width: 100.0 - padding * 2,
                      height: 100.0 - padding * 2,
                      color: Theme.of(context).colorScheme.tertiary,
                      opacity: const AlwaysStoppedAnimation<double>(0.4),
                    ),
                    Text(_pump1Caption, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: padding * 1.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InvalidStatusIndicator(
              stream: _presure2Stream,
              stateColors: stateColors,
              child: CommonContainerWidget(
                disabled: !_inUse,
                header: Text(
                  const Localized('Pressure').v,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularValueIndicator(
                    min: 0,
                    max: 50,
                    // low: 210,
                    // high: 290,
                    size: 50.0,
                    valueUnit: 'bar',
                    stream: _presure2Stream,
                  ),
                ],
              ),
            ),
            SizedBox(width: padding),
            Padding(
              padding: EdgeInsets.all(padding),
              child: ColorFiltered(
                colorFilter: AppUiSettings.colorFilterDisabled(context, !_inUse),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/pump-left.png',
                      width: 100.0 - padding * 2,
                      height: 100.0 - padding * 2,
                      color: Theme.of(context).colorScheme.tertiary,
                      opacity: const AlwaysStoppedAnimation<double>(0.4),
                    ),
                    Text(_pump2Caption, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
