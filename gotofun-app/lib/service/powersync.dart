import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gotofun/model/activity.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3.dart';

// create_table "activities", force: :cascade do |t|
//   t.string "title"
//   t.text "description"
//   t.decimal "lat", precision: 10, scale: 6
//   t.decimal "long", precision: 10, scale: 6
//   t.datetime "created_at", null: false
//   t.datetime "updated_at", null: false
// end
const schema = Schema([
  Table('activities', [
    Column.text('title'),
    Column.text('description'),
    Column.text('lat'),
    Column.text('long'),
    Column.text('created_at'),
    Column.text('updated_at')
  ])
]);

late PowerSyncDatabase db;

addActivity(String title, String description, double lat, double long) async {
  await db.execute(
      'INSERT INTO activities(id, title, description, lat, long, created_at, updated_at) VALUES(uuid(),?, ?, ?, ?, ?, ?)',
      [title, description, lat, long, DateTime.now().toIso8601String(), DateTime.now().toIso8601String()]);
}

connectPowerSync() async {
  // DevConnector stores credentials in-memory by default.
  // Extend the class to persist credentials.
  final connector = SimpleConnector();

  try {
    // Connect to PowerSync service and start sync.
    db.connect(connector: connector);
    print("connected to powersync, we hope");
  } catch (e) {
    print("not able to connect to powersync");
    print(e);
  }
}

openDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final path = join(dir.path, 'powersync-dart.db');
  // Setup the database.
  db = PowerSyncDatabase(schema: schema, path: path);
  await db.initialize();

  // Run local statements.
  final time = DateTime.now().toIso8601String();
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

class SimpleConnector extends PowerSyncBackendConnector {
  final Dio _dio = Dio();

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    print("fetching credentials");
    final Box<String> settings = Hive.box<String>('settings');
    final String host = settings.get('host') ?? 'https://gotofun-backend.fly.dev';
    final Response<dynamic> response = await _dio.get<dynamic>(
      '$host/keys/1',
    );
    String endpoint = "https://65a8f82ce4d47fade98f24dd.powersync.journeyapps.com";
    String token = response.data;
    DateTime? expiresAt = getExpiryDate(token);
    return PowerSyncCredentials(endpoint: endpoint, expiresAt: expiresAt, token: token, userId: '');
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getCrudBatch();
    if (transaction == null) return Future.value();
    for (var op in transaction.crud) {
      if (op.op == UpdateType.put) {
        var auth = 'Basic ${base64Encode(utf8.encode('admin:12345'))}';
        final Response<dynamic> response = await _dio.post<dynamic>(
          'http://192.168.3.173:3000/activities.json',
          data: op.opData,
          options: Options(headers: <String, String>{'authorization': auth}),
        );
        print(response.data);
      }
    }
    await transaction.complete();
    return Future.value();
  }

  static DateTime? getExpiryDate(String token) {
    try {
      List<String> parts = token.split('.');
      if (parts.length == 3) {
        String part = parts[1];
        if (part.length % 4 > 0) {
          part += '=' * (4 - part.length % 4);
        }
        final rawData = base64Decode(part);
        final text = const Utf8Decoder().convert(rawData);
        Map<String, dynamic> payload = jsonDecode(text);
        if (payload.containsKey('exp') && payload['exp'] is int) {
          return DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
        }
      }
      return null;
    } catch (e) {
      print("error getting expiry date");
      print(e);
      return null;
    }
  }
}
