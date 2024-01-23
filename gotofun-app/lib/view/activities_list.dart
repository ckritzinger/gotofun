import 'dart:math';

import 'package:flutter/material.dart';

import '../model/activity.dart';
import '../service/powersync.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Activities'),
        ),
        body: StreamBuilder(
          stream: watchActivities(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _ActivitiesListBody(snapshot.data as List<Activity>);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final int time = DateTime.now().millisecondsSinceEpoch;
            final Random random = Random();
            addActivity("title-$time", "description-$time", random.nextDouble(), random.nextDouble());
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
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => NewView()),
        // );
        print('tapped');
      },
      splashColor: Colors.blue.withAlpha(30),
      child: ListTile(
        leading: const Icon(Icons.local_activity),
        title: Text(activity.title),
        subtitle: Text(activity.description),
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
