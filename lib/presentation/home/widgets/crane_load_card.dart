import 'package:va_monitoring/presentation/core/widgets/crane_load_widget.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/core/widgets/common_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class CraneLoadCard extends StatelessWidget {
  final DsClient _dsClient;
  final SwlData _swlData;
  ///
  const CraneLoadCard({
    Key? key,
    required DsClient dsClient, 
    required SwlData swlData,
  }) : 
    _dsClient = dsClient, 
    _swlData = swlData,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return CommonContainerWidget(
      children: [
        CraneLoadWidget(
          swlIndexStream: _dsClient.streamInt('CraneMode.LoadIndex'),
          xStream: _dsClient.streamReal('Hook.X'),
          yStream: _dsClient.streamReal('Hook.Y'),
          xAxisValue: 5.0, 
          yAxisValue: 5.0, 
          showGrid: true, 
          swlDataCache: SwlDataCache(
            swlDataConverter: SwlDataConverter(
              swlData: _swlData,
              rawWidth: 20.0, 
              rawHeight: 27.0, 
              width: 450.0,
              height: 450.0,
              legendData: CraneLoadChartLegendData(
                legendJson: CraneLoadChartLegendJson(
                  jsonList: JsonList.fromTextFile(
                    const TextFile.asset('assets/swl/legend.json'),
                  ),
                ),
              ),
            ),
          ),
          axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          pointSize: 1.0,
        ),
      ],
    );
  }
}
