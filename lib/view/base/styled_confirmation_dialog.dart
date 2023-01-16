import 'package:flutter/material.dart';

import '../../localization/language_constrants.dart';
import '../../utill/color_resources.dart';
import '../../utill/dimensions.dart';
import '../../utill/styles.dart';

class StyledConfirmationDialog extends StatelessWidget {
  final String description;
  final Function onYesPressed;

  StyledConfirmationDialog({this.description, this.onYesPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getBottomSheetColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.contact_support, size: 50),
        ),
        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Text(description, 
              style: titilliumBold, textAlign: TextAlign.center),
        ),
        Divider(height: 0, color: ColorResources.getHintColor(context)),
        Row(children: [
          Expanded(
              child: InkWell(
            onTap: onYesPressed,
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('yes', context),
                  style: titilliumBold.copyWith(
                      color: Theme.of(context).primaryColor)),
            ),
          )),
          Expanded(
              child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorResources.getPrimary(context),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('no', context),
                  style: titilliumBold.copyWith(color: Colors.white)),
            ),
          )),
        ]),
      ]),
    );
  }
}
