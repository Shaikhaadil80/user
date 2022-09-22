class OptionGroup {
  String id;
  String name;
  OptionGroup({
    required this.id,
    required this.name,
  });

  factory OptionGroup.fromJSON(Map<String, dynamic> jsonMap) {
    return OptionGroup(
      id: jsonMap['id'].toString(),
      name: jsonMap['name']??'',
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
