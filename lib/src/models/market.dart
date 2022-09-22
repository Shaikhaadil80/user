import '../models/media.dart';
import 'user.dart';

class Market {
  String id;
  String name;
  Media? image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  double deliveryFee;
  double adminCommission;
  double defaultTax;
  String latitude;
  String longitude;
  bool closed;
  bool availableForDelivery;
  double deliveryRange;
  double distance;
  List<User> users;
  Market({
    required this.id,
    required this.name,
    required this.image,
    required this.rate,
    required this.address,
    required this.description,
    required this.phone,
    required this.mobile,
    required this.information,
    required this.deliveryFee,
    required this.adminCommission,
    required this.defaultTax,
    required this.latitude,
    required this.longitude,
    required this.closed,
    required this.availableForDelivery,
    required this.deliveryRange,
    required this.distance,
    required this.users,
  });

  factory Market.fromJSON(Map<String, dynamic> jsonMap) {
    return Market(
        id: jsonMap['id'].toString(),
        name:jsonMap['name']??'',
        image:  jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : null,
        rate: jsonMap['rate'] ?? '0',
        address: jsonMap['address']??'',
        description: jsonMap['description']??'',
        phone: jsonMap['phone']??'',
        mobile: jsonMap['mobile']??'',
        information: jsonMap['information']??'',
        deliveryFee:  jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0,
        adminCommission: jsonMap['admin_commission'] != null
          ? jsonMap['admin_commission'].toDouble()
          : 0.0,
        defaultTax: jsonMap['default_tax'] != null
          ? jsonMap['default_tax'].toDouble()
          : 0.0,
        latitude: jsonMap['latitude']??'',
        longitude: jsonMap['longitude']??'',
        closed: jsonMap['closed'] ?? false,
        availableForDelivery: jsonMap['available_for_delivery'] ?? false,
        deliveryRange: jsonMap['delivery_range'] != null
          ? jsonMap['delivery_range'].toDouble()
          : 0.0,
        distance:  jsonMap['distance'] != null
          ? double.parse(jsonMap['distance'].toString())
          : 0.0,
        users: jsonMap['users'] != null && (jsonMap['users'] as List).length > 0
          ? List.from(jsonMap['users'])
              .map((element) => User.fromJson(element))
              .toSet()
              .toList()
          : []);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }

  @override
  String toString() {
    return 'Market(id: $id, name: $name, image: $image, rate: $rate, address: $address, description: $description, phone: $phone, mobile: $mobile, information: $information, deliveryFee: $deliveryFee, adminCommission: $adminCommission, defaultTax: $defaultTax, latitude: $latitude, longitude: $longitude, closed: $closed, availableForDelivery: $availableForDelivery, deliveryRange: $deliveryRange, distance: $distance, users: $users)';
  }
}
