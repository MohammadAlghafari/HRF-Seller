
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/language_constrants.dart';
import '../../provider/shipping_provider.dart';
import '../../utill/dimensions.dart';
import '../../utill/styles.dart';

import 'custom_button.dart';
class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  ConfirmationDialog({@required this.icon, this.title, @required this.description, @required this.onYesPressed, this.isLogOut = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Image.asset(icon, width: 50, height: 50),
          ),

          title != null ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              title, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.red),
            ),
          ) : SizedBox(),

          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(description, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), textAlign: TextAlign.center),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        Consumer<ShippingProvider>(builder: (context, shippingProvider, child) {
          return !shippingProvider.isLoading ? Row(children: [
            Expanded(child: TextButton(
              onPressed: () => Navigator.pop(context), style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
            ),
              child: Text(getTranslated('no',context), textAlign: TextAlign.center,
                style: robotoBold.copyWith(color: Colors.white),
              ),
            )),
            SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
            Expanded(child: CustomButton(
              btnTxt: getTranslated('yes',context),
              onTap: () =>  onYesPressed(),
            )),

          ]) : Center(child: CircularProgressIndicator());
        }),
      ])),
    ));
  }
}