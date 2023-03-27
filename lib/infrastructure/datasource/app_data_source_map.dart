import 'package:hmi_networking/hmi_networking.dart';

///
final dataSourceMap = {
  ///
  ///пользователь системы
  'app-user': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'app_user',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-app-user',
      port: 8080,
    ),
  ),
  'app-user-test': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'app_user_test',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-app-user',
      port: 8080,
    ),
  ),
  'event': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'event_view',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-event',
      port: 8080,
    ),
  ),
  'report': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'insert',
      'tableName': 'report',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '',
      port: 8080,
    ),
  ),
};
