import '../models/media.dart';

class Category {
  String id;
  String name;
  Media? image;

  Category(
    this.id,
    this.name,
    this.image,
  );

  factory Category.fromJSON(Map<String, dynamic> jsonMap) {
    return Category(
        jsonMap['id'].toString(),
        jsonMap['name'] ?? '',
        jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
            ? Media.fromJSON(jsonMap['media'][0])
            : null);
  }
}
