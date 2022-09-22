import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/auth_details.dart';
import '../models/credit_card.dart';
import '../models/user.dart' as userModel;
import '../repository/user_repository.dart' as userRepo;

ValueNotifier<userModel.User?> currentUser = new ValueNotifier(null);
ValueNotifier<String> deliveryCity = new ValueNotifier('cucuta');
Future<userModel.User?> login(LoginDetails loginDetails) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}login';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(loginDetails.toMap()),
  );

  if (response.statusCode == 200) {
    var body = json.decode(response.body)['data'];
    if (body['email_verified'] != null && body['email_verified'] == 'YES') {
      setCurrentUser(response.body);
      currentUser.value = userModel.User.fromJson(body);
    } else {
      String message = "Account email has not been verified";
      if (body['message'] != null) {
        message = body['message'];
      }
      throw new Exception(message);
    }
  } else {
    var body = json.decode(response.body);
    String message = "Failed processing request, please retry";
    if (body['message'] != null) {
      message = body['message'];
    }
    throw new Exception(message);
  }
  return currentUser.value;
}

Future<userModel.User> register(SignUpDetails signUpDetails) async {
  print(signUpDetails.toJson());
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}register';
  final client = new http.Client();

  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(signUpDetails.toMap()),
  );

  if (response.statusCode == 200) {
    //setCurrentUser(response.body);
    return userModel.User.fromJson(json.decode(response.body)['data']);
    //currentUser.value = userModel.User.fromJSON(json.decode(response.body)['data']);
  } else {
    throw Exception(response.body);
  }
  // return currentUser.value;
}

Future<bool> resetPassword(userModel.User user) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}send_reset_link_email';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw new Exception(response.body);
  }
}

Future<void> logout() async {
  currentUser.value = null;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['data'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'current_user', json.encode(json.decode(jsonString)['data']));
  }
}

Future<void> setCreditCard(CreditCard? creditCard) async {
  if (creditCard != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credit_card', json.encode(creditCard.toMap()));
  }
}

Future<userModel.User?> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  if (currentUser.value?.auth == null && prefs.containsKey('current_user')) {
    print('the data ${await prefs.get('current_user').toString()}');
    currentUser.value = userModel.User.fromJson(
        json.decode(await prefs.get('current_user').toString()));
    currentUser.value!.auth = true;
  } else {
    currentUser.value?.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value == null ? null : currentUser.value;
}

Future<CreditCard?> getCreditCard() async {
  CreditCard? _creditCard;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credit_card')) {
    _creditCard = CreditCard.fromJSON(
        json.decode(await prefs.get('credit_card').toString()));
    return _creditCard;
  }
  return null;
}

Future<userModel.User> update(userModel.User user) async {
  final String _apiToken = 'api_token=${currentUser.value!.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}users/${currentUser.value!.id}';
  final client = new http.Client();
  user.deviceToken = '';
  Map userdetail = user.toMap();
  userdetail.removeWhere((key, value) => key == "device_token");

  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(userdetail),
  );
  // print("======================${_apiToken}====================");
  // print("======================${url}====================");
  // print("======================${{
  //   HttpHeaders.contentTypeHeader: 'application/json'
  // }}====================");
  // print(
  //     "======================${json.encode(user.toMap())}====================");
  log("======================${response.body}====================");

  setCurrentUser(response.body);
  currentUser.value =
      userModel.User.fromJson(json.decode(response.body)['data']);
  return currentUser.value!;
}

Future<void> updateDeviceToken() async {
  final String _apiToken = 'api_token=${currentUser.value!.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}users/${currentUser.value!.id}';
  final client = new http.Client();
  String? token = await FirebaseMessaging.instance.getToken();
  final response = await client.post(Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: {'device_token': token, 'api_token': _apiToken});
}

Future<Stream<Address>> getAddresses() async {
  userModel.User _user = currentUser.value!;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=updated_at&sortedBy=desc';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data as Map<String, dynamic>))
      .expand((data) => (data as List))
      .map((data) {
    return Address.fromJSON(data);
  });
}

Future<Address> addAddress(Address address) async {
  userModel.User _user = userRepo.currentUser.value!;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> updateAddress(Address address) async {
  userModel.User _user = userRepo.currentUser.value!;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> removeDeliveryAddress(Address address) async {
  userModel.User _user = userRepo.currentUser.value!;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}
