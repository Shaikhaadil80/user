import 'package:flutter/material.dart';

import '../elements/CircularLoadingWidget.dart';
import '../elements/ReviewItemWidget.dart';
import '../models/review.dart';

// ignore: must_be_immutable
class ReviewsListWidget extends StatelessWidget {
  List<Review> reviewsList;

  ReviewsListWidget({Key? key, required this.reviewsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(' reviews list ${reviewsList}');
    return reviewsList.isEmpty
        ? CircularLoadingWidget(height: 200)
        : ListView.separated(
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return ReviewItemWidget(review: reviewsList.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
            itemCount: reviewsList.length,
            primary: false,
            shrinkWrap: true,
          );
  }
}
