import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/gift.dart';
import '../repository/user_repository.dart';

Future<Gift> getGifts() async {
  User _user = currentUser.value!;

  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}userpoints/${_user.id}?${_apiToken}';

  final client = new http.Client();
  final response = await client.get(Uri.parse(url));

  return Gift.fromJson(json.decode(response.body)['data']);
}
