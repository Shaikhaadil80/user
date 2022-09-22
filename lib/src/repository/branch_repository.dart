import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../models/brand.dart';
import '../models/product.dart';

Future<List<Brand>> getAllBrands() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}brands/';
  try {
    List<Brand> brands = [];
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    for (Map<String, dynamic> brand in json.decode(response.body)['data']) {
      brands.add(Brand.fromJSON(brand));
    }
    print(brands.length);
    return brands;
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    throw e.toString();
  }
}

Future<List<Product>> getAllProductsByBrandAndMarket(
    int brandId, int marketId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}products?brand_id=$brandId&market_id=$marketId';
  try {
    List<Product> products = [];
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    for (Map<String, dynamic> product in json.decode(response.body)['data']) {
      products.add(Product.fromJSON(product));
    }
    print(products.length);
    return products;
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    throw e.toString();
  }
}
