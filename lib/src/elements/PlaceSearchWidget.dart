import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../helpers/place_search_delegate.dart';
import '../models/address.dart';
import '../repository/auto_complete_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class PlaceSearchWidget extends StatefulWidget {
  final HomeController con;
  PlaceSearchWidget({required this.con});
  @override
  _PlaceSearchWidgetState createState() => _PlaceSearchWidgetState();
}

class _PlaceSearchWidgetState extends State<PlaceSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        var results = await showSearch(
            context: context, delegate: PlaceSearchDelegate(), query: '');
        if (results != null) {
          if (results['load_from_address'] == false) {
            Map details = await getPlaceDetails(results['place_id']);
            Address address = Address(
                address: results['main_text'],
                latitude: details['latitude'],
                longitude: details['longitude']);

            deliveryAddress.value = address;
            deliveryCity.value = details['city'];
            deliveryAddress.notifyListeners();
            deliveryCity.notifyListeners();
          }

          widget.con.refreshHome();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 9),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              S.of(context).delivering_to + ':',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Flexible(
                child: Text(
              deliveryCity.value,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .merge(const TextStyle(fontSize: 13)),
            )),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.secondary,
            )
          ],
        ),
      ),
    );
  }
}
