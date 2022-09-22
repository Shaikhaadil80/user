import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../repository/auto_complete_repository.dart';
import '../repository/settings_repository.dart';

class PlaceSearchDelegate extends SearchDelegate {
  List<Map<String, dynamic>> res = [];
  String uuid = Uuid().generateV4();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  PreferredSizeWidget buildBottom(BuildContext context) {
    return PreferredSize(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            close(context, {'load_from_address': true});
            await setCurrentLocation();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.location_searching_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  S.of(context).pick_from_my_location,
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(70));
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (res.isEmpty) {
      return Center(child: Text(S.of(context).no_suggestions_found));
    } else {
      return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: res.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              close(context, res[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    res[index]['main_text'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    res[index]['secondary_text'],
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(S.of(context).suggestions_will_appear_here),
      );
    }
    return FutureBuilder<List<Map<String, dynamic>>>(
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            res = snapshot.data!;

            if (res.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).no_suggestions_found,
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            } else {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: res.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      close(context, res[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            res[index]['main_text'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            res[index]['secondary_text'],
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 80,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    S.of(context).failed_loading_suggestions,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
            );
          } else {
            return CircularLoadingWidget(height: 500);
          }
        },
        future: getPlaceSuggestions(query, uuid));
  }
}
