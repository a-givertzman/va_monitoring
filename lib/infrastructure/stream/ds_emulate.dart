import 'dart:async';
import 'package:hmi_core/hmi_core.dart';

///
Stream<DsDataPoint<int>> emulateIntStream(int min, int max, {required int delay}) async* {
  while (true) {
    for (final status in [
      DsStatus.obsolete, 
      DsStatus.invalid, 
      DsStatus.timeInvalid, 
      DsStatus.ok,
    ]) {
      for (int value = min; value <= max; value++) {
        await Future.delayed(
          Duration(milliseconds: delay), 
        );
        yield DsDataPoint(
          type: DsDataType.dInt,
          name: DsPointName('/emulated'),
          value: value,
          status: status,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    }
  }
}

///
class EmulateInUseStream {
  final StreamController<DsDataPoint<int>> _controller;
  ///
  EmulateInUseStream() : _controller = StreamController();
  ///
  Stream<DsDataPoint<int>> get stream {
    return _controller.stream;
  }
  ///
  void add(int value) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        _controller.add(
          DsDataPoint(
            type: DsDataType.dInt,
            name: DsPointName('/emulated'),
            value: value,
            status: DsStatus.ok,
            timestamp: DateTime.now().toIso8601String(),
          ),
        );
      },
    );
  }
}
