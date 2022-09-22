import 'package:flutter/material.dart';

import '../models/brand.dart';

class BrandItemWidget extends StatefulWidget {
  final Brand brand;
  dynamic heroTag;
  dynamic onPressed;

  BrandItemWidget({
    Key? key,
    required this.brand,
    required this.heroTag,
    required this.onPressed,
  }) : super(key: key);

  @override
  _ProductGridItemWidgetState createState() => _ProductGridItemWidgetState();
}

class _ProductGridItemWidgetState extends State<BrandItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
      onTap: widget.onPressed,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(this.widget.brand.image?.thumb ?? ''),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: Center(
                child: Text(
                  widget.brand.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
