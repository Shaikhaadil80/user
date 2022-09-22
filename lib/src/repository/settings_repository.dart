import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/maps_util.dart';
import '../models/address.dart';
import '../models/coupon.dart';
import '../models/setting.dart';

ValueNotifier<Setting> setting = new ValueNotifier(Setting.fromJSON({
  "app_name": "Appache",
  "enable_stripe": "1",
  "default_tax": "19",
  "default_currency": "\$",
  "fcm_key":
      "AAAAUHYxB38:APA91bH3Oh832Gz3-mmXwG920ctJn85AHO5YB_3R_VPvkENmG6sbWbZ6pieogFle1NO9YdAdCsdZrI1vZ7R7gsZ7EMnvsoJBdkXkFQiasIZlR5zDIPDhzd6QIge8Wap7SVhPcRic2_zc",
  "enable_paypal": "1",
  "main_color": "#1ea5ff",
  "main_dark_color": "#ffffff",
  "second_color": "#043832",
  "second_dark_color": "#ccccdd",
  "accent_color": "#8c98a8",
  "accent_dark_color": "#9999aa",
  "scaffold_dark_color": "#2c2c2c",
  "scaffold_color": "#fafafa",
  "google_maps_key": "AIzaSyBXB7IzRkCT1GKSgXfn0bcwHYOQlfw7sr4",
  "mobile_language": "en",
  "app_version": "2.0.0",
  "enable_version": "1",
  "default_currency_decimal_digits": "0",
  "currency_right": "1",
  "distance_unit": "km",
  "home_section_1": "empty",
  "home_section_2": "empty",
  "home_section_3": "top_markets_heading",
  "home_section_4": "top_markets",
  "home_section_5": "trending_week",
  "home_section_6": "trending_week",
  "home_section_7": "categories_heading",
  "home_section_8": "categories",
  "home_section_9": "empty",
  "home_section_10": "empty",
  "home_section_11": "empty",
  "home_section_12": "empty"
}));

ValueNotifier<Address?> deliveryAddress = new ValueNotifier(null);
Coupon coupon = Coupon(code: '', discount: 0.0, discountables: []);
final navigatorKey = GlobalKey<NavigatorState>();

Future<Setting?> initSettings() async {
  Setting _setting;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}settings';

  try {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200 &&
        response.headers.containsValue('application/json')) {
      if (json.decode(response.body)['data'] != null) {
        print(json.decode(response.body)['data']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'settings', json.encode(json.decode(response.body)['data']));
        _setting = Setting.fromJSON(json.decode(response.body)['data']);
        if (prefs.containsKey('language')) {
          _setting.mobileLanguage.value =
              Locale(prefs.get('language').toString(), '');
        }
        _setting.brightness.value = prefs.getBool('isDark') ?? false
            ? Brightness.dark
            : Brightness.light;
        setting.value = _setting;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        setting.notifyListeners();
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    print('err occured');
    print(e);
    //print(CustomTrace(StackTrace.current, message: url).toString());
    //  return null;
  }
  return setting.value;
}

Future<dynamic> setCurrentLocation() async {
  var location = new Location();
  MapsUtil mapsUtil = new MapsUtil();
  final whenDone = new Completer();
  Address? _address;
  location.requestService().then((value) async {
    await Future.delayed(const Duration(seconds: 1));
    location.getLocation().then((_locationData) async {
      String? _addressName = await mapsUtil.getAddressName(
          LatLng(_locationData.latitude!, _locationData.longitude!),
          setting.value.googleMapsKey);

      _address = Address.fromJSON({
        'address': _addressName,
        'latitude': _locationData.latitude,
        'longitude': _locationData.longitude
      });
      deliveryAddress.value = _address!;
      await changeCurrentLocation(_address!);
      setting.notifyListeners();
      whenDone.complete(_address);
    }).timeout(const Duration(seconds: 10), onTimeout: () async {
      await changeCurrentLocation(_address!);
      whenDone.complete(_address);
      return null;
    }).catchError((e) {
      whenDone.complete(_address);
    });
  });
  return whenDone.future;
}

Future<Address> changeCurrentLocation(Address _address) async {
  if (!_address.isUnknown()) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('delivery_address', json.encode(_address.toMap()));
  }
  return _address;
}

Future<Address> getCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();
  if (prefs.containsKey('delivery_address')) {
    deliveryAddress.value = Address.fromJSON(
        json.decode(prefs.getString('delivery_address').toString()));
    return deliveryAddress.value!;
  } else {
    deliveryAddress.value = new Address(
        address: 'Cucuta',
        isDefault: true,
        latitude: 7.8890971,
        longitude: -72.4966896);
    return deliveryAddress.value!;
  }
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}

Future<void> setDefaultLanguage(String language) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', language);
}

Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = await prefs.get('language').toString();
  }
  return defaultLanguage;
}

Future<void> saveMessageId(String messageId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('google.message_id', messageId);
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get('google.message_id').toString();
}
