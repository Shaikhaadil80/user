class Notification {
  String id;
  String type;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;
  Notification({
    required this.id,
    required this.type,
    required this.data,
    required this.read,
    required this.createdAt,
  });

  

 factory Notification.fromJSON(Map<String, dynamic> jsonMap) {
   return Notification (
      id : jsonMap['id'].toString(),
      type : jsonMap['type'] != null ? jsonMap['type'].toString() : '',
      data : jsonMap['data'] != null ? {} : {},
      read : jsonMap['read_at'] != null ? true : false,
      createdAt : DateTime.parse(jsonMap['created_at']),
    );
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }
}
