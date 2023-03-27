import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class SignalsStatusesListWidget extends StatelessWidget {
  final double _width;
  final double _itemHeight;
  final SplayTreeMap<String, DsStatus> _signalsStatuses;
  ///
  const SignalsStatusesListWidget({
    Key? key,
    required SplayTreeMap<String, DsStatus> signalsStatuses, 
    required double width, 
    required double itemHeight,
  }) : 
    _signalsStatuses = signalsStatuses, 
    _width = width,
    _itemHeight = itemHeight,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _signalsStatuses.entries
      .map(
        (entry) {
          final theme = Theme.of(context);
          return SizedBox(
            width: _width,
            height: _itemHeight,
            child: Tooltip(
              message: Localized(
                entry.value == DsStatus.ok ? 'Online' : 'Offline',
              ).v,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(const Setting('padding').toDouble),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          Localized(entry.key).v, 
                          overflow: TextOverflow.fade, 
                          softWrap: false,
                        ),
                      ),
                      entry.value == DsStatus.ok
                        ? Icon(
                            Icons.account_tree_sharp,
                            color: theme.stateColors.on,
                          ) 
                        : Icon(
                            Icons.account_tree_outlined,
                            color: theme.stateColors.invalid,
                          ),
                      
                    ],
                  ),
                ),
              ),
            ),
          );
        }, 
      ).toList(),
    );
  }
}