import 'package:location/location.dart';

class Address {
  String? id;
  String? description;
  String address;
  double latitude;
  double longitude;
  bool? isDefault;
  String? userId;

  Address(
      {required this.address,
      this.description,
      this.id,
      this.isDefault,
      required this.latitude,
      required this.longitude,
      this.userId});

  factory Address.fromJSON(Map<String, dynamic> jsonMap) {
    return Address(
        address: jsonMap['address'] != null ? jsonMap['address'] : '',
        description: jsonMap['description'] != null
            ? jsonMap['description'].toString()
            : '',
        latitude: jsonMap['latitude'] != null
            ? double.parse(jsonMap['latitude'].toString())
            : 0.0,
        longitude: jsonMap['longitude'] != null
            ? double.parse(jsonMap['longitude'].toString())
            : 0.0,
        id: jsonMap['id'].toString(),
        isDefault: jsonMap['is_default'] ?? false,
        userId: jsonMap['address'] != null ? jsonMap['address'] : null);
  }

  bool isUnknown() {
    return longitude == null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    return map;
  }

  LocationData toLocationData() {
    return LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
  }
}
