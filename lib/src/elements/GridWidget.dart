import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../elements/GridItemWidget.dart';
import '../models/market.dart';

class GridWidget extends StatelessWidget {
  final List<Market> marketsList;
  final String heroTag;
  GridWidget({Key? key, required this.marketsList, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: marketsList.length,
      itemBuilder: (BuildContext context, int index) {
        return GridItemWidget(
            market: marketsList.elementAt(index), heroTag: heroTag);
      },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );
  }
}
