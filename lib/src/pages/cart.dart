import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument? routeArgument;

  CartWidget({Key? key, required this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  late CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller as CartController;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context, null).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: CartBottomDetailsWidget(con: _con),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.routeArgument != null) {
                if (widget.routeArgument!.param.toString() == '/Market' ||
                    widget.routeArgument!.param.toString() == '/Brand') {
                  Navigator.of(context).pop();
                } else
                  Navigator.of(context).pushReplacementNamed(
                      widget.routeArgument!.param.toString(),
                      arguments: RouteArgument(id: widget.routeArgument!.id));
              } else {
                Navigator.of(context)
                    .pushReplacementNamed('/Pages', arguments: 0);
              }
            },
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).cart,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(const TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    ListView(
                      primary: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.shopping_cart_outlined,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).shopping_cart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .verify_your_quantity_and_click_checkout,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(S.of(context).set_your_delivery_date,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: TextFormField(
                                controller: _con.dateController,
                                readOnly: true,
                                autofocus: false,
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 360)))
                                      .then((value) {
                                    if (value != null) {
                                      _con.dateController.text =
                                          DateFormat('MMM-dd-yyyy')
                                              .format(value);
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Select',
                                  labelStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                  suffixIcon:
                                      const Icon(Icons.calendar_today_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(60),
                                      borderSide: const BorderSide(
                                          width: 1.0, color: Colors.black38)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(60),
                                      borderSide: const BorderSide(
                                          width: 1.0, color: Colors.black38)),
                                  filled: false,
                                ),
                              ),
                            )
                          ],
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.only(top: 15, bottom: 120),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.carts.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                              cart: _con.carts.elementAt(index),
                              heroTag: 'cart',
                              increment: () {
                                _con.incrementQuantity(
                                    _con.carts.elementAt(index));
                              },
                              decrement: () {
                                _con.decrementQuantity(
                                    _con.carts.elementAt(index));
                              },
                              onDismissed: () {
                                _con.removeFromCart(
                                    _con.carts.elementAt(index));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.15),
                                offset: const Offset(0, 2),
                                blurRadius: 5.0)
                          ]),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        onSubmitted: (String value) {
                          _con.doApplyCoupon(value);
                        },
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        controller: TextEditingController()..text = coupon.code,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: Theme.of(context).textTheme.bodyText1,
                          suffixText: coupon.valid == null
                              ? ''
                              : (coupon.valid!
                                  ? S.of(context).validCouponCode
                                  : S.of(context).invalidCouponCode),
                          suffixStyle: Theme.of(context)
                              .textTheme
                              .caption!
                              .merge(
                                  TextStyle(color: _con.getCouponIconColor())),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(
                              Icons.confirmation_number_outlined,
                              color: _con.getCouponIconColor(),
                              size: 28,
                            ),
                          ),
                          hintText: S.of(context).haveCouponCode,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
