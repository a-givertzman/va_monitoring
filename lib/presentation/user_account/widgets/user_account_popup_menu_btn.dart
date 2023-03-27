import 'package:va_monitoring/presentation/core/widgets/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class UserAccountPopupMenuBtn extends StatelessWidget {
  static const _debug = false;
  final void Function(BuildContext context)? _onPaswordChangeSelected; 
  final void Function(BuildContext context)? _onLogoutSelected; 
  const UserAccountPopupMenuBtn({
    Key? key,
    void Function(BuildContext context)? onPaswordChangeSelected,
    void Function(BuildContext context)? onLogoutSelected,
  }) : 
    _onPaswordChangeSelected = onPaswordChangeSelected,
    _onLogoutSelected = onLogoutSelected,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appIcons.accountCircle,
          // const Text('Фильтр',
          //   style: TextStyle(
          //     height: 1.3,
          //     fontSize: 10.5,
          //   ),
          // ),
        ],
      ),
      onSelected: (value) {
      // TODO add implementation or remove this block
      },
      itemBuilder: (BuildContext context) {
        return [
          /// Смена пароля
          PopupMenuItem(
            onTap: () => Future(() {
              final callBack = _onPaswordChangeSelected;
              if (callBack != null) {
                callBack(context);
                log(_debug, '[$UserAccountPopupMenuBtn.PopupMenuItem.onTap] смена пароля');
              }
            }),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/lock_settings.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const SizedBox(width: 8.0,),
                Text(const Localized('Change Password').v),
              ],
            ),
          ),
          /// переход в диалог настроек
          // PopupMenuItem(
          //   child: Row(
          //     children: [
          //       Image.asset(
          //         'assets/icons/ic_access_time.png',
          //         width: 32.0,
          //         height: 32.0,
          //         color: Colors.primaries[9],
          //       ),
          //       const Text(AppText.settingsPage),
          //     ],
          //   ),
          //   onTap: () {
          //   },
          // ),
          /// выход из профиля пользователя
          PopupMenuItem(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/logout.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const SizedBox(width: 8.0,),
                Text(const Localized('User Logout').v),
              ],
            ),
            onTap: () {
              final callBack = _onLogoutSelected;
              if (callBack != null) {
                callBack(context);
                log(_debug, '[$UserAccountPopupMenuBtn.PopupMenuItem.onTap] выход из профиля');
              }
            },
          ),
        ];
      },
    );
  }
}
