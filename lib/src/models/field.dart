import '../models/media.dart';

class Field {
  String id;
  String name;
  String description;
  Media? image;
  bool selected;
  Field({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.selected,
  });

  factory Field.fromJSON(Map<String, dynamic> jsonMap) {
    return Field(
        id: jsonMap['id'].toString(),
        name: jsonMap['name'] ?? '',
        description: jsonMap['description'] ?? '',
        image: jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
            ? Media.fromJSON(jsonMap['media'][0])
            : null,
        selected: jsonMap['selected'] ?? false);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
