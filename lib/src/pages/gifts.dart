import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../generated/l10n.dart';
import '../controllers/gifts_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class GiftsWidget extends StatefulWidget {
  @override
  _GiftsWidgetState createState() => _GiftsWidgetState();
}

class _GiftsWidgetState extends StateMVC<GiftsWidget> {
  late GiftsController _con;
  _GiftsWidgetState() : super(GiftsController()) {
    _con = controller as GiftsController;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).gifts,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: currentUser.value?.apiToken == null
          ? PermissionDeniedWidget()
          : _con.isLoading
              ? CircularLoadingWidget(height: 500)
              : _con.isLoading == false && _con.showError
                  ? Center(child: Text(S.of(context).failed_loading_items))
                  : _con.gift!.promo!.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.gift,
                                size: 80,
                                color:
                                    Theme.of(context).focusColor.withOpacity(1),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                S.of(context).your_gifts_will_appear_here,
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.gift!.promo!.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            _con.gift!.promo![index]!.image),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _con.gift!.promo![index]!
                                                  .productName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              _con.gift!.promo![index]!
                                                  .ruleDescription,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ),
    );
  }
}
