import 'package:global_configuration/global_configuration.dart';

class Media {
  String? id;
  String? name;
  String url =
      "${GlobalConfiguration().getString('base_url')}images/image_default.png";
  String thumb =
      "${GlobalConfiguration().getString('base_url')}images/image_default.png";
  String icon =
      "${GlobalConfiguration().getString('base_url')}images/image_default.png";
  String? size;

  Media({
    this.id,
    this.name,
    required this.url,
    required this.thumb,
    required this.icon,
    this.size,
  });

  factory Media.fromJSON(Map<String, dynamic> jsonMap) => Media(
        id: jsonMap['id'].toString(),
        name: jsonMap['name'] ?? null,
        url: jsonMap['url'] ??
            "${GlobalConfiguration().getString('base_url')}images/image_default.png",
        thumb: jsonMap['thumb'] ??
            "${GlobalConfiguration().getString('base_url')}images/image_default.png",
        icon: jsonMap['icon'] ??
            "${GlobalConfiguration().getString('base_url')}images/image_default.png",
        size: jsonMap['formated_size'] ?? null,
      );

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["url"] = url;
    map["thumb"] = thumb;
    map["icon"] = icon;
    map["formated_size"] = size;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.url == this.url;
  }

  @override
  int get hashCode => this.url.hashCode;

  @override
  String toString() {
    return this.toMap().toString();
  }
}
