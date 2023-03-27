import 'dart:async';
import 'package:va_monitoring/domain/crane/crane_main_mode.dart';
import 'package:va_monitoring/domain/crane/crane_mode_state.dart';
import 'package:va_monitoring/domain/crane/crane_wave_height_level.dart';
import 'package:va_monitoring/domain/crane/crane_winch_mode_value.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class CraneModeControlWidget extends StatefulWidget {
  final DsClient _dsClient;
  final CraneModeState _craneModeState;
  final double _buttonWidth;
  final double _buttonHeight;
  ///
  const CraneModeControlWidget({
    Key? key,
    required DsClient dsClient,
    required CraneModeState craneModeState,
    required double buttonWidth,
    required double buttonHeight,
  }) : 
    _dsClient = dsClient,
    _craneModeState = craneModeState,
    _buttonWidth = buttonWidth,
    _buttonHeight = buttonHeight,
    super(key: key);
  ///
  @override
  State<CraneModeControlWidget> createState() => _CraneModeControlWidgetState(
    dsClient: _dsClient,
    craneModeState: _craneModeState,
    buttonWidth: _buttonWidth,
    buttonHeight: _buttonHeight,
  );
}

///
class _CraneModeControlWidgetState extends State<CraneModeControlWidget> {
  // static const _debug = true;
  final DsClient _dsClient;
  final CraneModeState _craneModeState;
  final double _buttonWidth;
  final double _buttonHeight;
  ///
  _CraneModeControlWidgetState({
    required DsClient dsClient,
    required CraneModeState craneModeState,
    required double buttonWidth,
    required double buttonHeight,
  }) :
    _dsClient = dsClient,
    _craneModeState = craneModeState,
    _buttonWidth = buttonWidth,
    _buttonHeight = buttonHeight;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Селектор | Режим работы крана
        DropDownControlButton(
          width: _buttonWidth,
          height: _buttonHeight,
          dsClient: _dsClient,
          writeTagName: DsPointName('/line1/ied12/db902_panel_controls/Settings.CraneMode.MainMode'),
          responseTagName: 'CraneMode.MainMode',
          tooltip: const Localized('Select crane mode').v,
          label: const Localized('Mode').v,
          items: {
            CraneMainModeValue.hurbour.value.toInt(): const Localized('Harbour').v,
            CraneMainModeValue.theSea.value.toInt(): const Localized('In sea').v,
          },
        ),
        SizedBox(height: padding,),
        /// Селектор | Режим работы лебедки
        DropDownControlButton(
          itemsDisabledStreams: {
            CraneWinchModeValue.ahc.value.toInt(): _craneModeState.winch1ModeState.transform<bool>(
              StreamTransformer.fromHandlers(handleData: (event, sink) {
                if (event == CraneWinchModeValue.ahcIsDisabled) sink.add(true);
                if (event == CraneWinchModeValue.ahcIsEnabled) sink.add(false);
              }),
            ),
            CraneWinchModeValue.manriding.value.toInt(): _craneModeState.winch1ModeState.transform<bool>(
              StreamTransformer.fromHandlers(handleData: (event, sink) {
                if (event == CraneWinchModeValue.manridingIsDisabled) sink.add(true);
                if (event == CraneWinchModeValue.manridingIsEnabled) sink.add(false);
              }),
            ),
          },
          width: _buttonWidth,
          height: _buttonHeight,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.CraneMode.Winch1Mode', 
          ),
          responseTagName: 'CraneMode.Winch1Mode',
          tooltip: const Localized('Select winch mode').v,
          label: const Localized('Winch').v,
          items: {
            CraneWinchModeValue.freight.value.toInt(): const Localized('Freight').v,
            CraneWinchModeValue.ahc.value.toInt(): const Localized('AHC').v,
            CraneWinchModeValue.manriding.value.toInt(): const Localized('Manriding').v,
          },
        ),
        SizedBox(height: padding,),
        /// Селектор | Уровень высоты волны
        DropDownControlButton(
          disabledStream: BufferedStream(
            _craneModeState.waveHeightLevelState.transform<bool>(
              StreamTransformer.fromHandlers(handleData: (event, sink) {
                if (event == CraneWaveHeightLevel.isDisabled) sink.add(true);
                if (event == CraneWaveHeightLevel.isEnabled) sink.add(false);                  
              }),
            ),
            initValue: false,
          ),
          width: _buttonWidth,
          height: _buttonHeight,
          dsClient: _dsClient,
          writeTagName: DsPointName(
            '/line1/ied12/db902_panel_controls/Settings.CraneMode.WaveHeightLevel', 
          ),
          responseTagName: 'CraneMode.WaveHeightLevel',
          tooltip: const Localized('Select wave hight level').v,
          label: const Localized('SWH').v,
          items: {
            CraneWaveHeightLevel.level0.value.toInt(): const Localized('0.1 m').v,
            // CraneWaveHeightLevel.level1.value.toInt(): const Localized('1.25 m').v,
            // CraneWaveHeightLevel.level2.value.toInt(): const Localized('2.0 m').v,
          },
        ),
      ],
    );
  }
}
