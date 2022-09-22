import 'dart:convert';

class LoginDetails {
  String email;
  String password;
  LoginDetails({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginDetails.fromMap(Map<String, dynamic> map) {
    return LoginDetails(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginDetails.fromJson(String source) =>
      LoginDetails.fromMap(json.decode(source));
}

class SignUpDetails {
  String? name;
  String? email;
  String? idNumber;
  String? password;
  String? deviceToken;
  String? phone;
  String? userType;

  SignUpDetails({
     this.name,
     this.email,
     this.idNumber,
     this.password,
     this.deviceToken,
     this.phone,
     this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id_number': idNumber,
      'password': password,
      'device_token': deviceToken,
     'phone' : phone,
      'user_type': userType,
    };
  }

 SignUpDetails copyWith({
    String? name,
    String? email,
    String? idNumber,
    String? password,
    String? deviceToken,
    String? phone,
    String? userType,
  }) {

     return SignUpDetails(
        name:name ?? this.name,
        email:email ?? this.email,
        idNumber:idNumber ?? this.idNumber,
        password:password ?? this.password,
        deviceToken:deviceToken ?? this.deviceToken,
        phone:phone ?? this.phone,
        userType:userType ?? this.userType,
      );
  }
  String toJson() => json.encode(toMap());
}
