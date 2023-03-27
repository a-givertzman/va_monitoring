import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class DiagnosticBody extends StatelessWidget {
  static const _debug = true;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const DiagnosticBody({
    Key? key,
    required DsClient dsClient,
  }) : 
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$DiagnosticBody.build]');
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });
    return Column(
      children: [
        // Row 1
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(width: 250.0),
              // const Expanded(child: Text('')),
              // const SizedBox(width: 64.0),
              Image.asset(
                'assets/img/brand_icon.png',
                scale: 9.0,
                opacity: const AlwaysStoppedAnimation<double>(0.5),
              ),
              // const SizedBox(width: 64.0),
              // const Expanded(child: Text('')),
              /// Индикатор | Связь
              // StatusIndicatorWidget(
              //   indicator: SpsIconIndicator(
              //     trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
              //     falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).colorScheme.background),
              //     stream: _dsClient.streamBool('Local.System.Connection'),
              //   ), 
              //   caption: Text(const Localized('Connection').v), 
              // ),
            ],
          ),
        ),
        SizedBox(height: blockPadding,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                StatusIndicatorWidget(
                  indicator: SpsIconIndicator(
                    trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                    falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).colorScheme.background),
                    stream: _dsClient.streamBool('system.db899_drive_data_exhibit.status'),

                  ), 
                  caption: Text(const Localized('IED11.db899_drive_data_exhibit').v), 
                ),
                StatusIndicatorWidget(
                  indicator: SpsIconIndicator(
                    trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                    falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).colorScheme.background),
                    stream: _dsClient.streamBool('system.db902_panel_controls.status'),
                  ), 
                  caption: Text(const Localized('IED11.db902_panel_controls').v), 
                ),
                StatusIndicatorWidget(
                  indicator: SpsIconIndicator(
                    trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                    falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).colorScheme.background),
                    stream: _dsClient.streamBool('system.db906_visual_data.status'),
                  ), 
                  caption: Text(const Localized('IED11.db906_visual_data').v), 
                ),
                SizedBox(height: blockPadding),
                TextButton(
                  onPressed: () {
                    throw Failure.connection(message: 'Connection error', stackTrace: StackTrace.current);
                  }, 
                  child: Text(const Localized('Raise error').v),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
