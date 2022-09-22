class Discountable {
  String id;
  String? discountableType;
  String? discountableId;
  Discountable({
    required this.id,
    required this.discountableType,
    required this.discountableId,
  });

  factory Discountable.fromJSON(Map<String, dynamic> jsonMap) {
    return Discountable(
        id: jsonMap['id'].toString(),
        discountableType: jsonMap['discountable_type'] != null
            ? jsonMap['discountable_type'].toString()
            : null,
        discountableId: jsonMap['discountable_id'] != null
            ? jsonMap['discountable_id'].toString()
            : null);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["discountable_type"] = discountableType;
    map["discountable_id"] = discountableId;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
