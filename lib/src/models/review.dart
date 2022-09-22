import '../models/market.dart';
import '../models/product.dart';
import '../models/user.dart';

class Review {
  String id;
  String review;
  String rate;
  User? user;

  Review(
    this.id,
    this.review,
    this.rate,
    this.user,
  );

  factory Review.fromJSON(Map<String, dynamic> jsonMap) {
    return Review(
 jsonMap['id'].toString(),
     jsonMap['review'] ?? '',
     jsonMap['rate'].toString(),
    jsonMap['user'] != null ? User.fromJson(jsonMap['user']) : null
    );
    
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user?.id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofMarketToMap(Market market) {
    var map = this.toMap();
    map["market_id"] = market.id;
    return map;
  }

  Map ofProductToMap(Product product) {
    var map = this.toMap();
    map["product_id"] = product.id;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
