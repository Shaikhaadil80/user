import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/product_controller.dart';
import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class ProductItemWidget extends StatefulWidget {
  final String heroTag;
  final Product product;
  final Function(bool)? calling;

  const ProductItemWidget(
      {Key? key, required this.product, required this.heroTag, this.calling})
      : super(key: key);

  @override
  StateMVC<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends StateMVC<ProductItemWidget> {
  late ProductController _con;

  _ProductItemWidgetState() : super(ProductController()) {
    _con = controller as ProductController;
  }

  @override
  void initState() {
    super.initState();
    _con.listenForCart();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      focusColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: RouteArgument(
                id: widget.product.id,
                heroTag: widget.heroTag + widget.product.id));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.heroTag + widget.product.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                      imageUrl: widget.product.image!.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            //TODO:add stars on products
                            // Row(
                            //   children:
                            //       Helper.getStarsList(widget.product.getRate()),
                            // ),
                            Text(
                              widget.product.options
                                  .map((e) => e.name)
                                  .toList()
                                  .join(', '),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Helper.getPrice(
                                  widget.product.price,
                                  context,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                widget.product.discountPrice > 0
                                    ? Helper.getPrice(
                                        widget.product.discountPrice, context,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .merge(const TextStyle(
                                                decoration: TextDecoration
                                                    .lineThrough)))
                                    : const SizedBox(height: 0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        _con.decrementQuantity();
                      },
                      iconSize: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Theme.of(context).hintColor,
                    ),
                    Text(_con.quantity.toInt().toString(),
                        style: Theme.of(context).textTheme.subtitle1),
                    IconButton(
                      onPressed: () {
                        _con.incrementQuantity();
                      },
                      iconSize: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      icon: const Icon(Icons.add_circle_outline),
                      color: Theme.of(context).hintColor,
                    ),
                  ],
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (currentUser.value?.apiToken == null) {
                        Navigator.of(context).pushNamed("/Login");
                      } else {
                        widget.calling!(true);
                        await _con.addToCart(widget.product);
                        widget.calling!(false);
                      }
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          S.of(context).add_to_cart,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
