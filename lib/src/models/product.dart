import '../models/category.dart';
import '../models/market.dart';
import '../models/media.dart';
import '../models/option.dart';
import '../models/option_group.dart';
import '../models/review.dart';
import 'coupon.dart';

class Product {
  String id;
  String name;
  double price;
  double discountPrice;
  Media? image;
  List<Media> images;
  String description;
  String capacity;
  String unit;
  String packageItemsCount;
  bool featured;
  bool deliverable;
  int brandId;
  Market? market;
  Category? category;
  List<Option> options;
  List<OptionGroup> optionGroups;
  List<Review> productReviews;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.image,
    required this.images,
    required this.brandId,
    required this.description,
    required this.capacity,
    required this.unit,
    required this.packageItemsCount,
    required this.featured,
    required this.deliverable,
    required this.market,
    required this.category,
    required this.options,
    required this.optionGroups,
    required this.productReviews,
  });

  factory Product.fromJSON(Map<String, dynamic> jsonMap) {
    return Product(
        id: jsonMap['id'].toString(),
        name: jsonMap['name'] ?? '',
        price:
            jsonMap['discount_price'] != null && jsonMap['discount_price'] != 0
                ? jsonMap['discount_price'].toDouble()
                : jsonMap['price'] != null
                    ? jsonMap['price'].toDouble()
                    : 0.0,
        discountPrice:
            jsonMap['discount_price'] != null && jsonMap['discount_price'] == 0
                ? jsonMap['discount_price'].toDouble()
                : jsonMap['price'] != null
                    ? jsonMap['price'].toDouble()
                    : 0.0,
        image: jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
            ? Media.fromJSON(jsonMap['media'][0])
            : null,
        brandId: jsonMap['brand_id'] ?? 0,
        images:
            jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
                ? List.from(jsonMap['media'])
                    .map((element) => Media.fromJSON(element))
                    .toSet()
                    .toList()
                : [],
        description: jsonMap['description'] ?? '',
        capacity:
            jsonMap['capacity'] != null ? jsonMap['capacity'].toString() : '',
        unit: jsonMap['unit'] != null ? jsonMap['unit'].toString() : '',
        packageItemsCount: jsonMap['package_items_count'] != null
            ? jsonMap['package_items_count'].toString()
            : '',
        featured: jsonMap['featured'] ?? false,
        deliverable: jsonMap['deliverable'] ?? false,
        market: jsonMap['market'] != null
            ? Market.fromJSON(jsonMap['market'])
            : null,
        category: jsonMap['category'] != null
            ? Category.fromJSON(jsonMap['category'])
            : null,
        options: jsonMap['options'] != null &&
                (jsonMap['options'] as List).length > 0
            ? List.from(jsonMap['options'])
                .map((element) => Option.fromJSON(element))
                .toSet()
                .toList()
            : [],
        optionGroups: jsonMap['option_groups'] != null &&
                (jsonMap['option_groups'] as List).length > 0
            ? List.from(jsonMap['option_groups'])
                .map((element) => OptionGroup.fromJSON(element))
                .toSet()
                .toList()
            : [],
        productReviews: jsonMap['product_reviews'] != null &&
                (jsonMap['product_reviews'] as List).length > 0
            ? List.from(jsonMap['product_reviews'])
                .map((element) => Review.fromJSON(element))
                .toSet()
                .toList()
            : []);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["capacity"] = capacity;
    map["package_items_count"] = packageItemsCount;
    return map;
  }

  double getRate() {
    double _rate = 0;
    productReviews.forEach((e) => _rate += double.parse(e.rate));
    _rate = _rate > 0 ? (_rate / productReviews.length) : 0;
    return _rate;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;

  Coupon applyCoupon(Coupon coupon) {
    if (coupon.code != '') {
      if (coupon.valid == null) {
        coupon.valid = false;
      }
      coupon.discountables.forEach((element) {
        if (!coupon.valid!) {
          if (element.discountableType == "App\\Models\\Product") {
            if (element.discountableId == id) {
              coupon = _couponDiscountPrice(coupon);
            }
          } else if (element.discountableType == "App\\Models\\Market") {
            if (element.discountableId == market!.id) {
              coupon = _couponDiscountPrice(coupon);
            }
          } else if (element.discountableType == "App\\Models\\Category") {
            if (element.discountableId == category!.id) {
              coupon = _couponDiscountPrice(coupon);
            }
          }
        }
      });
    }
    return coupon;
  }

  Coupon _couponDiscountPrice(Coupon coupon) {
    coupon.valid = true;
    discountPrice = price;
    if (coupon.discountType == 'fixed') {
      price -= coupon.discount;
    } else {
      price = price - (price * coupon.discount / 100);
    }
    if (price < 0) price = 0;
    return coupon;
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, discountPrice: $discountPrice, image: $image, images: $images, description: $description, capacity: $capacity, unit: $unit, packageItemsCount: $packageItemsCount, featured: $featured, deliverable: $deliverable, market: ${market.toString()}, category: $category, options: $options, optionGroups: $optionGroups, productReviews: $productReviews)';
  }
}
