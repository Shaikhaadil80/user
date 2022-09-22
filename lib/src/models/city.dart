import 'dart:convert';

class City {
  String? name;
  String? latitude;
  String? longitude;
  City({
    this.name,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(json.decode(source));
}
