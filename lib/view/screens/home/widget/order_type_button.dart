import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/response/order_model.dart';
import '../../../../provider/order_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';

class OrderTypeButton extends StatelessWidget {
  final String text;
  final Color color;
  final int index;
  final Function callback;
  final List<OrderModel> orderList;
  OrderTypeButton({@required this.text,this.color ,@required this.index, @required this.callback, @required this.orderList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<OrderProvider>(context, listen: false).setIndex(index);
        callback();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),),
        color: color,
        child: Container(
          alignment: Alignment.center,
          width: 100,
          // padding: EdgeInsets.all(10),
          // margin: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Color(0xFFFEF7DC),
            borderRadius: BorderRadius.circular(12),
          //   boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(orderList.length.toString(),
                  style: robotoTitleRegular.copyWith(color: Colors.black45, fontSize: Dimensions.PADDING_SIZE_LARGE)),

              SizedBox(height: 5),
              Text(text,
                  style: robotoRegular.copyWith(color: ColorResources.getHintColor(context))),

            ],
          ),
        ),
      ),
    );
  }
}
