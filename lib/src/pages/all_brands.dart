import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/brand_controller.dart';
import '../elements/BrandWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';

class BrandsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  BrandsWidget({Key? key, required this.parentScaffoldKey}) : super(key: key);

  @override
  _BrandWidgetState createState() => _BrandWidgetState();
}

class _BrandWidgetState extends StateMVC<BrandsWidget> {
  late BrandController _con;

  _BrandWidgetState() : super(BrandController()) {
    _con = controller as BrandController;
  }

  @override
  void initState() {
    _con.getAllBrandsFromRepo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(onFilter: (filter) {
        // Navigator.of(context).pushReplacementNamed('/Category', arguments: RouteArgument(id: widget.routeArgument.id));
      }),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).category,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.5, vertical: 15),
                  child: SizedBox(
                    width: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshAllBrands,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(onClickFilter: (filter) {
                  _con.scaffoldKey?.currentState?.openEndDrawer();
                }),
              ),
              const SizedBox(height: 10),
              _con.brands.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : GridView.count(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 2
                          : 4,
                      children: List.generate(_con.brands.length, (index) {
                        return BrandItemWidget(
                            heroTag: 'brand_grid',
                            brand: _con.brands.elementAt(index),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/Brand',
                                  arguments: RouteArgument(
                                      id: _con.brands
                                          .elementAt(index)
                                          .id
                                          .toString()));
                            });
                      }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
