class Promotion {
  int id;
  String ruleName;
  String ruleDescription;
  String fromDate;
  String toDate;
  int productID;
  String productName;
  String image;

  Promotion(
      {required this.id,
      required this.ruleName,
      required this.ruleDescription,
      required this.fromDate,
      required this.toDate,
      required this.productID,
      required this.image,
      required this.productName});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
        id: json['id'],
        ruleName: json['rule_name'],
        ruleDescription: json['rule_description'],
        fromDate: json['from_date'],
        toDate: json['to_date'],
        productID: json['product_id'],
        image: (json['free_product_details'] as List).isEmpty
            ? ''
            : (json['free_product_details'] as List)[0]['url'],
        productName: (json['free_product_details'] as List).isEmpty
            ? ''
            : (json['free_product_details'] as List)[0]['name']);
  }
}
