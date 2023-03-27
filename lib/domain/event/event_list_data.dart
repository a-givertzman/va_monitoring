import 'dart:async';

import 'package:hmi_core/hmi_core_opration_state.dart';

///
/// Интерфейс класса который:
///   Хранит все активные и неактивные не сквитированные события,
///   События получает из основного потока Stream<DsDataPoint>
abstract class EventListData<T> {
  /// Поток состояний для ListWiew.builder:
  ///   - 0 (новое событие)
  Stream<OperationState> get stateStream;
  ///
  /// Список элементов для ListView
  List<T> get list;
  ///
  /// Call this method if text filter modified
  void onTextFilterSubmitted(String value);
  ///
  /// Call this method if "From" date modified
  void onDateFromSubmitted(DateTime? dateTime);
  ///
  /// Call this method if "To" date modified
  void onDateToSubmitted(DateTime? dateTime);
  ///
  /// Квитирует событие, если оно перешло в неаварийное значение (0)
  void onAcknowledged(T point);
  ///
  void dispose();
}
