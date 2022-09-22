import 'package:flutter/material.dart';
import 'package:appache/src/elements/CardsCarouselLoaderWidget.dart';
import 'package:appache/src/elements/PlaceSearchWidget.dart';
import 'package:appache/src/elements/ProductsCarouselLoaderWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/HomeSliderWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/setting.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key? key, required this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  late HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller as HomeController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
            child: PlaceSearchWidget(
              con: _con,
            ),
            preferredSize: Size.fromHeight(50)),
        centerTitle: true,
        title: ValueListenableBuilder<Setting?>(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value?.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(
                settingsRepo.setting.value.homeSections.length, (index) {
              String _homeSection =
                  settingsRepo.setting.value.homeSections.elementAt(index);
              switch (_homeSection) {
                case 'slider':
                  return HomeSliderWidget(slides: _con.slides);
                case 'search':
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchBarWidget(
                      onClickFilter: (event) {
                        widget.parentScaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  );
                case 'top_markets_heading':
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                S.of(context).top_markets,
                                style: Theme.of(context).textTheme.headline4,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (currentUser.value?.apiToken == null) {
                                  _con.requestForCurrentLocation(context);
                                } else {
                                  var bottomSheetController = widget
                                      .parentScaffoldKey.currentState!
                                      .showBottomSheet(
                                    (context) =>
                                        DeliveryAddressBottomSheetWidget(
                                            scaffoldKey:
                                                widget.parentScaffoldKey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                  );
                                  bottomSheetController.closed.then((value) {
                                    _con.refreshHome();
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: settingsRepo
                                              .deliveryAddress.value?.address ==
                                          null
                                      ? Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.1)
                                      : Theme.of(context).accentColor,
                                ),
                                child: Text(
                                  S.of(context).delivery,
                                  style: TextStyle(
                                      color: settingsRepo.deliveryAddress.value
                                                  ?.address ==
                                              null
                                          ? Theme.of(context).hintColor
                                          : Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  settingsRepo.deliveryAddress.value!.address =
                                      '';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: settingsRepo
                                              .deliveryAddress.value?.address !=
                                          null
                                      ? Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.1)
                                      : Theme.of(context).accentColor,
                                ),
                                child: Text(
                                  S.of(context).pickup,
                                  style: TextStyle(
                                      color: settingsRepo.deliveryAddress.value
                                                  ?.address !=
                                              null
                                          ? Theme.of(context).hintColor
                                          : Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (settingsRepo.deliveryAddress.value?.address != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              S.of(context).near_to +
                                  " " +
                                  settingsRepo.deliveryAddress.value!.address
                                      .toString(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                      ],
                    ),
                  );
                case 'top_markets':
                  if (_con.isLoadingTopMarkets) {
                    return CardsCarouselLoaderWidget();
                  } else if (_con.isLoadingTopMarkets == false &&
                      _con.topMarkets.isEmpty) {
                    return Padding(
                      child: Center(
                        child: Text(
                          S.of(context).no_markets_available,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                    );
                  } else {
                    return CardsCarouselWidget(
                        marketsList: _con.topMarkets,
                        heroTag: 'home_top_markets');
                  }
                  break;

                case 'trending_week_heading':
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: Icon(
                      Icons.trending_up,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).trending_this_week,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: Text(
                      S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                case 'trending_week':
                  if (_con.isLoadingTrendingProducts) {
                    return ProductsCarouselLoaderWidget();
                  } else if (_con.isLoadingTrendingProducts == false &&
                      _con.trendingProducts.isEmpty) {
                    return Padding(
                      child: Center(
                        child: Text(
                          S.of(context).trending_products_will_appear_here,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                    );
                  } else {
                    return ProductsCarouselWidget(
                        productsList: _con.trendingProducts,
                        heroTag: 'home_product_carousel');
                  }
                  break;

                case 'categories_heading':
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.category_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).product_categories,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  );
                case 'categories':
                  return CategoriesCarouselWidget(
                    categories: _con.categories,
                  );
                case 'popular_heading':
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.trending_up,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).most_popular,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  );
                case 'popular':
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridWidget(
                      marketsList: _con.popularMarkets,
                      heroTag: 'home_markets',
                    ),
                  );
                case 'recent_reviews_heading':
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      leading: Icon(
                        Icons.recent_actors_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).recent_reviews,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  );
                case 'recent_reviews':
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ReviewsListWidget(reviewsList: _con.recentReviews),
                  );
                default:
                  return SizedBox(height: 0);
              }
            }),
          ),
        ),
      ),
    );
  }
}
