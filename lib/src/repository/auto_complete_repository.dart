import 'dart:convert';
import 'dart:developer';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../repository/user_repository.dart';

Future<List<Map<String, dynamic>>> getPlaceSuggestions(
    String input, String token) async {
  User? _user = await currentUser.value;

  final String _apiToken = _user != null
      ? 'api_token=${_user.apiToken}&'
      : 'api_token=gY20ihXH0iXIsagdAdYJxyow6m6pYO2BTEMlAsY43aGFh1gISIxAhRAJqtDd&';
  final String url =
      '${GlobalConfiguration().get('api_base_url')}locations/autocomplete/$input/$token?${_apiToken}';

  final client = new http.Client();
  final response = await client.get(Uri.parse(url));
  List<Map<String, dynamic>> res = [];
  log(response.body);
  log("${_user?.apiToken}");
  if (json.decode(response.body)['data'] != null) {
    for (var item in json.decode(response.body)['data']['predictions']) {
      Map<String, dynamic> place = {};
      place['place_id'] = item['place_id'];
      place['main_text'] = item['structured_formatting']['main_text'];
      place['secondary_text'] = item['structured_formatting']['secondary_text'];
      place['load_from_address'] = false;
      res.add(place);
    }
  } else {}
  return res;
}

Future<Map<String, dynamic>> getPlaceDetails(String placeID) async {
  User _user = currentUser.value!;

  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=AIzaSyBXB7IzRkCT1GKSgXfn0bcwHYOQlfw7sr4&fields=formatted_address,name,geometry,address_components';

  final client = new http.Client();
  final response = await client.get(Uri.parse(url));

  String? city;
  String? fallback;
  var results = json.decode(response.body)['result'];
  for (var item in results['address_components']) {
    if ((item['types'] as List).contains('administrative_area_level_2')) {
      city = item['long_name'].toString().toLowerCase();
    }
    if ((item['types'] as List).contains('administrative_area_level_1')) {
      fallback = item['long_name'].toString().toLowerCase();
    }
  }
  return {
    'city': city ?? fallback,
    'latitude': results['geometry']['location']['lat'],
    'longitude': results['geometry']['location']['lng']
  };
}
