import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gotofun/service/activities_provider.dart';
import 'package:gotofun/view/activities_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

import '../service/powersync.dart';

void main() async {
  log();

  await Hive.initFlutter();
  await Hive.openBox<String>('settings');
  await ActivitiesProvider.instance.fetchActivities();
  await openDatabase();
  await connectPowerSync();
  final sub = watchActivities();
  runApp(const MyApp());
}

void log() {
  // Log info from PowerSync
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');

      if (record.error != null) {
        print(record.error);
      }
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ActivitiesList(),
    );
  }
}
