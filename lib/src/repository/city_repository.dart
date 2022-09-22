import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> getSupportedCities() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}locations/supportedcities';
  var response = await http.get(Uri.parse(url));

  return (jsonDecode(response.body)['data'] as List<dynamic>)
      .cast<Map<String, dynamic>>();
}
