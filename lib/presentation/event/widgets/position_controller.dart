import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class PositionController {
  static const _debug = false;
  final ScrollController _controller;
  // final double _cacheExtent;
  bool _isAtBottom = false;
  bool _isAtTop = false;
  bool _isAuto = true;
  double _y = 0;
  DateTime _t = DateTime.now();
  ///
  PositionController({
    required ScrollController controller,
    // double? cacheExtent,
  }) :
    _controller = controller;
    // _cacheExtent = cacheExtent ?? 0.0;
  ///
  /// Производная позиции по времени
  double _dYdT(double position) {
    final dy = position - _y;
    _y = position;
    final dt = DateTime.now().difference(_t).inMilliseconds;
    _t = DateTime.now();
    return dy / dt;
  }
  ///
  /// Поток событий при изменении позиции полосы прокрутки:
  ///   - [onTop] (double dYdT) - когда полоса прокрутки находится у верхнего края и ее тянут в верх,
  ///     [dYdT] - скорость изменения позиции
  ///   - [onBottom] (double dYdT) - когда полоса прокрутки находится у нижнего края и ее тянут в вниз,
  ///     [dYdT] - скорость изменения позиции
  ///   - [onDown] (double dYdT) - когда полоса прокрутки идет вниз, для возможности очиски черезмерно длинного списка при движении вниз
  ///     [dYdT] - скорость изменения позиции
  ///   - [onAuto] переход в режим Авто, когда полоса прокрутки прилипла вверх и происходит автонаполнение списка сверху
  ///   - [onManual] отключение режима Авто, когда полоса прокрутки вышла из верхнего положения
  void listen({
    void Function(double dYdT)? onTop,
    void Function(double dYdT)? onBottom,
    void Function(double dYdT)? onDown,
    void Function()? onAuto,
    void Function()? onManual,
  }) {
    _controller.addListener(() {
      final pos = _controller.position;
      final dYdT = _dYdT(pos.pixels);
      final delta = _controller.position.viewportDimension * 0.1;
      log(_debug, '[$PositionController._controller] dYdT: $dYdT');
      // log(_debug, '[$PositionController._controller] pos: $pos');
      if ((pos.pixels > pos.minScrollExtent) && (pos.pixels <= (pos.minScrollExtent + delta)) && (dYdT < 0)) {
        _atTopAction(pos, onTop, dYdT);
      } else {
        _isAtTop = false;
      }
      if (dYdT > 0) {
        // log(_debug, '[$PositionController._controller] goDown');
        if (onDown != null) {
          onDown(dYdT);
        }
      }
      if ((pos.pixels >= (pos.maxScrollExtent - delta * 4)) && (dYdT > 0)) {
        _atBottomAction(onBottom, dYdT);
      } else {
        _isAtBottom = false;
      }
      if (pos.pixels <= pos.minScrollExtent) {
        if (!_isAuto) {
          _isAuto = true;
          log(_debug, '[$PositionController._controller] auto');
          if (onAuto != null) {
            onAuto();
          }
        }
      } else {
        if (_isAuto) {
          _isAuto = false;
          log(_debug, '[$PositionController._controller] manual');
          if (onManual != null) {
            onManual();
          }
        }
      }
    });
  }
  ///
  void _atTopAction(ScrollPosition pos, void Function(double dYdT)? onTop, double dYdT) {
    if (!_isAtTop) {
      _isAtTop = true;
      _controller.animateTo(
        pos.minScrollExtent - 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.bounceIn,
      );
      log(_debug, '[$PositionController._controller] topPos');
      if (onTop != null) {
        onTop(dYdT);
      }
    }
  }
  ///
  void _atBottomAction(void Function(double dYdT)? onBottom, double dYdT) {
    if (!_isAtBottom) {
      _isAtBottom = true;
      log(_debug, '[$PositionController._controller] bottomPos');
      if (onBottom != null) {
        onBottom(dYdT);
      }
    }
  }
}
