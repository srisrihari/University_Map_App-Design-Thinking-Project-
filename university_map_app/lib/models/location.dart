class Location {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String type;
  final String? description;

  Location({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.description,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'description': description,
    };
  }
}
