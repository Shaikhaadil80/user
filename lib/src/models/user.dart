import 'dart:convert';

import '../models/media.dart';

enum UserState { available, away, busy }

class User {
  String id;
  String name;
  String email;
  String idNumber;
  String password;
  String apiToken;
  String deviceToken;
  String? phone;
  String userType;
  bool emailVerified;
  bool? verifiedPhone;
  String verificationId;
  String address;
  String bio;
  Media? image;

  // used for indicate if client logged in or not
  bool auth;

//  String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.idNumber,
    required this.password,
    required this.apiToken,
    required this.deviceToken,
    required this.phone,
    required this.userType,
    required this.emailVerified,
    required this.verifiedPhone,
    required this.verificationId,
    required this.address,
    required this.bio,
    required this.image,
    required this.auth,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'id_number': idNumber,
      'password': password,
      'api_token': apiToken,
      'device_token': deviceToken,
      'phone': phone,
      'userType': userType,
      'email_verified': emailVerified,
      'verified_phone': verifiedPhone,
      'verification_id': verificationId,
      '': address,
      '': bio,
      'image': image?.toMap(),
      'auth': auth,
    };
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = image!.thumb;
    map["device_token"] = deviceToken;
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

  bool profileCompleted() {
    return address != null &&
        address != '' &&
        phone != null &&
        phone != '' &&
        verifiedPhone != null &&
        verifiedPhone!;
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      idNumber: map['id_number'] ?? '',
      password: map['password'] ?? '',
      apiToken: map['api_token'] ?? '',
      deviceToken: map['device_token'] ?? '',
      phone: map['custom_fields']['phone']['view'] ?? '',
      userType: map['user_type'] ?? '',
      emailVerified: map['email_verified'] == 'YES' ? true : false,
      verifiedPhone: map['phone_verified'] == 'YES' ? true : false,
      verificationId: map['verification_id'] ?? '',
      address: map['custom_fields']['address']['view'] ?? '',
      bio: map['custom_fields']['bio']['view'] ?? '',
      image: map['media'] != null && (map['media'] as List).length > 0
          ? Media.fromJSON(map['media'][0])
          : null,
      auth: map['auth'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());
}
