import 'package:flutter/material.dart';
import 'package:gotofun/service/activities_provider.dart';

import '../model/activity.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: const _ActivitiesListBody(),
    );
  }
}

class _ActivitiesListBody extends StatelessWidget {
  const _ActivitiesListBody();
  ActivitiesProvider get provider => ActivitiesProvider.instance;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _ActivityTile(
          activity: provider.activities[index],
        );
      },
      itemCount: provider.activities.length,
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
