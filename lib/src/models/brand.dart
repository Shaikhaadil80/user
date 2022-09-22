import '../models/media.dart';

class Brand {
  int id;
  String name;
  Media? image;

  Brand(
    this.id,
    this.name,
    this.image,
  );

  factory Brand.fromJSON(Map<String, dynamic> jsonMap) {
    return Brand(
        jsonMap['id'].toInt(),
        jsonMap['name'] ?? '',
        jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
            ? Media.fromJSON(jsonMap['media'][0])
            : null);
  }
}
