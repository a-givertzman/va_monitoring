import 'package:hmi_core/hmi_core.dart';

///
/// Контейнер храняший один DsDataPoint с ID в базе данных
class EventListPoint extends DsDataPoint {
  final String _id;
  ///
  EventListPoint({
    required DsDataPoint point, 
    required String id,
  }) : 
    _id = id,
    super(
      type: point.type,
      name: point.name,
      value: point.value,
      history: point.history,
      alarm: point.alarm,
      status: point.status,
      timestamp: point.timestamp,
    );
  ///
  String get id => _id;
  ///
  factory EventListPoint.fromRow(Map<String, dynamic> row) {
    try {
      return EventListPoint(
        id: row['uid'] as String,
        point: DsDataPoint(
          type: DsDataType.fromString('${row['type']}'),
          name: DsPointName('${row['name']}'),
          value: row['value'],
          history: row['history'] ?? 0,
          alarm: row['alarm'] ?? 0,
          status: DsStatus.fromString('${row['status']}'),
          timestamp: row['timestamp'] as String,
        ),   
      );
    } catch (error) {
      // log(true, '[$DsDataPoint.fromRow] error: $error\nrow: $row');
      // log(ug, '[$DataPoint.fromJson] dataPoint: $dataPoint');
      throw Failure.convertion(
        message: 'Ошибка в методе $EventListPoint.fromRow() $error\n\ton row: $row',
        stackTrace: StackTrace.current,
      );
    }
  }
}