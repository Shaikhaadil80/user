import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/market_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ProductItemWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../models/brand.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class BrandPage extends StatefulWidget {
  final RouteArgument routeArgument;

  BrandPage({Key? key, required this.routeArgument}) : super(key: key);

  @override
  _BrandPageState createState() {
    return _BrandPageState();
  }
}

class _BrandPageState extends StateMVC<BrandPage> {
  late MarketController _con;

  _BrandPageState() : super(MarketController()) {
    _con = controller as MarketController;
  }

  @override
  void initState() {
    super.initState();
    _con.brand = widget.routeArgument.param as Brand;
    _con.getProductsToBeShown(
        _con.brand!.id, widget.routeArgument.param2 as List<Product>);
  }

  @override
  Widget build(BuildContext context) {
    print('cart state ${_con.isLoadingCart}');
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      body: _con.brand == null
          ? Center(child: CircularLoadingWidget(height: 500))
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CustomScrollView(
                  primary: true,
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.9),
                      expandedHeight: 300,
                      elevation: 0,
//                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                      automaticallyImplyLeading: false,
                      leading: new IconButton(
                        icon: new Icon(Icons.sort,
                            color: Theme.of(context).primaryColor),
                        onPressed: () =>
                            _con.scaffoldKey.currentState!.openDrawer(),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Hero(
                          tag: 'brand_grid${_con.brand!.id}',
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: '${_con.brand!.image?.url}',
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 10, top: 25),
                            child: Text(
                              _con.brand?.name ?? '',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          _con.productsToBeShown.isEmpty
                              ? const SizedBox(height: 0)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      Icons.shopping_basket_outlined,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      S.of(context).products,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                ),
                          _con.productsToBeShown.isEmpty
                              ? const SizedBox(height: 0)
                              : ListView.separated(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: _con.productsToBeShown.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemBuilder: (context, index) {
                                    return ProductItemWidget(
                                        heroTag: 'details_featured_product',
                                        product: _con.productsToBeShown
                                            .elementAt(index),
                                        calling: (p0) async {
                                          _con..getCartState(p0);
                                        });
                                  },
                                ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 32,
                  right: 20,
                  child: _con.isLoadingCart
                      ? const SizedBox(
                          width: 60,
                          height: 60,
                          child: RefreshProgressIndicator(),
                        )
                      : ShoppingCartFloatButtonWidget(
                          iconColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).hintColor,
                          routeArgument: RouteArgument(
                            param: '/Brand',
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
