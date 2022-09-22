import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  late GlobalKey<ScaffoldState> scaffoldKey;
  model.Address? deliveryAddress;
  PaymentMethodList? list;
  String? deliveryDate;

  DeliveryPickupController() {
    this.scaffoldKey = GlobalKey<ScaffoldState>();
    super.listenForCarts();
    listenForDeliveryAddress();
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).the_address_updated_successfully),
      ));
    });
  }

  PaymentMethod getPickUpMethod() {
    return list!.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list!.pickupList.elementAt(1);
  }

  void toggleDelivery() {
    list!.pickupList.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getDeliveryMethod().selected = !getDeliveryMethod().selected;
    });
  }

  void togglePickUp() {
    list!.pickupList.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod().selected = !getPickUpMethod().selected;
    });
  }

  PaymentMethod getSelectedMethod() {
    return list!.pickupList.firstWhere((element) => element.selected);
  }

  @override
  void goCheckout(BuildContext context) {
    print(getSelectedMethod().route);
    String? message;
    if (getSelectedMethod().route == '/PayOnPickup') {
      message = 'Pay on Pickup';
    } else if (getDeliveryMethod().route == '/CashOnDelivery') {
      message = 'Cash on Delivery';
    }
    Navigator.of(state!.context).pushNamed(getSelectedMethod().route,
        arguments: RouteArgument(
            deliveryDate: deliveryDate!,
            param: message != null ? message : null));
  }
}
