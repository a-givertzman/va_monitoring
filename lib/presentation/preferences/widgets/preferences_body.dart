import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class PreferencesBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  // final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const PreferencesBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    _users = users,
    // _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$PreferencesBody.build]');
    final user = _users.peek;
    // final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    // const dropDownControlButtonWidth = 118.0;
    // const dropDownControlButtonHeight = 44.0;
    if (user.userGroup().value == UserGroupList.admin) {
      // TODO add implementation or remove this block
    }
    return StreamBuilder<List<dynamic>>(
      // stream: dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: () {
            return Future<List<String>>.value([]);
            // return source.refresh();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Row 1
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(const Localized('Preferences page').v),
                    /// Кнопки управления режимом
                    SizedBox(width: blockPadding,),
                    SizedBox(width: blockPadding,),
                  ],
                ),
                SizedBox(height: blockPadding,),
                /// Row 2
                // SizedBox(height: blockPadding,),
                /// Row 3
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
