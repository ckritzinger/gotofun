import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../model/activity.dart';

class ActivitiesProvider {
  static final ActivitiesProvider instance = ActivitiesProvider();

  final Dio _dio = Dio();

  final List<Activity> _activities = <Activity>[];

  List<Activity> get activities => _activities;

  Future<void> fetchActivities() async {
    final Box<String> settings = Hive.box<String>('settings');
    final String host = settings.get('host') ?? 'https://gotofun-backend.onrender.com';
    final Response<dynamic> response = await _dio.get<dynamic>(
      '$host/activities.json',
    );
    _activities.clear();
    _activities.addAll(response.data.map<Activity>((dynamic json) {
      return Activity.fromJson(json as Map<String, dynamic>);
    }));
  }
}
