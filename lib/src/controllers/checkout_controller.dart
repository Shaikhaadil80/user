import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment? payment;
  CreditCard? creditCard;
  bool loading = true;
  String? deliveryDate;
  CheckoutController() {
    this.scaffoldKey = GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    print('delivery date');
    print(deliveryDate);

    List<ProductOrder> productOrders = [];
    carts.forEach((_cart) {
      ProductOrder _productOrder = new ProductOrder(
        id: '',
        price: _cart.product.price,
        marketID: _cart.product.market!.id,
        quantity: _cart.quantity,
        options: _cart.options,
        product: _cart.product,
      );
      _productOrder.marketID = _cart.product.market!.id;
      _productOrder.quantity = _cart.quantity;
      _productOrder.price = _cart.product.price;
      _productOrder.product = _cart.product;
      _productOrder.options = _cart.options;
      productOrders.add(_productOrder);
    });
    Order order = Order(
      id: '',
      payment: payment!,
      productOrders: productOrders,
      tax: carts[0].product.market!.defaultTax,
      deliveryDate: deliveryDate!,
      orderStatus: OrderStatus(id: '1', status: ''),
      deliveryFee: payment!.method == 'Pay on Pickup'
          ? 0
          : carts[0].product.market!.deliveryFee,
      hint: '',
      active: false,
      deliveryAddress: settingRepo.deliveryAddress.value!,
    );
    orderRepo.addOrder(order, this.payment!).then((value) async {
      settingRepo.coupon = new Coupon.fromJSON({});
      return value;
    }).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).payment_card_updated_successfully),
      ));
    });
  }
}
