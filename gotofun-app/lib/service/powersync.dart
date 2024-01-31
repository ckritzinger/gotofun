import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gotofun/service/activities_api.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';

const String powersyncInstanceEndpoint = "https://65a8f82ce4d47fade98f24dd.powersync.journeyapps.com";
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

connectPowerSync() async {
  // DevConnector stores credentials in-memory by default.
  // Extend the class to persist credentials.
  final connector = SimpleConnector();

  try {
    // Connect to PowerSync service and start sync.
    db.connect(connector: connector);
  } catch (e) {
    Logger.root.severe('Failed to connect to PowerSync service: $e');
  }
}

openDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final path = join(dir.path, 'powersync-dart.db');
  // Setup the database.
  db = PowerSyncDatabase(schema: schema, path: path);
  await db.initialize();
}

class SimpleConnector extends PowerSyncBackendConnector {
  final Dio _dio = Dio();
  final ActivitiesApi _api = ActivitiesApi();

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final token = await _api.token();
    DateTime? expiresAt = getExpiryDate(token);
    return PowerSyncCredentials(endpoint: powersyncInstanceEndpoint, expiresAt: expiresAt, token: token, userId: '');
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getCrudBatch();
    if (transaction == null) return Future.value();
    for (var op in transaction.crud) {
      if (op.op == UpdateType.put) {
        print(op.table);
        await _api.putActivity(op.opData!);
      }
    }
    await transaction.complete();
    return Future.value();
  }

  // the function in the original code doesn't handle Base64 without padding
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
      Logger.root.warning('Failed to parse token: $e');
      return null;
    }
  }
}
