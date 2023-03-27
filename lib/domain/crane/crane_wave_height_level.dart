import 'package:hmi_core/hmi_core.dart';

/// Уровень высоты волны SWH - значения
enum CraneWaveHeightLevel {
  isEnabled(stateIsEnabled),
  isDisabled(stateIsDisabled),
  loading(stateIsLoading),
  levelUndefined(0),
  level0(1),
  level1(2),
  level2(3),
  level3(4),
  level4(5),
  level5(6),
  level6(7),
  level7(8),
  level8(9),
  level9(10),
  level10(11),
  level11(12),
  level12(13);
  ///
  const CraneWaveHeightLevel(this.value);
  ///
  final num value;
}
