import '../models/option.dart';
import '../models/product.dart';

class Favorite {
  String? id;
  Product? product;
  List<Option>? options;
  String? userId;
  Favorite({
    this.id,
    this.product,
    this.options,
    this.userId,
  });

 factory Favorite.fromJSON(Map<String, dynamic> jsonMap) {
   return Favorite(
      id : jsonMap['id'] != null ? jsonMap['id'].toString() : null,
      product : jsonMap['product'] != null ? Product.fromJSON(jsonMap['product']) : null,
      options : jsonMap['options'] != null ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList() : null,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["product_id"] = product?.id;
    map["user_id"] = userId;
    map["options"] =options?.map((element) => element.id).toList();
    return map;
  }
}
