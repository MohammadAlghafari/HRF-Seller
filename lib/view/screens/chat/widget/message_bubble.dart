import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/response/chat_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/styles.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel chat;
  final String customerImage;
  MessageBubble({@required this.chat, @required this.customerImage});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat.sentByCustomer == 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe ? SizedBox.shrink() : InkWell(child: ClipOval(child: Container(
          color: Theme.of(context).highlightColor,
          child: CachedNetworkImage(
            errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
            placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
            imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/$customerImage',
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ))),
        Flexible(
          child: Container(
              margin: isMe ?  EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 10, 50, 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: isMe ? ColorResources.getImageBg(context) : Theme.of(context).highlightColor,
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                !isMe ? Text(DateConverter.localDateToIsoStringAMPM(DateConverter.isoStringToLocalDate(chat.createdAt)), style: titilliumRegular.copyWith(
                  fontSize: 8,
                  color: ColorResources.getHint(context),
                )) : SizedBox.shrink(),

                chat.message.isNotEmpty ? Text(chat.message, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)) : SizedBox.shrink(),
              ]),
          ),
        ),
      ],
    );
  }
}
