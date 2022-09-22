import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class ShoppingCartButtonWidget extends StatefulWidget {
  const ShoppingCartButtonWidget({
    required this.iconColor,
    required this.labelColor,
    Key? key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ShoppingCartButtonWidgetState createState() =>
      _ShoppingCartButtonWidgetState();
}

class _ShoppingCartButtonWidgetState
    extends StateMVC<ShoppingCartButtonWidget> {
  late CartController _con;

  _ShoppingCartButtonWidgetState() : super(CartController()) {
    _con = controller as CartController;
  }

  @override
  void initState() {
    _con.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: () {
        if (currentUser.value?.apiToken != null) {
          Navigator.of(context).pushNamed('/Cart',
              arguments: RouteArgument(param: '/Pages', id: '0'));
        } else {
          Navigator.of(context).pushNamed('/Login');
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.shopping_cart_outlined,
            color: this.widget.iconColor,
            size: 28,
          ),
          Container(
            child: Text(
              _con.cartCount.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption!.merge(
                    TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 10),
                  ),
            ),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: this.widget.labelColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            constraints: const BoxConstraints(
                minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
