import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class CraneLoadWidget extends StatelessWidget {
  final Stream<DsDataPoint<int>>? _swlIndexStream;
  final Stream<DsDataPoint<double>> _xStream;
  final Stream<DsDataPoint<double>> _yStream;
  final double _xAxisValue;
  final double _yAxisValue;
  final bool _showGrid;
  final SwlDataCache _swlDataCache;
  final Color _backgroundColor;
  final Color? _axisColor;
  final double _pointSize;
  ///
  const CraneLoadWidget({
    Key? key,
    Stream<DsDataPoint<int>>? swlIndexStream,
    required Stream<DsDataPoint<double>> xStream,
    required Stream<DsDataPoint<double>> yStream,
    required double xAxisValue,
    required double yAxisValue,
    bool showGrid = false,
    required SwlDataCache swlDataCache,
    Color backgroundColor = Colors.transparent,
    Color? axisColor,
    double pointSize = 1.0,
  }) : 
    _swlIndexStream = swlIndexStream,
    _xStream = xStream,
    _yStream = yStream,
    _xAxisValue = xAxisValue,
    _yAxisValue = yAxisValue,
    _showGrid = showGrid,
    _swlDataCache = swlDataCache,
    _backgroundColor = backgroundColor,
    _axisColor = axisColor,
    _pointSize = pointSize,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CraneLoadChart(
          legendWidth: 64,
          swlIndexStream: _swlIndexStream,
          xAxisValue: _xAxisValue,
          yAxisValue: _yAxisValue,
          showGrid: _showGrid,
          backgroundColor: _backgroundColor, 
          axisColor: _axisColor,
          pointSize: _pointSize, 
          swlDataCache: _swlDataCache,
        ),
        CranePositionChart(
          xStream: _xStream,
          yStream: _yStream,
          width: _swlDataCache.width, 
          height: _swlDataCache.height, 
          rawWidth: _swlDataCache.rawWidth, 
          rawHeight: _swlDataCache.rawHeight,
        ),
      ],
    );
  }
}
