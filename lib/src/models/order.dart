import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../models/user.dart';

class Order {
  String id;
  List<ProductOrder> productOrders;
  OrderStatus orderStatus;
  double tax;
  String deliveryDate;
  double deliveryFee;
  String hint;
  bool active;
  DateTime? dateTime = DateTime.now();
  User? user;
  Payment? payment;
  Address deliveryAddress;
  Order({
    required this.id,
    required this.productOrders,
    required this.tax,
    required this.deliveryDate,
    required this.orderStatus,
    required this.deliveryFee,
    required this.hint,
    required this.active,
    this.dateTime,
    this.user,
    this.payment,
    required this.deliveryAddress,
  });

  factory Order.fromJSON(Map<String, dynamic> jsonMap) {
    return Order(
      id: jsonMap['id'].toString(),
      tax: jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0,
      deliveryFee: jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0,
      deliveryDate: jsonMap['delivery_date']??'',
      hint: jsonMap['hint'] != null ? jsonMap['hint'].toString() : '',
      active: jsonMap['active'] ?? false,
      orderStatus: jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : OrderStatus.fromJSON({}),
      dateTime: DateTime.parse(jsonMap['updated_at']),
      user: jsonMap['user'] != null ? User.fromJson(jsonMap['user']) : null,
      deliveryAddress: jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : Address.fromJSON({}),
      payment: jsonMap['payment'] != null
          ? Payment.fromJSON(jsonMap['payment'])
          : null,
      productOrders: jsonMap['product_orders'] != null
          ? List.from(jsonMap['product_orders'])
              .map((element) => ProductOrder.fromJSON(element))
              .toList()
          : [],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map['delivery_date'] = deliveryDate;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus.id;
    map["tax"] = tax;
    map['hint'] = hint;
    map["delivery_fee"] = deliveryFee;
    map["products"] = productOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment?.toMap();
    if (!deliveryAddress.isUnknown()) {
      map["delivery_address_id"] = deliveryAddress.id;
    }
    return map;
  }

  Map deliveredMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = 5;
    if (deliveryAddress.id != null && deliveryAddress.id != 'null')
      map["delivery_address_id"] = deliveryAddress.id;
    return map;
  }

  Map cancelMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    if (orderStatus.id != null && orderStatus.id == '1') map["active"] = false;
    return map;
  }

  bool canCancelOrder() {
    return this.active == true &&
        this.orderStatus.id == '1'; // 1 for order received status
  }
}
