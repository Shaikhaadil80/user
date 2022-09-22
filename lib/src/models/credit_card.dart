class CreditCard {
  String id;
  String number = '';
  String expMonth = '';
  String expYear = '';
  String cvc = '';
  CreditCard({
    required this.id,
    required this.number,
    required this.expMonth,
    required this.expYear,
    required this.cvc,
  });

  factory CreditCard.fromJSON(Map<String, dynamic> jsonMap) {
    return CreditCard(
      id: jsonMap['id'] ?? "",
      number: jsonMap['stripe_number'] ?? '',
      expMonth: jsonMap['stripe_exp_month'] ?? '',
      expYear: jsonMap['stripe_exp_year'] ?? '',
      cvc: jsonMap['stripe_cvc'] ?? '',
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["stripe_number"] = number;
    map["stripe_exp_month"] = expMonth;
    map["stripe_exp_year"] = expYear;
    map["stripe_cvc"] = cvc;
    return map;
  }

  bool validated() {
    return number != '' && expMonth != '' && expYear != '' && cvc != '';
  }
}
