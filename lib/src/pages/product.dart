import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/product_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OptionItemWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/media.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

// ignore: must_be_immutable
class ProductWidget extends StatefulWidget {
  RouteArgument? routeArgument;

  ProductWidget({Key? key, this.routeArgument}) : super(key: key);

  @override
  _ProductWidgetState createState() {
    return _ProductWidgetState();
  }
}

class _ProductWidgetState extends StateMVC<ProductWidget> {
  late ProductController _con;

  _ProductWidgetState() : super(ProductController()) {
    _con = controller as ProductController;
  }

  @override
  void initState() {
    _con.listenForProduct(productId: widget.routeArgument!.id!);
    _con.listenForCart();
    _con.listenForFavorite(productId: widget.routeArgument!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: _con.product == null ||
              _con.product?.image == null ||
              _con.product?.images == null
          ? CircularLoadingWidget(height: 500)
          : RefreshIndicator(
              onRefresh: _con.refreshProduct,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 125),
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.9),
                          expandedHeight: 275,
                          elevation: 0,
                          iconTheme: IconThemeData(
                              color: Theme.of(context).primaryColor),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                Hero(
                                  tag: widget.routeArgument?.heroTag ?? '',
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 7),
                                      height: 300,
                                      viewportFraction: 1.0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _con.current = index;
                                        });
                                      },
                                    ),
                                    items:
                                        _con.product!.images.map((Media image) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return CachedNetworkImage(
                                            height: 300,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            imageUrl: image.url,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/img/loading.gif',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 300,
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Icon(Icons.error_outline),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                  //margin: EdgeInsets.symmetric(vertical: 22, horizontal: 42),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        _con.product!.images.map((Media image) {
                                      return Container(
                                        width: 20.0,
                                        height: 5.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: _con.current ==
                                                    _con.product!.images
                                                        .indexOf(image)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.4)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Wrap(
                              runSpacing: 8,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _con.product?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                          Text(
                                            _con.product?.market?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Helper.getPrice(
                                            _con.product!.price,
                                            context,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          _con.product!.discountPrice > 0
                                              ? Helper.getPrice(
                                                  _con.product!.discountPrice,
                                                  context,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .merge(const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)))
                                              : const SizedBox(height: 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: Helper.canDelivery(
                                                      _con.product!.market!) &&
                                                  _con.product!.deliverable
                                              ? Colors.green
                                              : Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: Helper.canDelivery(
                                                  _con.product!.market!) &&
                                              _con.product!.deliverable
                                          ? Text(
                                              S.of(context).deliverable,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            )
                                          : Text(
                                              S.of(context).not_deliverable,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            ),
                                    ),
                                    const Expanded(child: SizedBox(height: 0)),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).focusColor,
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        child: Text(
                                          _con.product!.capacity +
                                              " " +
                                              _con.product!.unit,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        )),
                                    const SizedBox(width: 5),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).focusColor,
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        child: Text(
                                          _con.product!.packageItemsCount +
                                              " " +
                                              S.of(context).items,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        )),
                                  ],
                                ),
                                const Divider(height: 20),
                                Text(
                                    Helper.skipHtml(_con.product!.description)),
                                if (_con.product!.optionGroups.isNotEmpty)
                                  ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    leading: Icon(
                                      Icons.add_circle_outline,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      S.of(context).options,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    subtitle: Text(
                                      S
                                          .of(context)
                                          .select_options_to_add_them_on_the_product,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                _con.product?.optionGroups.isEmpty ?? false
                                    ? CircularLoadingWidget(height: 100)
                                    : ListView.separated(
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder:
                                            (context, optionGroupIndex) {
                                          var optionGroup = _con
                                              .product!.optionGroups
                                              .elementAt(optionGroupIndex);
                                          return Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                dense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0),
                                                leading: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                title: Text(
                                                  optionGroup.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1,
                                                ),
                                              ),
                                              ListView.separated(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                itemBuilder:
                                                    (context, optionIndex) {
                                                  return OptionItemWidget(
                                                    option: _con
                                                        .product!.options
                                                        .where((option) =>
                                                            option
                                                                .optionGroupId ==
                                                            optionGroup.id)
                                                        .elementAt(optionIndex),
                                                    onChanged:
                                                        _con.calculateTotal,
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 20);
                                                },
                                                itemCount: _con.product!.options
                                                    .where((option) =>
                                                        option.optionGroupId ==
                                                        optionGroup.id)
                                                    .length,
                                                primary: false,
                                                shrinkWrap: true,
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(height: 20);
                                        },
                                        itemCount:
                                            _con.product!.optionGroups.length,
                                        primary: false,
                                        shrinkWrap: true,
                                      ),
                                ListTile(
                                  dense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  leading: Icon(
                                    Icons.recent_actors_outlined,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).reviews,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                ReviewsListWidget(
                                  reviewsList: _con.product!.productReviews,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 20,
                    child: _con.loadCart
                        ? const SizedBox(
                            width: 60,
                            height: 60,
                            child: RefreshProgressIndicator(),
                          )
                        : ShoppingCartFloatButtonWidget(
                            iconColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).hintColor,
                            routeArgument: RouteArgument(
                                param: '/Product', id: _con.product!.id),
                          ),
                  ),
                  //home icon
                  Positioned(
                    top: 200,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/Pages', arguments: 0);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary),
                        child: const Center(
                          child: Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 170,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
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
                                    S.of(context).quantity,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        _con.decrementQuantity();
                                      },
                                      iconSize: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Text(_con.quantity.toInt().toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    IconButton(
                                      onPressed: () {
                                        _con.incrementQuantity();
                                      },
                                      iconSize: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _con.favorite?.id != null
                                      ? OutlinedButton(
                                          onPressed: () {
                                            _con.removeFromFavorite(
                                                _con.favorite!);
                                          },

                                          // padding: EdgeInsets.symmetric(
                                          //     vertical: 14),
                                          // color: Theme.of(context).primaryColor,

                                          child: Icon(
                                            Icons.favorite,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ))
                                      : MaterialButton(
                                          elevation: 0,
                                          onPressed: () {
                                            if (currentUser.value?.apiToken ==
                                                null) {
                                              Navigator.of(context)
                                                  .pushNamed("/Login");
                                            } else {
                                              _con.addToFavorite(_con.product!);
                                            }
                                          },
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          shape: const StadiumBorder(),
                                          child: Icon(
                                            Icons.favorite_outline,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                ),
                                const SizedBox(width: 10),
                                Stack(
                                  fit: StackFit.loose,
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: MaterialButton(
                                        elevation: 0,
                                        onPressed: () {
                                          if (currentUser.value?.apiToken ==
                                              null) {
                                            Navigator.of(context)
                                                .pushNamed("/Login");
                                          } else {
                                            _con.addToCart(_con.product!);
                                            //check for same market line removed
                                            // if (_con
                                            //     .isSameMarkets(_con.product)) {
                                            //   _con.addToCart(_con.product);
                                            // } else {
                                            //   showDialog(
                                            //     context: context,
                                            //     builder:
                                            //         (BuildContext context) {
                                            //       // return object of type Dialog
                                            //       return AddToCartAlertDialogWidget(
                                            //           oldProduct: _con.carts
                                            //               .elementAt(0)
                                            //               ?.product,
                                            //           newProduct: _con.product,
                                            //           onPressed: (product,
                                            //               {reset: true}) {
                                            //             return _con.addToCart(
                                            //                 _con.product,
                                            //                 reset: true);
                                            //           });
                                            //     },
                                            //   );
                                            // }
                                          }
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        shape: const StadiumBorder(),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            S.of(context).add_to_cart,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Helper.getPrice(
                                        _con.total,
                                        context,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
