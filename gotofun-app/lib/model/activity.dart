class Activity {
  final String title;
  final String description;
  final String lat;
  final String long;

  Activity({
    required this.title,
    required this.description,
    required this.lat,
    required this.long,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'],
      description: json['description'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}
