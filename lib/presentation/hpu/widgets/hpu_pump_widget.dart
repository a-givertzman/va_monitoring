import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
/// Насос с приводом
class HpuPumpWidget extends StatelessWidget {
  final Stream<DsDataPoint<int>>? _stream;
  final Widget _caption;
  final String _driveCaption;
  final String _pumpCaption;
  ///
  const HpuPumpWidget({
    Key? key,
    Stream<DsDataPoint<int>>? stream,
    required Widget caption,
    required String driveCaption,
    required String pumpCaption,
  }) : 
    _stream = stream,
    _caption = caption,
    _driveCaption = driveCaption,
    _pumpCaption = pumpCaption,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    // final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100.0,
          child: Center(child: _caption),
        ),
        SizedBox(height: padding,),
        const SizedBox(height: 50.0,),
        SizedBox(height: padding,),
        AcDriveWidget(
          stream: _stream,
          caption: _driveCaption,
          acMotorIcon: Image.asset('assets/icons/ac_motor.png'),
          acMotorFailureIcon: Image.asset('assets/icons/ac_motor_failure.png'),
        ),
        SizedBox(height: padding),
        Padding(
          padding: EdgeInsets.all(padding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/icons/pump-left-var-left.png',
                // scale: 4.0,
                width: 100.0 - padding * 2,
                height: 100.0 - padding * 2,
                color: Theme.of(context).colorScheme.tertiary,
                opacity: const AlwaysStoppedAnimation<double>(0.5),
              ),
              Text(_pumpCaption, textAlign: TextAlign.center),
            ],
          ),
        ),
        SizedBox(height: padding),
        const SizedBox(height: 100.0,),
      ],
    );
  }
}
