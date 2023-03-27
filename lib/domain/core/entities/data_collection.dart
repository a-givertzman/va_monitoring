// ignore_for_file: no_runtimetype_tostring
import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

/// Класс реализует список загрузку списка элементов
/// 
/// Бедет создан с id  и удаленным источником данных
/// при вызове метода fetch будет читать записи из источника
/// и формировать из каждой записи экземпляр класса PurchaseProduct
class DataCollection<T> {
  static const _debug = false;
  final DataSet<Map<String, dynamic>> remote;
  final _streamController = StreamController<List<T>>();
  final T Function(Map<String, dynamic>) dataMaper;
  ///
  Stream<List<T>> get dataStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }
  ///
  DataCollection({
    required this.remote,
    required this.dataMaper,
  });
  ///
  Future<void> refresh() {
    return _dispatch();
  }
  ///
  Future<void> _dispatch() {
    log(_debug, '[$runtimeType($DataCollection)._dispatch]');
    // _streamController.sink.add(List.empty());
    return fetch()
      .then(
        (response) {
          if (response.hasData) {
            final List<T> data = [];
            final responseData = response.data;
            if (responseData != null) {
              for (final element in responseData) { 
                data.add(element);
              }
              _streamController.sink.add(data);
            }
          }
        },
      )
      .catchError((e) {
        log(_debug, '[$runtimeType($DataCollection)._dispatch handleError]', e);
        _streamController.addError(e as Object);
      });
  }
  ///
  Future<Response<List<T>>> fetchWith({required Map<String, dynamic> params}) {
    log(_debug, '[$runtimeType($DataCollection).fetchWith]');
    return remote
      .fetchWith(params: params)
      .then((response) => _fetchOnSuccess(response))
      .onError((error, stackTrace) => _fetchOnFailure(error, stackTrace));  
  }
  ///
  Future<Response<List<T>>> fetch() {
    log(_debug, '[$runtimeType($DataCollection).fetch]');
    return remote
      .fetch()
      .then((response) => _fetchOnSuccess(response))
      .onError((error, stackTrace) => _fetchOnFailure(error, stackTrace));  
  }
  ///
  Response<List<T>> _fetchOnSuccess(Response<Map<String, dynamic>> response) {
    log(_debug, '[$runtimeType._fetchOnSuccess] response: $response');
    if (response.hasError) {
      return Response(
        errCount: response.errorCount,
        errDump: response.errorMessage,
      );
      // throw Failure(
      //   message: response.errorMessage(),
      //   stackTrace: StackTrace.empty,
      // );
    }
    final sqlList = response.data;
    final List<T> list = [];
    if (sqlList != null) {
      sqlList.forEach((key, row) {
        final p = dataMaper(row as Map<String, dynamic>);
        list.add(p);
      });
    }
    return Response(data: list);
  }
  ///
  Future<Response<List<T>>> _fetchOnFailure(Object? error, StackTrace stackTrace) {
    throw Failure.dataCollection(
      message: 'Ошибка в методе fetchWith класса $runtimeType($DataCollection):\n$error',
      stackTrace: stackTrace,
    );
  }
}
