import 'dart:convert';

import 'package:dio/dio.dart';

import '../../config.dart';

class ActivitiesApi {
  final Dio _dio = Dio();

  Future<void> putActivity(Map<String, dynamic> props) async {
    var auth = 'Basic ${base64Encode(utf8.encode('admin:12345'))}';
    await _dio.post<dynamic>(
      '$backendApiHost/activities.json',
      data: props,
      options: Options(headers: <String, String>{'authorization': auth}),
    );
  }

  Future<String> token() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '$backendApiHost/keys/1',
    );
    return response.data;
  }
}
