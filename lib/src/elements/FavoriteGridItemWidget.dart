import 'package:flutter/material.dart';

import '../models/favorite.dart';
import '../models/route_argument.dart';

class FavoriteGridItemWidget extends StatelessWidget {
  final String heroTag;
  final Favorite favorite;

  FavoriteGridItemWidget(
      {Key? key, required this.heroTag, required this.favorite})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(
                heroTag: this.heroTag, id: this.favorite.product!.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: heroTag + favorite.product!.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              NetworkImage(this.favorite.product!.image!.thumb),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                favorite.product!.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                favorite.product!.market!.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: MaterialButton(
              elevation: 0,
              padding: const EdgeInsets.all(0),
              onPressed: () {},
              child: Icon(
                Icons.favorite_outline,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
