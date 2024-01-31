import 'dart:convert';

import 'package:dio/dio.dart';

const String _host = "https://gotofun-backend.fly.dev";

class ActivitiesApi {
  final Dio _dio = Dio();

  String get host => _host;

  Future<void> putActivity(Map<String, dynamic> props) async {
    var auth = 'Basic ${base64Encode(utf8.encode('admin:12345'))}';
    await _dio.post<dynamic>(
      '$_host/activities.json',
      data: props,
      options: Options(headers: <String, String>{'authorization': auth}),
    );
  }

  Future<String> token() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '$_host/keys/1',
    );
    return response.data;
  }
}
