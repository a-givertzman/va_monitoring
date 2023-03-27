import 'dart:async';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Filtering [EventListData] by tag path and name
class AlarmListDataFilteredByText<T> implements EventListData<T> {
  static const _debug = true;
  late StreamController<OperationState> _stateController;
  late StreamSubscription _stateSubscription;
  final EventListData<T> _listData;
  String _filterText = '';
  ///
  AlarmListDataFilteredByText({
    required EventListData<T> listData,
  }) :
    _listData = listData;
  ///
  /// Список элементов для ListView
  @override
  List<T> get list {
    final regexp = RegExp('.*$_filterText.*', caseSensitive: false);
    if (_filterText.isEmpty) {
      return _listData.list;
    }
    final listFiltered = _listData.list.where((element) {
      final event = element as DsDataPoint;
      return regexp.hasMatch(event.name.path) || regexp.hasMatch(event.name.name);
    }).toList();
    log(_debug, '[$AlarmListDataFilteredByText.list] listLength: ${listFiltered.length}');
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
  //
  @override
  void onAcknowledged(T point) => _listData.onAcknowledged(point);
  //
  @override
  void onTextFilterSubmitted(String value) {
    final filterText = value.toLowerCase();
    log(_debug, '[$AlarmListDataFilteredByText.onTextFilterSubmitted] filter: $filterText');
    if (filterText != _filterText) {
      _filterText = filterText;
      _listData.onTextFilterSubmitted(filterText);
    }
  }  
  //
  @override
  void onDateFromSubmitted(DateTime? dateTime) {
      log(_debug, '[$AlarmListDataFilteredByText.onDateFromSubmitted] From date: $dateTime');
      _listData.onDateFromSubmitted(dateTime);
  }
  //
  @override
  void onDateToSubmitted(DateTime? dateTime) {
      log(_debug, '[$AlarmListDataFilteredByText.onDateToSubmitted] To date: $dateTime');
      _listData.onDateToSubmitted(dateTime);
  }
  //
  @override
  void dispose() {
    _stateController.close();
    _listData.dispose();
  }
}