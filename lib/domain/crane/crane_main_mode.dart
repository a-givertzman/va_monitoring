import 'package:hmi_core/hmi_core.dart';

/// основной работы крана - значения
enum CraneMainModeValue {
  loading(stateIsLoading),
  modeUndefined(0),
  hurbour(1),
  theSea(2);
  ///
  const CraneMainModeValue(this.value);
  ///
  final num value;
}
