import 'package:flutter/material.dart';
import 'package:gotofun/service/activities_provider.dart';
import 'package:gotofun/view/activities_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('settings');
  await ActivitiesProvider.instance.fetchActivities();
  runApp(const MyApp());
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
