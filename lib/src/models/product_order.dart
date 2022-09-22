import '../models/option.dart';
import '../models/product.dart';

class ProductOrder {
  String? id;
  double price;
  String? marketID;
  double quantity;
  List<Option> options;
  Product? product;
  DateTime? dateTime;
  ProductOrder({
    required this.id,
    required this.price,
    required this.marketID,
    required this.quantity,
    required this.options,
    required this.product,
    this.dateTime,
  });

  factory ProductOrder.fromJSON(Map<String, dynamic> jsonMap) {
    return ProductOrder(
        id: jsonMap['id'].toString(),
        price: jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0,
        marketID: jsonMap['market_id']?.toString(),
        quantity:
            jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0,
        options:  jsonMap['options'] != null
          ? List.from(jsonMap['options'])
              .map((element) => Option.fromJSON(element))
              .toList()
          : [],
        product: jsonMap['product'] != null
          ? Product.fromJSON(jsonMap['product'])
          : null,
        dateTime: DateTime.parse(jsonMap['updated_at']));
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map['market_id'] = marketID;
    map["price"] = price;
    map["quantity"] = quantity;
    map["product_id"] = product?.id;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }
}
