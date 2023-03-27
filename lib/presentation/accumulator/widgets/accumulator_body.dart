import 'dart:math';
import 'package:va_monitoring/presentation/accumulator/widgets/accumulator_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';

///
class AccumulatorBody extends StatelessWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const AccumulatorBody({
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
    log(_debug, '[$AccumulatorBody.build]');
    // final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final displaySizeWidth = const Setting('displaySizeWidth').toDouble;
    final displaySizeHeight = const Setting('displaySizeHeight').toDouble;
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
              /// Блок | Компрессор с приводом 1
              AccumulatorWidget(
                dsClient: _dsClient,
                minNitroPressure: 0,
                maxNitroPressure: 400,
                highNitroPressure: 330,
                pistonMaxLimitTagName: 'HPA.PistonMaxLimit',
                pistonMinLimitTagName: 'HPA.PistonMinLimit',
                pressureOfNitroTagName: 'HPA.NitroPressure',
                alarmNitroPressureTagName: 'HPA.AlarmNitroPressure',
                caption: Text(
                  const Localized('High pressure accumulator').v, 
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: blockPadding * 4,),
              /// Column 2 | Brand Icon
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/brand_icon.png',
                    scale: 4.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.2),
                  ),
                ],
              ),
              SizedBox(width: blockPadding * 4,),
              /// Блок | Компрессор с приводом 2
              AccumulatorWidget(
                dsClient: _dsClient,
                minNitroPressure: 0,
                maxNitroPressure: 100,
                highNitroPressure: 50,
                pistonMaxLimitTagName: 'LPA.PistonMaxLimit',
                pistonMinLimitTagName: 'LPA.PistonMinLimit',
                pressureOfNitroTagName: 'LPA.NitroPressure',
                alarmNitroPressureTagName: 'LPA.AlarmNitroPressure',
                caption: Text(
                  const Localized('Low pressure accumulator').v, 
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
