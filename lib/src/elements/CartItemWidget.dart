import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget(
      {Key? key,
      required this.cart,
      required this.heroTag,
      required this.increment,
      required this.decrement,
      required this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.id!),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.secondary,
        focusColor: Theme.of(context).colorScheme.secondary,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Product',
              arguments: RouteArgument(
                  id: widget.cart.product.id, heroTag: widget.heroTag));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  imageUrl: widget.cart.product.image!.thumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline),
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.cart.product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Wrap(
                            children: List.generate(widget.cart.options.length,
                                (index) {
                              return Text(
                                widget.cart.options.elementAt(index).name +
                                    ', ',
                                style: Theme.of(context).textTheme.caption,
                              );
                            }),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: <Widget>[
                              Helper.getPrice(
                                  widget.cart.product.price, context,
                                  style: Theme.of(context).textTheme.headline4,
                                  zeroPlaceholder: 'Free'),
                              widget.cart.product.discountPrice > 0
                                  ? Helper.getPrice(
                                      widget.cart.product.discountPrice,
                                      context,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .merge(const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough)))
                                  : const SizedBox(height: 0),
                            ],
                          ),
                          //Helper.getPrice(widget.cart.getProductPrice(), context, style: Theme.of(context).textTheme.headline4)
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          icon: const Icon(Icons.add_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                        Text(widget.cart.quantity.toString(),
                            style: Theme.of(context).textTheme.subtitle1),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
                            });
                          },
                          iconSize: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
