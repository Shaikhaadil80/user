import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/CreditCardsWidget.dart';
import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CheckoutWidget extends StatefulWidget {
//  RouteArgument routeArgument;
//  CheckoutWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends StateMVC<CheckoutWidget> {
  late CheckoutController _con;

  _CheckoutWidgetState() : super(CheckoutController()) {
    _con = controller as CheckoutController;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).checkout,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: _con.carts.isEmpty
          ? CircularLoadingWidget(height: 400)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 255),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.payment,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).payment_mode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S.of(context).select_your_preferred_payment_mode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        new CreditCardsWidget(
                            creditCard:
                                _con.creditCard ?? CreditCard.fromJSON({}),
                            onChanged: (creditCard) {
                              _con.updateCreditCard(creditCard);
                            }),
                        const SizedBox(height: 40),
                        setting.value.payPalEnabled
                            ? Text(
                                S.of(context).or_checkout_with,
                                style: Theme.of(context).textTheme.caption,
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        const SizedBox(height: 40),
                        setting.value.payPalEnabled
                            ? SizedBox(
                                width: 320,
                                child: MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/PayPal');
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2),
                                  shape: const StadiumBorder(),
                                  child: Image.asset(
                                    'assets/img/paypal2.png',
                                    height: 28,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 255,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.15),
                              offset: const Offset(0, -2),
                              blurRadius: 5.0)
                        ]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).subtotal,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(_con.subTotal, context,
                                  style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).delivery_fee,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(
                                  _con.carts[0].product.market!.deliveryFee,
                                  context,
                                  style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "${S.of(context).tax} (${_con.carts[0].product.market!.defaultTax}%)",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(_con.taxAmount, context,
                                  style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).total,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              Helper.getPrice(_con.total, context,
                                  style: Theme.of(context).textTheme.headline6)
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                if (_con.creditCard!.validated()) {
                                  Navigator.of(context).pushNamed(
                                      '/OrderSuccess',
                                      arguments: new RouteArgument(
                                          param:
                                              'Credit Card (Stripe Gateway)'));
                                } else {
                                  ScaffoldMessenger.of(
                                          _con.scaffoldKey.currentContext!)
                                      .showSnackBar(SnackBar(
                                    content: Text(S
                                        .of(context)
                                        .your_credit_card_not_valid),
                                  ));
                                }
                              },
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).colorScheme.secondary,
                              shape: const StadiumBorder(),
                              child: Text(
                                S.of(context).confirm_payment,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
