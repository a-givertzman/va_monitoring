import 'dart:async';
import 'package:va_monitoring/domain/crane/crane_active_winch_value.dart';
import 'package:va_monitoring/domain/crane/crane_main_mode.dart';
import 'package:va_monitoring/domain/crane/crane_wave_height_level.dart';
import 'package:va_monitoring/domain/crane/crane_winch_mode_value.dart';
import 'package:hmi_core/hmi_core.dart';

///
class CraneModeState {
  static const _debug = true;
  final StreamController<CraneMainModeValue> _mainModeController = StreamController<CraneMainModeValue>();
  final StreamController<CraneActiveWinchValue> _activeWinchController = StreamController<CraneActiveWinchValue>();
  final StreamController<CraneWinchModeValue> _craneWinch1ModeController = StreamController<CraneWinchModeValue>.broadcast();
  final StreamController<CraneWinchModeValue> _craneWinch2ModeController = StreamController<CraneWinchModeValue>();
  final StreamController<CraneWinchModeValue> _craneWinch3ModeController = StreamController<CraneWinchModeValue>();
  final StreamController<CraneWaveHeightLevel> _craneWaveHeightController = StreamController<CraneWaveHeightLevel>();
  final StreamController<num> _constantTensionLevelController = StreamController<num>();
  CraneMainModeValue _mainMode = CraneMainModeValue.modeUndefined;
  // CraneActiveWinchValue _activeWinch = CraneActiveWinchValue.winch1;
  CraneWinchModeValue _winch1Mode = CraneWinchModeValue.modeUndefined;
  CraneWinchModeValue _winch2Mode = CraneWinchModeValue.modeUndefined;
  CraneWinchModeValue _winch3Mode = CraneWinchModeValue.modeUndefined;
  CraneWaveHeightLevel _waveHeightLevel = CraneWaveHeightLevel.level0;
  num _constantTensionLevel = 0;
  final Stream<DsDataPoint> _stream;
  ///
  /// Поток сигналов [stream] - объединенный поток всех сигналов, 
  /// изменяющих состояние:
  ///   - mainMode - режим работы крана
  ///   - activeWinch - выбранная лебедка
  ///   - winch1Mode - режим работы данной лебедки
  ///   - winch2Mode - режим работы данной лебедки
  ///   - winch3Mode - режим работы данной лебедки
  ///   - waveHeightLevel - выбранный уровень высоты волны
  CraneModeState({
    required Stream<DsDataPoint> stream,
  }) :
  _stream = stream {
    _handleStreamEvents();
  }
  ///
  /// обработка событий приходящих из входящего потока от контроллера
  void _handleStreamEvents() {
    log(_debug, '[$CraneModeState._handleStreamEvents]');
    _stream.listen((event) {
      // log(_debug, '[$CraneModeState._stream.listen] event: $event');
      int value = 0;
      final parsedValue = int.tryParse('${event.value}');
      if (parsedValue != null) {
        value = parsedValue;
      } else {
        log(_debug, '[$CraneModeState._stream.listen] parse event error: $event');
      }
      switch (event.name.name) {
        ///
        case 'CraneMode.MainMode':
          _mainModeCondition(value);
          break;
        ///
        case 'CraneMode.ActiveWinch':
          _activeWinchCondition(value);
          break;
        ///
        case 'CraneMode.Winch1Mode':
          _winch1ModeCondition(value);      
          break;
        ///
        case 'CraneMode.Winch2Mode':
          _winch2ModeCondition(value);
          break;
        ///
        case 'CraneMode.Winch3Mode':
          _winch3ModeCondition(value);
          break;
        ///
        case 'CraneMode.WaveHeightLevel':
          _waveHeightLevelCondition(value);
          break;
        ///
        case 'ConstantTension.Level':
          _constantTensionLevel = value;
          _constantTensionLevelController.add(value);
          break;
        ///
        // case 'tag.name':
          // code here...
          // break;
        /// Поведение по умолчанию, если ни одно из событий не было обработано
        default:
          log(_debug, '[$CraneModeState._handleStreamEvents] входящий тэг с именем ${event.name} не может быть обработан');
      }
    });
  }
  ///
  void _mainModeCondition(int value) {
    if (value == CraneMainModeValue.modeUndefined.value) {
      setMainMode(CraneMainModeValue.modeUndefined);
    } else if (value == CraneMainModeValue.hurbour.value) {
      setMainMode(CraneMainModeValue.hurbour);
    } else if (value == CraneMainModeValue.theSea.value) {
      setMainMode(CraneMainModeValue.theSea);
    }
  }
  ///
  void _activeWinchCondition(int value) {
    if (value == CraneActiveWinchValue.winchUndefined.value) {
      setActiveWinch(CraneActiveWinchValue.winchUndefined);
    } else if (value == CraneActiveWinchValue.winch1.value) {
      setActiveWinch(CraneActiveWinchValue.winch1);
    } else if (value == CraneActiveWinchValue.winch2.value) {
      setActiveWinch(CraneActiveWinchValue.winch2);
    } else if (value == CraneActiveWinchValue.winch3.value) {
      setActiveWinch(CraneActiveWinchValue.winch3);
    }    
  }
  /// 
  void _winch1ModeCondition(int value) {
    if (value == CraneWinchModeValue.modeUndefined.value) {
      setWinch1Mode(CraneWinchModeValue.modeUndefined);
    } else if (value == CraneWinchModeValue.freight.value) {
      setWinch1Mode(CraneWinchModeValue.freight);
    } else if (value == CraneWinchModeValue.ahc.value) {
      setWinch1Mode(CraneWinchModeValue.ahc);
    } else if (value == CraneWinchModeValue.ahcIsEnabled.value) {
      setWinch1Mode(CraneWinchModeValue.ahcIsEnabled);
    } else if (value == CraneWinchModeValue.ahcIsDisabled.value) {
      setWinch1Mode(CraneWinchModeValue.ahcIsDisabled);
    } else if (value == CraneWinchModeValue.manriding.value) {
      setWinch1Mode(CraneWinchModeValue.manriding);
    } else if (value == CraneWinchModeValue.manridingIsEnabled.value) {
      setWinch1Mode(CraneWinchModeValue.manridingIsEnabled);
    } else if (value == CraneWinchModeValue.manridingIsDisabled.value) {
      setWinch1Mode(CraneWinchModeValue.manridingIsDisabled);
    }
  }
  /// 
  void _winch2ModeCondition(int value) {
    if (value == CraneWinchModeValue.modeUndefined.value) {
      setWinch2Mode(CraneWinchModeValue.modeUndefined);
    } else if (value == CraneWinchModeValue.freight.value) {
      setWinch2Mode(CraneWinchModeValue.freight);
    } else if (value == CraneWinchModeValue.ahc.value) {
      setWinch2Mode(CraneWinchModeValue.ahc);
    } else if (value == CraneWinchModeValue.ahcIsEnabled.value) {
      setWinch2Mode(CraneWinchModeValue.ahcIsEnabled);
    } else if (value == CraneWinchModeValue.ahcIsDisabled.value) {
      setWinch2Mode(CraneWinchModeValue.ahcIsDisabled);
    } else if (value == CraneWinchModeValue.manriding.value) {
      setWinch2Mode(CraneWinchModeValue.manriding);
    } else if (value == CraneWinchModeValue.manridingIsEnabled.value) {
      setWinch2Mode(CraneWinchModeValue.manridingIsEnabled);
    } else if (value == CraneWinchModeValue.manridingIsDisabled.value) {
      setWinch2Mode(CraneWinchModeValue.manridingIsDisabled);
    }
  }
  /// 
  void _winch3ModeCondition(int value) {
    if (value == CraneWinchModeValue.modeUndefined.value) {
      setWinch3Mode(CraneWinchModeValue.modeUndefined);
    } else if (value == CraneWinchModeValue.freight.value) {
      setWinch3Mode(CraneWinchModeValue.freight);
    } else if (value == CraneWinchModeValue.ahc.value) {
      setWinch3Mode(CraneWinchModeValue.ahc);
    } else if (value == CraneWinchModeValue.ahcIsEnabled.value) {
      setWinch3Mode(CraneWinchModeValue.ahcIsEnabled);
    } else if (value == CraneWinchModeValue.ahcIsDisabled.value) {
      setWinch3Mode(CraneWinchModeValue.ahcIsDisabled);
    } else if (value == CraneWinchModeValue.manriding.value) {
      setWinch3Mode(CraneWinchModeValue.manriding);
    } else if (value == CraneWinchModeValue.manridingIsEnabled.value) {
      setWinch3Mode(CraneWinchModeValue.manridingIsEnabled);
    } else if (value == CraneWinchModeValue.manridingIsDisabled.value) {
      setWinch3Mode(CraneWinchModeValue.manridingIsDisabled);
    }
  }
  ///
  void _waveHeightLevelCondition(int value) {
    if (value == CraneWaveHeightLevel.levelUndefined.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.levelUndefined);
    } else if (value == CraneWaveHeightLevel.level0.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level0);
    } else if (value == CraneWaveHeightLevel.level1.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level1);
    } else if (value == CraneWaveHeightLevel.level2.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level2);
    } else if (value == CraneWaveHeightLevel.level3.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level3);
    } else if (value == CraneWaveHeightLevel.level4.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level4);
    } else if (value == CraneWaveHeightLevel.level5.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level5);
    } else if (value == CraneWaveHeightLevel.level6.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level6);
    } else if (value == CraneWaveHeightLevel.level7.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level7);
    } else if (value == CraneWaveHeightLevel.level8.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level8);
    } else if (value == CraneWaveHeightLevel.level9.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level9);
    } else if (value == CraneWaveHeightLevel.level10.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level10);
    } else if (value == CraneWaveHeightLevel.level11.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level11);
    } else if (value == CraneWaveHeightLevel.level12.value) {
      setWaveHeightLevel(CraneWaveHeightLevel.level12);
    }
  }
  /// задать режим работы крана
  void setMainMode(CraneMainModeValue value) {
    log(_debug, '[$CraneModeState.setMainMode] value: ${value.name}');
    _mainMode = value;
    _mainModeController.add(value);
    if (value == CraneMainModeValue.hurbour) {
      _craneWaveHeightController.add(CraneWaveHeightLevel.isDisabled);
      _craneWinch1ModeController.add(CraneWinchModeValue.ahcIsDisabled);
      _craneWinch2ModeController.add(CraneWinchModeValue.ahcIsDisabled);
      _craneWinch3ModeController.add(CraneWinchModeValue.ahcIsDisabled);
      _craneWinch1ModeController.add(CraneWinchModeValue.manridingIsEnabled);
      _craneWinch2ModeController.add(CraneWinchModeValue.manridingIsEnabled);
      _craneWinch3ModeController.add(CraneWinchModeValue.manridingIsEnabled);
      _constantTensionLevelController.add(stateIsDisabled);
    } else {
      _craneWaveHeightController.add(CraneWaveHeightLevel.isEnabled);
      _craneWinch1ModeController.add(CraneWinchModeValue.ahcIsEnabled);
      _craneWinch2ModeController.add(CraneWinchModeValue.ahcIsEnabled);
      _craneWinch3ModeController.add(CraneWinchModeValue.ahcIsEnabled);
      _craneWinch1ModeController.add(CraneWinchModeValue.manridingIsDisabled);
      _craneWinch2ModeController.add(CraneWinchModeValue.manridingIsDisabled);
      _craneWinch3ModeController.add(CraneWinchModeValue.manridingIsDisabled);
      _constantTensionLevelController.add(stateIsEnabled);
    }
  }
  /// задать активную лебедку
  void setActiveWinch(CraneActiveWinchValue value) {
    log(_debug, '[$CraneModeState.setActiveWinch] value: ${value.name}');
    // _activeWinch = value;
    _activeWinchController.add(value);
    switch (value) {
      case CraneActiveWinchValue.loading:
        break;
      case CraneActiveWinchValue.winch1:
        break;
      case CraneActiveWinchValue.winch2:
        break;
      case CraneActiveWinchValue.winch3:
        break;
      default:
    }
  }
  /// задать режим работы лебедки 1
  void setWinch1Mode(CraneWinchModeValue value) {
    log(_debug, '[$CraneModeState.setWinch1Mode] value: ${value.name}');
    _winch1Mode = value;
    _craneWinch1ModeController.add(value);
    switch (value) {
      case CraneWinchModeValue.loading:
        break;
      case CraneWinchModeValue.freight:
        break;
      case CraneWinchModeValue.ahc:
        break;
      case CraneWinchModeValue.manriding:
        break;
      default:
    }
  }
  /// задать режим работы лебедки 2
  void setWinch2Mode(CraneWinchModeValue value) {
    log(_debug, '[$CraneModeState.setWinch2Mode] value: ${value.name}');
    _winch2Mode = value;
    _craneWinch2ModeController.add(value);
    switch (value) {
      case CraneWinchModeValue.loading:
        break;
      case CraneWinchModeValue.freight:
        break;
      case CraneWinchModeValue.ahc:
        break;
      case CraneWinchModeValue.manriding:
        break;
      default:
    }
  }
  /// задать режим работы лебедки 3
  void setWinch3Mode(CraneWinchModeValue value) {
    log(_debug, '[$CraneModeState.setWinch3Mode] value: ${value.name}');
    _winch3Mode = value;
    _craneWinch3ModeController.add(value);
    switch (value) {
      case CraneWinchModeValue.loading:
        break;
      case CraneWinchModeValue.freight:
        break;
      case CraneWinchModeValue.ahc:
        break;
      case CraneWinchModeValue.manriding:
        break;
      default:
    }
  }
  /// задать уровень высоты волны
  void setWaveHeightLevel(CraneWaveHeightLevel value) {
    log(_debug, '[$CraneModeState.setWavwHeightLevel] value: ${value.name}');
    _waveHeightLevel = value;
    _craneWaveHeightController.add(value);
    switch (value) {
      case CraneWaveHeightLevel.level0:
        break;
      case CraneWaveHeightLevel.level1:
        break;
      case CraneWaveHeightLevel.level2:
        break;
      case CraneWaveHeightLevel.level3:
        break;
      default:
    }    
  }
  /// задать уровень постоянного натяжения
  void setConstantTensionLevel(num value) {
    log(_debug, '[$CraneModeState.setConstantTensionLevel] value: $value');
    _constantTensionLevel = value;
    _constantTensionLevelController.add(value);
  }
  ///
  Stream<CraneMainModeValue> get mainModeState {
    return _mainModeController.stream.asBroadcastStream();
  }
  ///
  Stream<CraneActiveWinchValue> get activeWinchState {
    return _activeWinchController.stream.asBroadcastStream();
  }
  ///
  Stream<CraneWinchModeValue> get winch1ModeState {
    return _craneWinch1ModeController.stream;
  }
  ///
  Stream<CraneWinchModeValue> get winch2ModeState {
    return _craneWinch2ModeController.stream.asBroadcastStream();
  }
  ///
  Stream<CraneWinchModeValue> get winch3ModeState {
    return _craneWinch3ModeController.stream.asBroadcastStream();
  }
  ///
  Stream<CraneWaveHeightLevel> get waveHeightLevelState {
    return _craneWaveHeightController.stream.asBroadcastStream();
  }
  ///
  Stream<num> get constantTensionState {
    return _constantTensionLevelController.stream.asBroadcastStream();
  }
  ///
  CraneMainModeValue get mainMode => _mainMode;
  CraneWinchModeValue get winch1Mode => _winch1Mode;
  CraneWinchModeValue get winch2Mode => _winch2Mode;
  CraneWinchModeValue get winch3Mode => _winch3Mode;
  CraneWaveHeightLevel get waveHeightLevel => _waveHeightLevel;
  num get constantTensionLevel => _constantTensionLevel;
  ///
  void dispose() {
    _mainModeController.close();
    _activeWinchController.close();
    _craneWinch1ModeController.close();
    _craneWinch2ModeController.close();
    _craneWinch3ModeController.close();
    _craneWaveHeightController.close();
    _constantTensionLevelController.close();    
  }
}
