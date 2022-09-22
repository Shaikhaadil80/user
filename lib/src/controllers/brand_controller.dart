import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/brand.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../repository/branch_repository.dart';
import '../repository/cart_repository.dart';

class BrandController extends ControllerMVC {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState>? scaffoldKey;
  List<Brand> brands = [];
  Brand? brand;
  bool loadCart = false;
  List<Cart> carts = [];

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<List<Brand>> getAllBrandsFromRepo() async {
    print('getting brands');
    return await getAllBrands();
  }

  void getAllProductsByBrands(int brandId, int marketId) async {
    await getAllProductsByBrandAndMarket(brandId, marketId)
        .then((value) => setState(() => this.products.addAll(value)))
        .onError((error, stackTrace) =>
            ScaffoldMessenger.of(scaffoldKey!.currentContext!)
                .showSnackBar(SnackBar(
              content:
                  Text(S.of(state!.context).verify_your_internet_connection),
            )));
    print('response ${products}');
  }

  void listenForCart() async {
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

  Future<void> refreshAllBrands() async {
    brands.clear();
    getAllBrandsFromRepo();
  }
}
