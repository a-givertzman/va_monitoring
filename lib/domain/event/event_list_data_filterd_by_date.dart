import 'dart:async';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Filtering [EventListData] by [From] & [To] date period
class AlarmListDataFilteredByDate<T> implements EventListData<T> {
  static const _debug = true;
  late StreamController<OperationState> _stateController;
  late StreamSubscription _stateSubscription;
  final EventListData<T> _listData;
  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  ///
  /// Filtering [EventListData] by start & end date
  AlarmListDataFilteredByDate({
    required EventListData<T> listData,
  }) :
    _listData = listData;
  //
  @override
  void onTextFilterSubmitted(String value) {
    _listData.onTextFilterSubmitted(value);
  }
  //
  @override
  void onDateFromSubmitted(DateTime? dateTime) {
      log(_debug, '[$AlarmListDataFilteredByDate.onDateFromSubmitted] From date: $dateTime');
      final fromDateTime = _fromDateTime;
      // _listData.onDateFromSubmitted(dateTime);
      if (dateTime != null && fromDateTime != null) {
        if (dateTime.isAtSameMomentAs(fromDateTime)) {
          _fromDateTime = dateTime;
          _listData.onDateFromSubmitted(dateTime);
          _stateController.add(OperationState.undefined);
        }
      } else if (dateTime != _fromDateTime) {
        if (dateTime != fromDateTime) {
          _fromDateTime = dateTime;
          _listData.onDateFromSubmitted(dateTime);
          _stateController.add(OperationState.undefined);
        }
      }
  }
  ///
  /// Call this method if [To] date modified
  @override
  void onDateToSubmitted(DateTime? dateTime) {
      log(_debug, '[$AlarmListDataFilteredByDate.onDateToSubmitted] To date: $dateTime');
      final toDateTime = _toDateTime;
      // _listData.onDateToSubmitted(dateTime);
      if (dateTime != null && toDateTime != null) {
        if (dateTime.isAtSameMomentAs(toDateTime)) {
          _toDateTime = dateTime;
          _listData.onDateToSubmitted(dateTime);
          _stateController.add(OperationState.undefined);
        }
      } else if (dateTime != _fromDateTime) {
        if (dateTime != toDateTime) {
          _toDateTime = dateTime;
          _listData.onDateToSubmitted(dateTime);
          _stateController.add(OperationState.undefined);
        }
      }
  }
  ///
  /// Список элементов для ListView
  @override
  List<T> get list {
    final fromDateTime = _fromDateTime;
    final toDateTime = _toDateTime;
    List<T> listFiltered;
    if (fromDateTime != null && toDateTime != null) {
      listFiltered = _listData.list.where((element) {
        final event = element as DsDataPoint;
        return DateTime.parse(event.timestamp).isAfter(fromDateTime) &&
          DateTime.parse(event.timestamp).isBefore(toDateTime.add(const Duration(days: 1)));
      }).toList();
    } else if (fromDateTime != null) {
      listFiltered = _listData.list.where((element) {
        final event = element as DsDataPoint;
        return DateTime.parse(event.timestamp).isAfter(fromDateTime);
      }).toList();
    } else if (toDateTime != null) {
      listFiltered = _listData.list.where((element) {
        final event = element as DsDataPoint;
        return DateTime.parse(event.timestamp).isBefore(toDateTime.add(const Duration(days: 1)));
      }).toList();
    } else {
      return _listData.list;
    }
    return listFiltered;
  }
  ///
  void _onCancel() {
    _stateSubscription.cancel();
  }
  /// Поток состояний для ListWiew.builder:
  ///   - 0 (новое событие)
  @override
  Stream<OperationState> get stateStream {
    _stateController = StreamController<OperationState>(onCancel: _onCancel);
    _stateSubscription = _listData.stateStream.listen((event) {
      _stateController.add(event);
    },);
    return _stateController.stream;
  }
  ///
  /// Текстовый контроллер для фильтации списка по тексту
  // TextEditingController get filterControllet => _listData.filterController;
  ///
  /// Квитирует событие, если оно перешло в неаварийное значение (0)
  @override
  void onAcknowledged(T point) => _listData.onAcknowledged(point);
  //
  @override
  void dispose() {
    _stateController.close();
    _listData.dispose();
  }
}