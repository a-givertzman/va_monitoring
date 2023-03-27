import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class CriticalErrorWidget extends StatelessWidget {
  static const _debug = false;
  final String message;
  final Future<dynamic> Function() refresh;
  const CriticalErrorWidget({
    Key? key,
    required this.message,
    required this.refresh,
  }) : super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // это оцентрирует по верикали
        children: <Widget>[
          Text(
            const Localized('Reading data error').v,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 4,),
          TextButton(
            onPressed: () {
              log(_debug, 'Please Implemente the Sending email on critical error');
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mail),
                const SizedBox(width: 4,),
                Text(
                  const Localized('Send error report').v,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              refresh();
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh),
                const SizedBox(width: 4,),
                Text(
                  const Localized('Reload').v,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
