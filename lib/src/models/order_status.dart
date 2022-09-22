class OrderStatus {
  String id;
  String status = '';

  OrderStatus({
    required this.id,
    required this.status,
  });

  factory OrderStatus.fromJSON(Map<String, dynamic> jsonMap) {
    return OrderStatus(
      id: jsonMap['id'].toString(),
      status: jsonMap['status'] != null ? jsonMap['status'] : '',
    );
  }
}
