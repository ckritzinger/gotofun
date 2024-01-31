import 'dart:math';

import 'package:flutter/material.dart';

import '../model/activity.dart';
import '../service/activities_provider.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Activities'),
        ),
        body: Column(
          children: [
            StreamBuilder(
              stream: ActivitiesProvider.instance.status(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    color: snapshot.data!.connected ? Colors.green : Colors.red,
                    width: double.infinity,
                    child: Text(
                      "Last Updated: ${snapshot.data!.lastSyncedAt?.toString() ?? "Unknown"}",
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: ActivitiesProvider.instance.watchActivities(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _ActivitiesListBody(snapshot.data as List<Activity>);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final int time = DateTime.now().millisecondsSinceEpoch;
            final Random random = Random();
            ActivitiesProvider.instance
                .addActivity("title $time", "description $time", random.nextDouble(), random.nextDouble());
          },
          tooltip: '+',
          child: const Icon(Icons.add),
        ));
  }
}

class _ActivitiesListBody extends StatelessWidget {
  final List<Activity> activities;
  const _ActivitiesListBody(this.activities);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _ActivityTile(
          activity: activities[index],
        );
      },
      itemCount: activities.length,
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final Activity activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.local_activity),
      title: Text(activity.title),
      subtitle: Text(activity.description),
      trailing: const Icon(Icons.arrow_forward),
    );
  }
}
