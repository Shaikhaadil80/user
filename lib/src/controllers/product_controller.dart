import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/favorite.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/product_repository.dart';
import '../repository/user_repository.dart';

class ProductController extends ControllerMVC {
  Product? product;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite? favorite;
  bool loadCart = false;
  int current = 0;
  late GlobalKey<ScaffoldState> scaffoldKey;

  ProductController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  void listenForProduct({required String productId, String? message}) async {
    final Stream<Product?> stream = await getProduct(productId);
    stream.listen((Product? _product) {
      if (_product == null) {
      } else
        setState(() => product = _product);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForFavorite({required String productId}) async {
    final Stream<Favorite?> stream = await isFavoriteProduct(productId);
    stream.listen((Favorite? _favorite) {
      if (_favorite == null) {
      } else
        setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  Future<void> listenForCart() async {
    final Stream<Cart?> stream = await getCart();
    stream.listen((Cart? _cart) {
      if (_cart == null) {
      } else
        carts.add(_cart);
    });
  }

  bool isSameMarkets(Product product) {
    if (carts.isNotEmpty) {
      return carts[0].product.market!.id == product.market!.id;
    }
    return true;
  }

  Future<void> addToCart(Product product, {bool reset = false}) async {
    setState(() {
      loadCart = true;
    });
    await listenForCart();
    Cart? _newCart = Cart(
        id: '',
        product: product,
        quantity: quantity,
        options: product.options.where((element) => element.checked).toList(),
        userId: currentUser.value?.id ?? '');

    // if product exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity += quantity;
      updateCart(_oldCart).then((value) {
        setState(() {
          loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(state!.context).showSnackBar(SnackBar(
          content: Text(S.of(state!.context).this_product_was_added_to_cart),
        ));
        setState(() {
          loadCart = false;
        });
      });
    } else {
      // the product doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(state!.context).showSnackBar(SnackBar(
          content: Text(S.of(state!.context).this_product_was_added_to_cart),
        ));
        setState(() {
          loadCart = false;
        });
      });
    }
  }

  Cart? isExistInCart(Cart _cart) {
    if (carts.isEmpty) {
      return null;
    }
    return carts.firstWhereOrNull((Cart oldCart) => _cart.isSame(oldCart));
  }

  void addToFavorite(Product product) async {
    var _favorite = new Favorite();
    _favorite.product = product;
    _favorite.options = product.options.where((Option _option) {
      return _option.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        favorite = value;
      });
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).thisProductWasAddedToFavorite),
      ));
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        favorite = new Favorite();
      });
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).thisProductWasRemovedFromFavorites),
      ));
    });
  }

  Future<void> refreshProduct() async {
    var _id = product!.id;
    product = null;
    listenForFavorite(productId: _id);
    listenForProduct(
        productId: _id,
        message: S.of(state!.context).productRefreshedSuccessfuly);
  }

  void calculateTotal() {
    total = product?.price ?? 0;
    product?.options.forEach((option) {
      total += option.checked ? option.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (quantity <= 999) {
      ++quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (quantity > 1) {
      --quantity;
      calculateTotal();
    }
  }
}
