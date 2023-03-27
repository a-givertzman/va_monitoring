import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Reads alarm tag names for [AlarmListDataSource]
/// from assets json file
class AlarmData {
  static const _debug = true;
  final String _assetName;
  Map<String, Map<String, dynamic>>? _data;
  ///
  AlarmData({
    required String assetName,
  }) :
    _assetName = assetName;
  ///
  /// List of alarm tag names
  Future<List<String>> names() async {
    if (_data == null) {
      await _loadAsset(_assetName)
        .then((value) {
          _data = value;
        });
    }
    final namesList = _data!.keys.toList();
    log(_debug, '[$AlarmData.names] namesList: ', namesList);
    return Future.value(namesList);
  }
  ///
  Future<Map<String, Map<String, dynamic>>> _loadAsset(String assetName) {
    return rootBundle.loadString(assetName)
      .then((value) {
        final jsonResult = json.decode(value) as Map<String, dynamic>;
        return jsonResult.map((key, value) {
          return MapEntry(
            key, 
            value as Map<String, dynamic>,
          );
        });
      })
      .onError((error, stackTrace) {
        throw Failure.unexpected(
          message: 'Ошибка в методе _loadAsset класса $runtimeType:\n$error',
          stackTrace: stackTrace,
        );        
      });
  }  
}