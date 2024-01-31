import 'package:powersync/sqlite3.dart';

import '../model/activity.dart';
import 'powersync.dart';

class ActivitiesProvider {
  static final ActivitiesProvider instance = ActivitiesProvider();
  addActivity(String title, String description, double lat, double long) async {
    await db.execute(
        'INSERT INTO activities(id, title, description, lat, long, created_at, updated_at) VALUES(uuid(),?, ?, ?, ?, ?, ?)',
        [title, description, lat, long, DateTime.now().toIso8601String(), DateTime.now().toIso8601String()]);
  }

  List<Activity> resultsSetToActivityList(ResultSet resultSet) {
    final List<Activity> activities = [];
    final Iterator<Row> rows = resultSet.iterator;
    while (rows.moveNext()) {
      final Row row = rows.current;
      activities.add(Activity(
        title: row['title'] as String,
        description: row['description'] as String,
        lat: row['lat'] as String,
        long: row['long'] as String,
      ));
    }
    return activities;
  }

  Stream<List<Activity>> watchActivities() {
    return db.watch('SELECT * FROM activities order by created_at asc').map(resultsSetToActivityList);
  }
}
