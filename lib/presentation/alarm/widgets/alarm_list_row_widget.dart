import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class AlarmListRowWidget extends StatelessWidget {
  final _log = const Log('AlarmListRowWidget');
  final AlarmListPoint _point;
  final bool _highlite;
  final void Function(AlarmListPoint)? _onAcknowledgment;
  ///
  const AlarmListRowWidget({
    Key? key,
    required AlarmListPoint point,
    void Function(AlarmListPoint)? onAcknowledgment,
    bool? highlite,
  }) : 
    _point = point,
    _onAcknowledgment = onAcknowledgment,
    _highlite = highlite ?? false,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    // _log.level = LogLevel.debug;
    const borderColor = Colors.white10;
    final Color? color = _buildColor(context, _point, _highlite);
    // final pointName = EventText(_point.name).local;
    // _log.debug('[.build] pointName: $pointName');
    return GestureDetector(
      onTap: () {
        _showAcnolledgmentDialog(context: context, pointName: _point.name);
      },
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: borderColor),
              ),
              child: Text('${_point.alarm}'),
            ),
          ),
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
            flex: 24,
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
            flex: 34,
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
      ),
    );
  }
  ///
  Color? _buildColor(BuildContext context, AlarmListPoint point, bool highlite) {
    final ararmColors = Theme.of(context).alarmColors;
    if (highlite) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.4);
    }
    final value = double.tryParse('${point.value}') ?? 0;
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
      _log.warning('[._buildColor] alarm class color index "${point.alarm} not found"');
      // _log.debug('[._buildColor] wrong alarm class in point "$point not found"');
      return Theme.of(context).colorScheme.error.withOpacity(0.4);
    }
    if (point.acknowledged) {
      return Theme.of(context).colorScheme.background.withOpacity(0.4);
    }
    return null;
  }
  ///
  void _showAcnolledgmentDialog({required BuildContext context, required DsPointName pointName}) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(
            '${const Localized('Acknowledge the event').v}?',
          ),
          content: Text(
            '${Localized(pointName.path).v} | ${Localized(pointName.name).v}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text(const Localized('Cancel').v),
            ),
            TextButton(
              onPressed: () {
                final onAcknowledgment = _onAcknowledgment;
                if (onAcknowledgment != null) {
                  onAcknowledgment(_point);
                }
                Navigator.of(context).pop();
              }, 
              child: Text(const Localized('Ok').v),
            ),
          ],
        );
      },
    );
  }
}
