import 'package:flutter/material.dart';

import '../elements/DrawerWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../pages/home.dart';
import '../pages/notifications.dart';
import '../pages/orders.dart';
import 'messages.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument? routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget? currentPage;
  PagesWidget({
    Key? key,
    required this.currentTab,
  }) {
    currentPage ==
        HomeWidget(
          parentScaffoldKey: scaffoldKey,
        );
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 3;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage =
              HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage =
              NotificationsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        // case 1:
        //   widget.currentPage =
        //       BrandsWidget(parentScaffoldKey: widget.scaffoldKey);
        //   break;
        // case 2:
        //   widget.currentPage = MapWidget(
        //       parentScaffoldKey: widget.scaffoldKey,
        //       routeArgument: widget.routeArgument);
        //   break;
        case 2:
          widget.currentPage =
              OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage = MessagesWidget(
              parentScaffoldKey: widget
                  .scaffoldKey); //FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context, widget.scaffoldKey).onWillPop,
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        // endDrawer: FilterWidget(onFilter: (filter) {
        //   Navigator.of(context)
        //       .pushReplacementNamed('/Pages', arguments: widget.currentTab);
        // }),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: Container(
                  width: 42,
                  height: 42,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                          blurRadius: 40,
                          offset: const Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                          blurRadius: 13,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: new Icon(
                      widget.currentTab == 0 ? Icons.home : Icons.home_outlined,
                      color: Theme.of(context).primaryColor),
                )),
            BottomNavigationBarItem(
              icon: Icon(widget.currentTab == 1
                  ? Icons.notifications
                  : Icons.notifications_outlined),
              label: '',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(widget.currentTab == 1
            //       ? Icons.category
            //       : Icons.category_outlined),
            //   label: '',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(widget.currentTab == 2
            //       ? Icons.location_on
            //       : Icons.location_on_outlined),
            //   label: '',
            // ),
            BottomNavigationBarItem(
              icon: new Icon(widget.currentTab == 2
                  ? Icons.local_mall
                  : Icons.local_mall_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                  widget.currentTab == 3 ? Icons.chat : Icons.chat_outlined),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
