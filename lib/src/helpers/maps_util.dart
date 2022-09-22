import 'dart:async';
import 'dart:convert';

//import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/Step.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class MapsUtil {
  static const BASE_URL =
      "https://maps.googleapis.com/maps/api/directions/json?";

  static MapsUtil _instance = new MapsUtil.internal();

  MapsUtil.internal();

  factory MapsUtil() => _instance;
  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(Uri.parse(BASE_URL + url)).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
//      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      List<LatLng> steps = [];
      try {
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);
      } catch (e) {
        // throw new Exception(e);
      }

      return steps;
    });
  }

  List<LatLng> parseSteps(final responseBody) {
    List<Step> _steps = responseBody.map<Step>((json) {
      return new Step.fromJson(json);
    }).toList();
    List<LatLng> _latLang =
        _steps.map((Step step) => step.startLatLng).toList();
    return _latLang;
  }

  Future<String?> getAddressName(LatLng? location, String apiKey) async {
    try {
      var endPoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&language=${setting.value.mobileLanguage.value}&key=$apiKey';
      var response = jsonDecode((await http.get(
        Uri.parse(endPoint),
        //TODO: add locationpicker Utils
        //     headers: await LocationUtils.getAppHeaders()
      ))
          .body);
      String city = 'cucuta';
      for (var item in response['results'][0]['address_components']) {
        if ((item['types'] as List).contains('administrative_area_level_1')) {
          city = item['long_name'].toString().toLowerCase();
        }
      }
      print('current city $city');
      deliveryCity.value = city;
      deliveryCity.notifyListeners();

      return response['results'][0]['formatted_address'];
    } catch (e) {
      print(e);
      return null;
    }
  }
}
