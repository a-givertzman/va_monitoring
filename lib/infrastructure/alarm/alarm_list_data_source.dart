import 'dart:async';
import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Хранит все активные и неактивные не сквитированные события,
/// События получает из основного потока Stream<DsDataPoint>
class AlarmListDataSource<T> implements EventListData<T> {
  final _log = Log('${AlarmListDataSource<T>}')..level = LogLevel.debug;
  final List<StreamController<OperationState>> _stateControllers = [];
  final List<T> _list = [];
  final Stream<DsDataPoint>? _stream;
  ///
  /// Хранит все активные и неактивные не сквитированные события,
  /// События получает из основного потока Stream<DsDataPoint>
  AlarmListDataSource({
    Stream<DsDataPoint>? stream,
  }) :
  _stream = stream 
  {
    final stream = _stream;
    if (stream != null) {
      stream.listen((event) {
        _updateListWith(
          point: event,
        );
        _stateAdd(OperationState.undefined);  // prev value 0
      });
    }
  }
  ///
  void _stateAdd(OperationState state) {
    for (final controller in _stateControllers) {
      controller.add(state);
    }
  }
  ///
  /// Обновляет список новым событием:
  ///   - если аварийное событие першло в неаварийное значение,
  ///   то помечаем событие как неактивное
  ///   - если событие перешло в аварийное значение, 
  ///   то добавляем его в список аварийных и/или помечаем как активное
  void _updateListWith({
    required DsDataPoint point, 
    // required bool active, 
  }) {
    // _log.debug('[$AlarmListDataSource._updateListWith] event: $point');
    _parseDouble(point.value).fold(
      onData: (value) {
        final convertedPoint = DsDataPoint<double>(
          type: point.type, 
          name: point.name, 
          value: value, 
          history: point.history,
          alarm: point.alarm,
          status: point.status, 
          timestamp: point.timestamp,
        );
        // _log.debug('[$AlarmListDataSource._updateListWith] convertedPoint: $convertedPoint');
        for (int i = 0; i < _list.length; i ++) {
          final listPoint = _list[i] as AlarmListPoint<double>;
          if (listPoint.name == point.name) {
            _list[i] = AlarmListPoint<double>(
              point: convertedPoint, 
              active: value > 0,
              acknowledged: false,
            ) as T;
            return;
          }
        }
        if (value > 0) {
            _list.insert(
              0, 
              AlarmListPoint<double>(
                point: convertedPoint, 
                active: value > 0,
                acknowledged: false,
              ) as T,
            );
        }
      }, 
      onError: (_) => null,
    );
  }
  ///
  Result<double> _parseDouble(dynamic source) {
    if (source is bool) {
      return Result<double>(data: source ? 1.0 : 0.0);
    }
    final value = double.tryParse(source);
    if (value != null) {
      return Result<double>(data: value);
    }
    return Result<double>(
      error: Failure.convertion(
        message: 'Ошибка в методе $runtimeType._parseDouble: double.tryParse error on value: $source', 
        stackTrace: StackTrace.current,
      ),
    );
  }
  ///
  void _onCancel(StreamController<OperationState>? controller) {
    _log.debug('[.onCancel] ');
    _stateControllers.remove(controller);
    if (controller != null) {
      controller.close();
    }
    controller = null;
  }
  /// Поток состояний для ListWiew.builder:
  ///   - 0 (новое событие)
  @override
  Stream<OperationState> get stateStream {
    final controller = StreamController<OperationState>();
    controller.onCancel = () {
      _onCancel(controller);
    };
    _stateControllers.add(controller);
    return controller.stream;
  }
  ///
  /// Список элементов для ListView
  @override
  List<T> get list {
    return _list;
  }
  ///
  /// Квитирует событие, если оно перешло в неаварийное значение (0)
  @override
  void onAcknowledged(T point) {
    _log.debug('[.onAcknowledged] point: $point');
    final i = _list.indexOf(point);
    if ((i >= 0) && (_list[i] as AlarmListPoint).value == 0.0) {
      _list.removeAt(i);
      _stateAdd(OperationState.undefined); // prev value 0
    }
  }
  //
  @override
  void onTextFilterSubmitted(String value) {
    _stateAdd(OperationState.undefined); // prev value 0
    return;
  }
  ///
  /// Is not in use in this case
  @override
  void onDateFromSubmitted(DateTime? dateTime) {
    _stateAdd(OperationState.undefined); // prev value 0
    return;
  }
  ///
  /// Is not in use in this case
  @override
  void onDateToSubmitted(DateTime? dateTime) {
    _stateAdd(OperationState.undefined); // prev value 0
    return;
  }
  ///
  @override
  void dispose() {
    for (final controller in _stateControllers) {
      controller.close();
    }
  }
}
