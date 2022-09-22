import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/slide.dart';
import '../repository/category_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/slider_repository.dart';

class HomeController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Slide> slides = <Slide>[];
  List<Market> topMarkets = <Market>[];
  List<Market> popularMarkets = <Market>[];
  List<Review> recentReviews = <Review>[];
  List<Product> trendingProducts = <Product>[];
  bool isLoadingTrendingProducts = true;
  bool isLoadingTopMarkets = true;
  bool isLoadingCategories = true;
  HomeController() {
    listenForTopMarkets();
    listenForSlides();

    listenForPopularMarkets();
    listenForRecentReviews();
  }

  Future<void> listenForSlides() async {
    final Stream<Slide?> stream = await getSlides();
    stream.listen((Slide? _slide) {
      if(_slide==null){

      }else
      setState(() => slides.add(_slide));
    }, onError: (a) {
      print('error for slide $a');
    }, onDone: () {});
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream =
        await getCategoriesOfMarket(topMarkets[0].id);
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      setState(() {
        isLoadingCategories = false;
      });
    });
  }
//{id: 14, name: BIG COLA - BOGOTA, latitude: 4.665127, longitude: -74.129929, delivery_fee: 0.0, distance: 5.090133496506736}
//{id: 2, name: BIG COLA, latitude: 7.92502, longitude: -72.50377, delivery_fee: 0.0, distance: 2.529129791157564}

  Future<void> listenForTopMarkets() async {
    final Stream<Market>? stream =
        await getNearMarkets(deliveryAddress.value!, deliveryAddress.value!);
    stream?.listen(
        (Market _market) {
          print('market id');
          print(_market.id);
          setState(() => topMarkets.add(_market));
        },
        onError: (a) {},
        onDone: () {
          setState(() {
            isLoadingTopMarkets = false;
            if (topMarkets.isEmpty) {
              isLoadingTrendingProducts = false;
              isLoadingCategories = false;
            } else {
              listenForCategories();
              listenForTrendingProducts();
            }
          });
        });
  }

  Future<void> listenForPopularMarkets() async {
    final Stream<Market> stream =
        await getPopularMarkets(deliveryAddress.value!);
    stream.listen((Market _market) {
      setState(() => popularMarkets.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForTrendingProducts() async {
    final Stream<Product> stream =
        await getTrendingProductsOfMarket(topMarkets[0].id);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      print('done called');

      setState(() {
        print('done loading');
        isLoadingTrendingProducts = false;
      });
    });
  }

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(state!.context);
    Overlay.of(state!.context)!.insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      isLoadingTopMarkets = true;
      isLoadingCategories = true;
      isLoadingTrendingProducts = true;
      slides = <Slide>[];
      categories = <Category>[];
      topMarkets = <Market>[];
      popularMarkets = <Market>[];
      recentReviews = <Review>[];
      trendingProducts = <Product>[];
    });
    await listenForSlides();
    await listenForTopMarkets();
    await listenForPopularMarkets();
    await listenForRecentReviews();
  }
}
