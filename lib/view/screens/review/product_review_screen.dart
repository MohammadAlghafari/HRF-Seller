import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/response/review_model.dart';
import '../../../provider/product_review_provider.dart';
import 'widget/review_widget.dart';
class ProductReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ProductReviewProvider>(
        builder: (context, reviewProvider, child) {
          List<ReviewModel> reviewList;
          reviewList = reviewProvider.reviewList;


          return Column(children: [
            ListView.builder(
              itemCount: reviewList.length,
              // crossAxisCount: 2,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              itemBuilder: (BuildContext context, int index) {
                return ReviewWidget(reviewModel: reviewList[index]);
              },
            ),

          ]);
        },
      ),
    );
  }
}
