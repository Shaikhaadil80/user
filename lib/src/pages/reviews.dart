import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/reviews_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/route_argument.dart';

class ReviewsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  ReviewsWidget({Key? key, required this.routeArgument}) : super(key: key);

  @override
  _ReviewsWidgetState createState() {
    return _ReviewsWidgetState();
  }
}

class _ReviewsWidgetState extends StateMVC<ReviewsWidget> {
  late ReviewsController _con;

  _ReviewsWidgetState() : super(ReviewsController()) {
    _con = controller as ReviewsController;
  }

  @override
  void initState() {
    _con.listenForOrder(orderId: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        body: RefreshIndicator(
            onRefresh: _con.refreshOrder,
            child: _con.order == null
                ? CircularLoadingWidget(height: 500)
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Hero(
                                      tag: widget.routeArgument.heroTag
                                              .toString() +
                                          _con.order!.productOrders[0].product!
                                              .market!.id,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: _con.order!.productOrders[0]
                                            .product!.market!.image!.url,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error_outline),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 110,
                                  child: Chip(
                                    padding: const EdgeInsets.all(10),
                                    label: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            _con.order!.productOrders[0]
                                                .product!.market!.rate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3!
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor))),
                                        Icon(
                                          Icons.star_border,
                                          color: Theme.of(context).primaryColor,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.9),
                                    shape: const StadiumBorder(),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 30,
                              left: 15,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _con.order!.productOrders[0].product!.market!.name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.15),
                                    offset: const Offset(0, -2),
                                    blurRadius: 5.0)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                  S.of(context).how_would_you_rate_this_market_,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _con.marketReview!.rate =
                                            (index + 1).toString();
                                      });
                                    },
                                    child: index <
                                            int.parse(_con.marketReview!.rate)
                                        ? const Icon(Icons.star,
                                            size: 40, color: Color(0xFFFFB24D))
                                        : const Icon(Icons.star_border,
                                            size: 40, color: Color(0xFFFFB24D)),
                                  );
                                }),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                onChanged: (text) {
                                  _con.marketReview!.review = text;
                                },
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  hintText:
                                      S.of(context).tell_us_about_this_market,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .merge(const TextStyle(fontSize: 14)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.1))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.1))),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // FlatButton.icon(
                              IconButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 18),
                                onPressed: () {
                                  _con.addMarketReview(_con.marketReview!);
                                  FocusScope.of(context).unfocus();
                                },
                                // shape: const StadiumBorder(),
                                // label: Text(
                                //   S.of(context).submit,
                                //   style: TextStyle(
                                //       color: Theme.of(context).primaryColor),
                                // ),
                                icon: Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                ),
                                // textColor: Theme.of(context).primaryColor,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(_con.productsOfOrder.length,
                              (index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.15),
                                        offset: const Offset(0, -2),
                                        blurRadius: 5.0)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(_con.productsOfOrder[index].name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (star) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _con.productsReviews[index].rate =
                                                (star + 1).toString();
                                          });
                                        },
                                        child: star <
                                                int.parse(_con
                                                    .productsReviews[index]
                                                    .rate)
                                            ? const Icon(Icons.star,
                                                size: 40,
                                                color: Color(0xFFFFB24D))
                                            : const Icon(Icons.star_border,
                                                size: 40,
                                                color: Color(0xFFFFB24D)),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    onChanged: (text) {
                                      _con.productsReviews[index].review = text;
                                    },
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(12),
                                      hintText: S
                                          .of(context)
                                          .tell_us_about_this_product,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .merge(const TextStyle(fontSize: 14)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.1))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.2))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.1))),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // FlatButton.icon(
                                  IconButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 18),
                                    onPressed: () {
                                      _con.addProductReview(
                                          _con.productsReviews[index],
                                          _con.productsOfOrder[index]);
                                      FocusScope.of(context).unfocus();
                                    },
                                    // shape: const StadiumBorder(),
                                    // label: Text(
                                    //   S.of(context).submit,
                                    //   style: TextStyle(
                                    //       color:
                                    //           Theme.of(context).primaryColor),
                                    // ),
                                    icon: Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    // textColor: Theme.of(context).primaryColor,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )));
  }
}
