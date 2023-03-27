import 'dart:async';
// import 'package:another_flushbar/flushbar_helper.dart';
import 'package:va_monitoring/domain/alarm/event_list_point.dart';
import 'package:va_monitoring/domain/event/event_list.dart';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:va_monitoring/presentation/core/widgets/scaffold_snack_bar.dart';
import 'package:va_monitoring/presentation/event/widgets/position_controller.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';

///
class EventListDataSource<T> implements EventListData<T> {
  final _log = Log('${EventListDataSource<T>}')..level = LogLevel.debug;
  final BuildContext? _context;
  // final StreamController<int> _streamController = StreamController();
  final List<StreamController<OperationState>> _stateControllers = [];
  final EventList<EventListPoint>? _eventList;
  final int _listCount;
  final List<T> _list = [];
  // final double _cacheExtent;
  final int _loadingCount;
  final int _newEventsReadDelay;
  late final PositionController _positionController;
  String _filterText = '';
  DateTime? _fromDateTime;
  DateTime? _untilDateTime;
  OperationState _loadingState = OperationState.undefined;
  // bool _loadedAll = false;
  bool _isAuto = true;
  ///
  EventListDataSource({
    BuildContext? context,
    required PositionController positionController,
    EventList<EventListPoint>? eventList,
    required int listCount,
    double? cacheExtent,
    int newEventsReadDelay = 500,
  }) :
    _context = context,
    _positionController = positionController,
    _eventList = eventList,
    _listCount = listCount,
    // _cacheExtent = cacheExtent ?? 100.0,
    _loadingCount = listCount,
    _newEventsReadDelay = newEventsReadDelay
  {
    _fetchNewEvents();
    _setupPositionControllerListen();
    // _filterController.addListener(() {
    // });
  }
  ///
  void _stateAdd(OperationState state) {
    for (final controller in _stateControllers) {
      controller.add(state);
    }
  }
  ///
  /// Слушает события из PositionController
  /// [onTop], [onBottom], [onDown], [onAuto], [onManual]
  void _setupPositionControllerListen() {
    _positionController.listen(
      onTop: (double dYdT) {
        _log.debug('[.listen] onTop');
        // if (!_isAuto) {
        //   final lastEventId = _list.isNotEmpty ? (_list.first as EventListPoint).id : '';
        //   _fetchUp(lastEventId: lastEventId);
        // }
      },
      onBottom: (double dYdT) {
        _log.debug('[.listen] onBottom');
        final lastEventId = _list.isNotEmpty ? (_list.last as EventListPoint).id : '';
        _fetchDown(lastEventId: lastEventId);
      },
      onDown: (dYdT) {
        // TODO add implementation or remove this block
        // if (_list.length > _listCount * 10) {
        //   _list.removeRange(0, (dYdT * 1.5).round());
        //   _stateAdd(0);
        // }
      },
      onAuto: () {
        _isAuto = true;
        _fetchNewEvents();
      },
      onManual: () {
        _isAuto = false;
      },
    );
  }
  /// 
  /// Получает новые события из базы данных
  void  _fetchNewEvents() async {
    _log.debug('[._fetchNewEvents] loading down...');
    _log.debug('[._fetchNewEvents] using filter: $_filterText');
    while (_isAuto) {
      final lastEventId = _list.isNotEmpty ? (_list.first as EventListPoint).id : '';
      _fetchUp(lastEventId: lastEventId)
        .then((_) async {
          if (_list.length > _listCount) {
            _log.debug('[._fetchNewEvents] removing unnecessary: ${_list.length - _listCount}');
            _list.removeRange(_list.length - (_list.length - _listCount), _list.length);
          }
          _stateAdd(OperationState.undefined);
        });
      await Future.delayed(Duration(milliseconds: _newEventsReadDelay));
    }
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
  ///   - stateIsLoading (загрузка)
  ///   - stateIsLoaded (загрузка завершена)
  ///   - 0 (новое событие в режиме Авто)
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
  Future<void> _fetchUp({String lastEventId = ''}) async {
    _log.debug('[._fetchUp] loading up...');
    _log.debug('[._fetchUp] using filter: $_filterText');
    // _log.debug('[._fetchUp] loading up($_loadingCount)');
    if (_loadingState != OperationState.inProgress) {
      _loadingState = OperationState.inProgress;
      _stateAdd(_loadingState);
      // final loadingCount = (_loadingCount / 2).round();
      final fromDateTime = _fromDateTime;
      final untilDateTime = _untilDateTime;
      return _fetchWith(
        params: {
          if (_filterText.isNotEmpty || _fromDateTime != null || _untilDateTime != null) 'where': [
            {'operator': 'where', 'field': 'name', 'cond': 'COLLATE UTF8MB4_GENERAL_CI like', 'value': '%$_filterText%'},
              if (fromDateTime != null)
                {'operator': 'and', 'field': 'timestamp', 'cond': '>=', 'value': fromDateTime.toIso8601String()},
              if (untilDateTime != null) 
                {'operator': 'and', 'field': 'timestamp', 'cond': '<=', 'value': untilDateTime.toIso8601String()},
              if (lastEventId.isNotEmpty) 
                {'operator': 'and', 'field': 'uid', 'cond': '>', 'value': lastEventId},
          ] else if (lastEventId.isNotEmpty) 'where': [
            {'operator': 'where', 'field': 'uid', 'cond': '>', 'value': lastEventId},
          ],
          'orderBy': ['uid','name'],
          'order': ['DESC','ASC'],
          'limit': [_loadingCount],
        },
      ).then((response) {
        // _log.debug('[._fetchUp] loadedList: $loadedList');
        _log.debug('[._fetchUp] loadedList.length: ${response.data?.length}');
        // _allLoaded = loadedList.length < loadingCount;
        if (response.hasData) {
          _list.insertAll(0, response.data as List<T>);
        } else if (response.hasError) {
          _showErrorFlushBar(message: response.errorMessage);
        }
        // _log.debug('[._fetchUp] list.length: ${_list.length}');
      }).whenComplete(() {
        _loadingState = OperationState.success;
        _stateAdd(_loadingState);
      });
    }
  }
  ///
  Future<void> _fetchDown({String lastEventId = ''}) async {
    _log.debug('[._fetchDown] loading down...');
    _log.debug('[._fetchDown] using filter: $_filterText');
    if (_loadingState != OperationState.inProgress) {
      _loadingState = OperationState.inProgress;
      _stateAdd(_loadingState);
      final fromDateTime = _fromDateTime;
      final untilDateTime = _untilDateTime;
      return _fetchWith(
        params: {
          if (_filterText.isNotEmpty || _fromDateTime != null || _untilDateTime != null) 'where': [
            {'operator': 'where', 'field': 'name', 'cond': 'COLLATE UTF8MB4_GENERAL_CI like', 'value': '%$_filterText%'},
              if (fromDateTime != null) 
                {'operator': 'and', 'field': 'timestamp', 'cond': '>=', 'value': fromDateTime.toIso8601String()},
              if (untilDateTime != null) 
                {'operator': 'and', 'field': 'timestamp', 'cond': '<=', 'value': untilDateTime.toIso8601String()},
              if (lastEventId.isNotEmpty) 
                {'operator': 'and', 'field': 'uid', 'cond': '<', 'value': lastEventId},
          ] else if (lastEventId.isNotEmpty) 'where': [
            {'operator': 'where', 'field': 'uid', 'cond': '<', 'value': lastEventId},
          ],
          'orderBy': ['uid', 'name'],
          'order': ['DESC', 'ASC'],
          'limit': [_loadingCount],
        },
      ).then((response) {
        // _log.debug('[._fetchDown] loadedList: ${response.data}');
        _log.debug('[._fetchDown] loadedList.length: ${response.data?.length}');
        if (response.hasData) {
          final loadedList = response.data as List<T>;
          // if (loadedList.length < _loadingCount) {
          //   _loadedAll = true;
          // }
          _list.addAll(loadedList);
        } else if (response.hasError) {
          _showErrorFlushBar(message: response.errorMessage);
        }
        // _log.debug('[._fetchDown] list.length: ${_list.length}');
      }).whenComplete(() {
        _loadingState = OperationState.success;
        _stateAdd(_loadingState);
      });
    }
  }
  ///
  void _showErrorFlushBar({String? message}) {
    final context = _context;
    if (context != null) {
      ScaffoldSnackBar(
        header: Text(const Localized('Error retrieving events from the database').v),
        content: Text('${const Localized('Please check connection to the database').v}\n\tDetales: $message'),
        duration: Duration(milliseconds: const Setting('flushBarDurationMedium').toInt,),
      ).show(context);
    }
  }
  ///
  /// Загружает события из базы даннх
  Future<Response<List<DsDataPoint<dynamic>>>> _fetchWith({
    required Map<String, dynamic> params,
  }) {
    _log.debug('[._fetchWith] loading...');
    final eventList = _eventList;
    if (eventList != null) {
      return eventList.fetchWith(
        params: params,
      ).then((response) {
        return response;
      }).onError((error, stackTrace) {
        _log.debug('[._fetchWith] error: $error\nstackTrace: $stackTrace');
        return Response(errCount: 1, errDump: error.toString());
      });
    }
    return Future.value(const Response(data: []));
  }
  //
  @override
  void onTextFilterSubmitted(String value) {
    _log.debug('[.onTextFilterSubmitted] filter value: $value');
    _filterText = value.toLowerCase();
    _list.clear();
    _fetchDown();
  }
  //
  @override
  void onDateFromSubmitted(DateTime? dateTime) {
    _log.debug('[.onDateFromSubmitted] From date: $dateTime');
    _fromDateTime = dateTime;
    _list.clear();
    _fetchDown();
  }
  //
  @override
  void onDateToSubmitted(DateTime? dateTime) {
    _log.debug('[.onDateToSubmitted] To date: $dateTime');
    _untilDateTime = dateTime != null ? dateTime.add(const Duration(days: 1)) : dateTime;
    _list.clear();
    _fetchDown();
  }
  /// Is not in use in this case, 
  /// used only for alarm list
  @override
  void onAcknowledged(T point) {
    // TODO add implementation or remove this block
  }
  //
  @override
  void dispose() {
    for (final controller in _stateControllers) {
      controller.close();
    }
    _isAuto = false;
  }
}
