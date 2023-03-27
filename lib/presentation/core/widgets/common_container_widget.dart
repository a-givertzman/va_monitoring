import 'package:va_monitoring/settings/common_settings.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class CommonContainerWidget extends StatelessWidget {
  static const _debug = true;
  final Widget? _header;
  final List<Widget> _children;
  final double? _width;
  final double? _height;
  final double _padding;
  final bool _disabled;
  ///
  const CommonContainerWidget({
    Key? key,
    Widget? header,
    Widget? footer,
    required List<Widget> children,
    double? width,
    double? height,
    double? padding,
    bool? disabled,
  }) : 
    _header = header,
    _children = children,
    _width = width,
    _height = height,
    _padding = padding ?? 8.0,
    _disabled = disabled ?? false,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$CommonContainerWidget.build]');
    // final scale = max(_width ?? _defaultSize, _height ?? _defaultSize) / (1.816 * 128);
    final width = _width;
    final height = _height;
    if ((width != null) && (height != null)) {
      return SizedBox(
        width: _width,
        height: _height,
        child: ColorFiltered(
          colorFilter: AppUiSettings.colorFilterDisabled(context, _disabled),
          child: Card(
            child: FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  for ( var child in _children ) ...[
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: child,
                    ),
                    if (_children.length > 1) SizedBox(height: _padding * 0.5,),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ColorFiltered(
      colorFilter: AppUiSettings.colorFilterDisabled(context, _disabled),
      child: Card(
            child: Padding(
              padding: EdgeInsets.all(_padding),
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    for ( var child in _children ) Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        child,
                        if (_children.length > 1) SizedBox(height: _padding),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
  ///
  Widget _buildHeader(BuildContext context) {
    final header = _header;
    if (header != null) {
      final width = _width;
      final height = _height;
      if ((width != null) && (height != null)) {
        return Padding(
          padding: EdgeInsets.only(bottom: _padding),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: header,
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.only(bottom: _padding),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: header,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
