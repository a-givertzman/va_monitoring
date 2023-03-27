import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class EventListRowWidget extends StatelessWidget {
  static const _debug = false;
  final DsDataPoint _point;
  final bool _highlite;
  ///
  const EventListRowWidget({
    Key? key,
    required DsDataPoint point,
    bool? highlite,
  }) : 
    _point = point,
    _highlite = highlite ?? false,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.white10;
    // final errorColor = Theme.of(context).colorScheme.error.withOpacity(0.4);
    final color = _buildColor(context, _point, _highlite);
    return Row(
      children: [
        Expanded(
          flex: 22,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: borderColor),
            ),
            child: Text(_point.timestamp),
          ),
        ),
        Expanded(
          flex: 25,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: borderColor),
            ),
            child: Text(Localized(_point.name.path).v),
          ),
        ),
        Expanded(
          flex: 37,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: borderColor),
            ),
            child: Text(Localized(_point.name.name).v),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: borderColor),
            ),
            child: Text('${_point.value}'),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: borderColor),
            ),
            child: Text(_point.status.name),
          ),
        ),
      ],
    );
  }
  ///
  Color? _buildColor(BuildContext context, DsDataPoint point, bool highlite) {
    final ararmColors = Theme.of(context).alarmColors;
    if (point.status == DsStatus.invalid) {
      return Theme.of(context).stateColors.invalid.withOpacity(0.2);
    }
    if (highlite) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.4);
    }
    final value = double.tryParse(point.value) ?? 0;
    if (value > 0) {
      if (point.alarm == 1) {
        return ararmColors.class1.withOpacity(0.4);
      }
      if (point.alarm == 2) {
        return ararmColors.class2.withOpacity(0.4);
      }
      if (point.alarm == 3) {
        return ararmColors.class3.withOpacity(0.4);
      }
      if (point.alarm == 4) {
        return ararmColors.class4.withOpacity(0.4);
      }
      if (point.alarm == 5) {
        return ararmColors.class5.withOpacity(0.4);
      }
      if (point.alarm == 6) {
        return ararmColors.class6.withOpacity(0.4);
      }
      log(_debug, 'WARNING: [$EventListRowWidget._buildColor] alarm class color index "${point.alarm} not found"');
      return Theme.of(context).colorScheme.primary.withOpacity(0.4);
      // return Theme.of(context).colorScheme.error.withOpacity(0.4);
    }
    return null;
  }
}
