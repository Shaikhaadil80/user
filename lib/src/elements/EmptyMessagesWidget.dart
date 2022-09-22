import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class EmptyMessagesWidget extends StatefulWidget {
  EmptyMessagesWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EmptyMessagesWidgetState createState() => _EmptyMessagesWidgetState();
}

class _EmptyMessagesWidgetState extends State<EmptyMessagesWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ),
              )
            : const SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: config.App(context).appHeight(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: 0.4,
                child: Text(
                  S.of(context).youDontHaveAnyConversations,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .merge(const TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              const SizedBox(height: 20),
              !loading
                  ? MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Pages', arguments: 0);
                      },
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(1),
                      shape: const StadiumBorder(),
                      child: Text(
                        S.of(context).start_exploring,
                        style: Theme.of(context).textTheme.headline6!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        )
      ],
    );
  }
}
