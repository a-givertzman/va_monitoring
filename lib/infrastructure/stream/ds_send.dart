import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

///
/// Sends value of type [T] to the DataServer
class DsSend<T> {
  static const Map _types = {
    bool: DsDataType.bool,
    int: DsDataType.integer,
    double: DsDataType.real,
  };
  final DsClient _dsClient;
  final DsPointName _pointName;
  final String? _response;
  ///
  /// [path] - path identifies DataServer Point
  /// [name] - name identifies DataServer Point
  /// [response] - name identifies DataServer Point to read written value
  /// if [response] not set then [name] will be used to read response
  DsSend({
    required DsClient dsClient,
    required DsPointName pointName,
    String? response,
  }) : 
    assert(_types.containsKey(T)),
    _dsClient = dsClient,
    _pointName = pointName,
    _response = response;
  ///
  Future<DsDataPoint<T>> exec(T value) {
    _dsClient.send(DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: _types[T], 
      name: _pointName.toString(), 
      value: value, 
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now(),
    ));
    final response = _response;
    if (response != null) {
      return _dsClient.stream<T>(response).first;
    } else {
      return _dsClient.stream<T>(_pointName.name).first;
    }
  }
}