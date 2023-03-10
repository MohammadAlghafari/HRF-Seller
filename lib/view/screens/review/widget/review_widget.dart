import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/response/review_model.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/styles.dart';
class ReviewWidget extends StatelessWidget {
  final ReviewModel reviewModel;
  ReviewWidget({@required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: Stack(
        children: [
          Card(
            child: Column(children: [

              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: 70,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CachedNetworkImage(
                              placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                              errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,),
                              imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${reviewModel.product.thumbnail}',)
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(reviewModel.product.name ?? '', style: robotoRegular, maxLines: 3, overflow: TextOverflow.ellipsis),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Row(children: [
                              // Text(reviewModel.rating != null ? reviewModel.rating != 0 ? reviewModel.rating.toString() : '0.0' : '0.0',
                              //     style: robotoRegular.copyWith(
                              //       color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange,
                              //       fontSize: Dimensions.FONT_SIZE_SMALL,
                              //     )),
                              for(int i = 0; i<reviewModel.rating; i++)
                                Icon(Icons.star, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange, size: 15),


                                 ]),
                            Text(reviewModel.comment ?? '', style: robotoHintRegular, maxLines: 3, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                          ],),
                      ),
                    )

                  ],),
              ),

            ],),
          ),
          // Off
         ],
      ),
    );

  }
}
