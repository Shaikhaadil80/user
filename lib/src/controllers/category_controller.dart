import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/product_repository.dart';

class CategoryController extends ControllerMVC {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState>? scaffoldKey;
  List<Category> categories = [];
  Category? category;
  bool loadCart = false;
  List<Cart> carts = [];

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForProductsByCategory({String? id, String? message}) async {
    final Stream<Product> stream = await getProductsByCategory(id);
    stream.listen((Product _product) {
      setState(() {
        products.add(_product);
      });
    }, onError: (a) {
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey!.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void getAllCategories() async {
    await getAllCategory()
        .then((value) =>setState(() => this.categories.addAll(value)))
        .onError((error, stackTrace) =>
            ScaffoldMessenger.of(scaffoldKey!.currentContext!)
                .showSnackBar(SnackBar(
              content:
                  Text(S.of(state!.context).verify_your_internet_connection),
            )));
            print('response ${categories}');
  }

  void listenForCategory({String? id, String? message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey!.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart?> stream = await getCart();
    stream.listen((Cart? _cart) {
      if(_cart==null){

      }else
      carts.add(_cart);
    });
  }

  bool isSameMarkets(Product product) {
    if (carts.isNotEmpty) {
      return carts[0].product.market!.id == product.market!.id;
    }
    return true;
  }

  /*void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _cart = new Cart();
    _cart.product = product;
    _cart.options = [];
    _cart.quantity = 1;
    addCart(_cart, reset).then((value) {
      setState(() {
        this.loadCart = false;
      });
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).this_product_was_added_to_cart),
      ));
    });
  }*/

  void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart;
    _newCart.product = product;
    _newCart.options = [];
    _newCart.quantity = 1;
    // if product exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity++;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(scaffoldKey!.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(S.of(state!.context).this_product_was_added_to_cart),
        ));
      });
    } else {
      // the product doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(scaffoldKey!.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(S.of(state!.context).this_product_was_added_to_cart),
        ));
      });
    }
  }

  Cart? isExistInCart(Cart _cart) {
    if (carts.isEmpty) {
      return null;
    }
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: null);
  }

  Future<void> refreshCategory() async {
    products.clear();
    category = null;
    listenForProductsByCategory(
        message: S.of(state!.context).category_refreshed_successfuly);
    listenForCategory(
        message: S.of(state!.context).category_refreshed_successfuly);
  }

  Future<void> refreshAllCategory() async {
    categories.clear();
    getAllCategories();
  }
}
