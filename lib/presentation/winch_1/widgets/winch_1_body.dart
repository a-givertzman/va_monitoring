import 'dart:math';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/core/widgets/common_container_widget.dart';
import 'package:va_monitoring/presentation/winch_1/widgets/winch_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class Winch1Body extends StatelessWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const Winch1Body({
    Key? key,
    // required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    // _users = users,
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$Winch1Body.build]');
    final padding = const Setting('padding').toDouble;
    final blockPadding  = const Setting('blockPadding').toDouble;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final displaySizeWidth = const Setting('displaySizeWidth').toDouble;
    final displaySizeHeight = const Setting('displaySizeHeight').toDouble;
    // final statusColors = StatusColors(
    //   error: Theme.of(context).colorScheme.error,
    //   obsolete: Theme.of(context).obsoleteColor,
    //   invalid: Theme.of(context).invalidColor,
    //   timeInvalid: Theme.of(context).timeInvalidColor,
    //   off: Theme.of(context).colorScheme.background,
    //   on: Theme.of(context).colorScheme.primary,
    // );
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
        height / displaySizeHeight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Блок | Датчики гидромотора 1
              WinchWidget(
                dsClient: _dsClient,
                rotationSpeedTagName: 'Winch.EncoderBR1',
                lvdtTagName: 'Winch.LVDT1',
                pressureTagName: 'Winch.PressureLineA_1',
                pressureBrakeTagName: 'Winch.PressureBrakeA',
                temperatureTagName: 'Winch.TempLine1',
                hydromotorActiveTagName: 'Winch.Hydromotor1Active',
                caption: Text('${const Localized('Hydromotor').v} 1.0', textAlign: TextAlign.center,),
              ),
              SizedBox(width: blockPadding * 2,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/pump-top-bottom-var-left.png',
                    width: 80.0,
                    height: 80.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                    // color: Colors.blueAccent,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  SizedBox(width: padding,),
                  Image.asset(
                    'assets/icons/winch.png',
                    width: 100.0,
                    height: 100.0,
                    // color: Colors.blueAccent,
                    color: Theme.of(context).colorScheme.tertiary,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                  ),
                  SizedBox(width: padding,),
                  Image.asset(
                    'assets/icons/pump-top-bottom-var-right.png',
                    width: 80.0,
                    height: 80.0,
                    color: Theme.of(context).colorScheme.tertiary,
                    // color: Colors.blueAccent,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                  ),
                ],
              ),
              /// Column 2 | Brand Icon
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Image.asset(
              //       'assets/img/brand_icon.png',
              //       scale: 4.0,
              //       opacity: const AlwaysStoppedAnimation<double>(0.2),
              //     ),
              //   ],
              // ),
              SizedBox(width: blockPadding * 2,),
              /// Блок | Датчики гидромотора 2
              WinchWidget(
                dsClient: _dsClient,
                // rotationSpeedTagName: 'Winch.EncoderBR2',
                lvdtTagName: 'Winch.LVDT2',
                pressureTagName: 'Winch.PressureLineA_2',
                pressureBrakeTagName: 'Winch.PressureBrakeB',
                temperatureTagName: 'Winch.TempLine2',
                hydromotorActiveTagName: 'Winch.Hydromotor2Active',
                caption: Text('${const Localized('Hydromotor').v} 2.0', textAlign: TextAlign.center,),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InvalidStatusIndicator(
                stream: _dsClient.streamInt('Winch.EncoderBR1'),
                stateColors: Theme.of(context).stateColors,
                child: CommonContainerWidget(
                  header: Text(
                    const Localized('Rotation speed').v.replaceFirst(' ', '\n'),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    CircularValueIndicator(
                      size: 60,
                      min: 0,
                      max: 4500,
                      high: 4050.0,
                      valueUnit: const Localized('rpm').v,
                      stream: _dsClient.streamInt('Winch.EncoderBR1'),
                    ),
                  ],
                ),
              ),
              SizedBox(width: blockPadding),
              InvalidStatusIndicator(
                stream: _dsClient.streamInt('Winch.EncoderBR2'),
                stateColors: Theme.of(context).stateColors,
                child: CommonContainerWidget(
                  header: Text(
                    const Localized('Rope length').v.replaceFirst(' ', '\n'),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    CircularValueIndicator(
                      size: 60,
                      min: 0,
                      max: 53,
                      valueUnit: const Localized('m').v,
                      stream: _dsClient.streamInt('Winch.EncoderBR2').map((event) {
                        return DsDataPoint(
                          type: event.type, 
                          name: event.name, 
                          value: event.value / 100, 
                          status: event.status, 
                          timestamp: event.timestamp,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),      
        ],
      ),
    );
  }
}
