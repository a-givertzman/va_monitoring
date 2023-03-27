import 'package:va_monitoring/domain/alarm/event_list_point.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Контейнер храняший один DsDataPoint со статусом [active]
/// для отображения в списке аварий
class AlarmListPoint<T> extends EventListPoint {
  final bool _active;
  final bool _acknowledged;
  ///
  AlarmListPoint({
    required DsDataPoint<T> point, 
    required bool active,
    required bool acknowledged,
  }) : 
    _active = active,
    _acknowledged = acknowledged,
    super(
      id: '0',
      point: point,
    );
  ///
  bool get active => _active;
  ///
  bool get acknowledged => _acknowledged;
}