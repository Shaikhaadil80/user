import 'package:flutter/material.dart';

import '../models/address.dart' as model;
import '../models/payment_method.dart';

// ignore: must_be_immutable
class DeliveryAddressesItemWidget extends StatelessWidget {
  model.Address address;
  PaymentMethod? paymentMethod;
  ValueChanged<model.Address> onPressed;
  ValueChanged<model.Address> onLongPress;
  ValueChanged<model.Address>? onDismissed;

  DeliveryAddressesItemWidget({
    Key? key,
    required this.address,
    this.paymentMethod,
    required this.onPressed,
    required this.onLongPress,
    this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onDismissed != null) {
      return Dismissible(
        key: Key(address.id.toString()),
        onDismissed: (direction) {
          this.onDismissed!(address);
        },
        child: buildItem(context),
      );
    } else {
      return buildItem(context);
    }
  }

  InkWell buildItem(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      focusColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        this.onPressed(address);
      },
      onLongPress: () {
        this.onLongPress(address);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2)),
          ],
        ),
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
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: (address.isDefault ?? false) ||
                              (paymentMethod?.selected ?? false)
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).focusColor),
                  child: Icon(
                    (paymentMethod?.selected ?? false)
                        ? Icons.check
                        : Icons.place_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 38,
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
                        address.description != null
                            ? Text(
                                address.description!,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            : const SizedBox(height: 0),
                        Text(
                          address.address,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: address.description != null
                              ? Theme.of(context).textTheme.caption
                              : Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
