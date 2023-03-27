import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

class ScaffoldSnackBar {
  final Widget? _header;
  final Widget _content;
  final SnackBarAction? _action;
  final Duration? _duration;
  ///
  const ScaffoldSnackBar({
    Widget? header, 
    required Widget content, 
    SnackBarAction? action,
    Duration? duration,
  }) :
    _header = header,
    _content = content,
    _action = action,
    _duration = duration;
  void show(BuildContext context) {
    final header = _header;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(children: [
              if (header != null) Title(
                color: Colors.yellow,
                child: header,
              ),
              _content,
            ],
        ),
        action: _action,
        showCloseIcon: true,
        duration: _duration?? Duration(
          milliseconds: const Setting('flushBarDurationMedium').toInt,
        ),
      ),
    );
  }
}
