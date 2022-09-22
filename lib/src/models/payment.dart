class Payment {
  String? id;
  String? status;
  String? method;
  Payment({
     this.id,
     this.status,
    required this.method,
  });

 factory Payment.fromJSON(Map<String, dynamic> jsonMap) {
    return Payment(
        id: jsonMap['id'].toString(),
        status: jsonMap['status'] ?? '',
        method: jsonMap['method'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'method': method,
    };
  }
}
