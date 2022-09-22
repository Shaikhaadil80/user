import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class PayPalController extends ControllerMVC {
  GlobalKey<ScaffoldState>? scaffoldKey;
  String url = "";
  double progress = 0;

  PayPalController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String _apiToken =
        'api_token=${userRepo.currentUser.value!.apiToken}';
    final String _userId = 'user_id=${userRepo.currentUser.value!.id}';
    final String _deliveryAddress =
        'delivery_address_id=${settingRepo.deliveryAddress.value!.id}';
    final String _couponCode = 'coupon_code=${settingRepo.coupon.code}';
    url =
        '${GlobalConfiguration().getString('base_url')}payments/paypal/express-checkout?$_apiToken&$_userId&$_deliveryAddress&$_couponCode';
    setState(() {});
    super.initState();
  }
}
