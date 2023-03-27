import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'signals_statuses_list_widget.dart';

///
class ConnectionStatusIndicator extends StatefulWidget {
  final Stream<DsDataPoint> _stream;
  final Setting _menuWidth;
  final Setting _menuItemHeight;
  ///
  const ConnectionStatusIndicator({
    super.key,
    required Stream<DsDataPoint> stream,
    Setting menuWidth = const Setting('connectionStatusMenuWidth'),
    Setting menuItemHeight = const Setting('connectionStatusMenuItemHeight'),
  }) : 
    _stream = stream,
    _menuWidth = menuWidth,
    _menuItemHeight = menuItemHeight;

  //
  @override
  State<ConnectionStatusIndicator> createState() => _ConnectionStatusIndicatorState(
    stream: _stream,
    menuWidth: _menuWidth,
    menuItemHeight: _menuItemHeight,
  );
}
///
class _ConnectionStatusIndicatorState extends State<ConnectionStatusIndicator> {
  static const String _serverConnectionSignal = '/Local/Local.System.Connection';
  final Map<String, DsStatus> _signalsStatuses = {};
  final Stream<DsDataPoint> _stream;
  final Setting _menuWidth;
  final Setting _menuItemHeight;
  late final StreamSubscription<DsDataPoint> _subscription;
  OverlayEntry? _overlayEntry;
  ///
  _ConnectionStatusIndicatorState({
    required Stream<DsDataPoint> stream,
    required Setting menuWidth,
    required Setting menuItemHeight,
  }) : 
    _stream = stream,
    _menuWidth = menuWidth,
    _menuItemHeight = menuItemHeight;
  //
  @override
  void initState() {
    _subscription  = _stream.listen((event) {
      final eventStatus = DsStatus.fromValue(event.value as int);
      final eventName = event.name.toString();
      _signalsStatuses[eventName] = eventStatus;
      if (eventName == _serverConnectionSignal && eventStatus != DsStatus.ok) {
        for (final key in _signalsStatuses.keys) {
          _signalsStatuses[key] = eventStatus;
        }
      }
      if (mounted) {
        setState(() {return;});
        // reopen overlay on new state
        if (_overlayEntry != null) {
          _toggleStatuses(context);
          _toggleStatuses(context);
        }
      }
    });
    super.initState();
  }
  //
  @override
  void dispose() {
    _subscription.cancel();
    _removeOverlayEntry();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: const Localized('Connection to devices').v,
      onPressed: () => _toggleStatuses(context), 
      icon: _buildIcon(
        context,
        _buildStatus(_signalsStatuses),
      ),
    );
  }
  ///
  DsStatus _buildStatus(Map<String, DsStatus> signalsStatuses) {
    DsStatus resultStatus = DsStatus.ok;
    for (final status in signalsStatuses.values) {
      if (status.value > resultStatus.value) {
        resultStatus = status;
      }
    }
    return resultStatus;
  }
  ///
  Widget _buildIcon(BuildContext context, DsStatus status) {
    if (status == DsStatus.ok) {
      return Icon(
        Icons.account_tree_sharp,
        color: Theme.of(context).stateColors.on,
      );
    }
    if (status == DsStatus.obsolete) {
      return Icon(
        Icons.account_tree_sharp,
        color: Theme.of(context).stateColors.obsolete,
      );
    }
    if (status == DsStatus.timeInvalid) {
      return Icon(
        Icons.account_tree_sharp,
        color: Theme.of(context).stateColors.timeInvalid,
      );
    }
    if (status == DsStatus.invalid) {
      return Icon(
        Icons.account_tree_outlined,
        color: Theme.of(context).stateColors.invalid,
      );
    }
    return Text(const Localized('Undefined').v);
  }
  ///
  void _toggleStatuses(BuildContext context) {
    if (_overlayEntry != null) {
      _removeOverlayEntry();
    } else {
      final overlayState = Overlay.of(context);
      final RenderBox box = context.findRenderObject()! as RenderBox;
      final Offset position = box.localToGlobal(
        box.size.center(Offset.zero),
        ancestor: overlayState.context.findRenderObject(),
      );
      _overlayEntry = OverlayEntry(
          builder: (_) => Positioned(
            top: position.dy,
            left: position.dx - _menuWidth.toDouble,
            child: SignalsStatusesListWidget(
              signalsStatuses: SplayTreeMap.from(_signalsStatuses),
              width: _menuWidth.toDouble,
              itemHeight: _menuItemHeight.toDouble,
            ),
          ),
        );
      overlayState.insert(_overlayEntry!);
    }
  }
  ///
  void _removeOverlayEntry() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }
}
