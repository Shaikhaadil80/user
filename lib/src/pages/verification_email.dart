import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/route_argument.dart';

class EmailVerificationWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  EmailVerificationWidget({Key? key, required this.routeArgument})
      : super(key: key);
  @override
  _EmailVerificationWidgetState createState() =>
      _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends StateMVC<EmailVerificationWidget> {
  late UserController _con;

  _EmailVerificationWidgetState() : super(UserController()) {
    _con = controller as UserController;
  }

  late String email;

  @override
  Widget build(BuildContext context) {
    email = (widget.routeArgument).param;
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              //   width: config.App(context).appWidth(100),
              height: 150,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              child: Container(
                //width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(29.5),
                child: Center(
                  child: Text(
                    S.of(context).successfully_registered,
                    style: Theme.of(context).textTheme.headline2!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.green.withOpacity(1),
                        Colors.green.withOpacity(0.2),
                      ])),
              child: _con.loading
                  ? Padding(
                      padding: const EdgeInsets.all(55),
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).scaffoldBackgroundColor),
                      ),
                    )
                  : Icon(
                      Icons.check,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 90,
                    ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                S.of(context).email_verification_link_has_been_sent_to +
                    ' ' +
                    email,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  child: MaterialButton(
                    elevation: 0,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    disabledColor:
                        Theme.of(context).focusColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: Theme.of(context).colorScheme.secondary,
                    shape: const StadiumBorder(),
                    child: Text(
                      S.of(context).done,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
