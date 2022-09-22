import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/option.dart';

class OptionItemWidget extends StatefulWidget {
  final Option option;
  final VoidCallback onChanged;

  OptionItemWidget({
    Key? key,
    required this.option,
    required this.onChanged,
  }) : super(key: key);

  @override
  _OptionItemWidgetState createState() => _OptionItemWidgetState();
}

class _OptionItemWidgetState extends State<OptionItemWidget>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;
  late Animation<double> sizeCheckAnimation;
  late Animation<double> rotateCheckAnimation;
  late Animation<double> opacityAnimation;
  late Animation opacityCheckAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween(begin: 0.0, end: 60.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    opacityCheckAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    rotateCheckAnimation = Tween(begin: 2.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    sizeCheckAnimation = Tween<double>(begin: 0, end: 36).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.option.checked) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
        widget.option.checked = !widget.option.checked;
        widget.onChanged();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  image: DecorationImage(
                      image: NetworkImage(widget.option.image!.thumb),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: animation.value,
                width: animation.value,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(opacityAnimation.value),
                ),
                child: Transform.rotate(
                  angle: rotateCheckAnimation.value,
                  child: Icon(
                    Icons.check,
                    size: sizeCheckAnimation.value,
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(opacityCheckAnimation.value),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.option.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        Helper.skipHtml(widget.option.description),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Helper.getPrice(widget.option.price, context,
                    style: Theme.of(context).textTheme.headline4),
              ],
            ),
          )
        ],
      ),
    );
  }
}
