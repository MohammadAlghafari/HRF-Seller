import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/order_model.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/price_converter.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/order_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/no_data_screen.dart';
import '../../base/styled_confirmation_dialog.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  final int orderId;
  OrderDetailsScreen({this.orderModel, @required this.orderId});

  void _loadData(BuildContext context) async {
    if (orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false)
          .initConfig(context);
    }
    Provider.of<OrderProvider>(context, listen: false)
        .getOrderDetails(orderId.toString(), context);
    Provider.of<OrderProvider>(context, listen: false)
        .initOrderStatusList(context);
  }

  List<String> _getOrderStatuses(
    OrderProvider order,
  ) {
    List<String> values = [];
    List<String> statuses = order.orderStatusList;
    int orderStatusIndex =
        order.orderStatusList.indexOf(orderModel.orderStatus);
    for (int i = 0; i < statuses.length; i++) {
      if (i > orderStatusIndex) {
        values.add(statuses[i]);
      }
    }
    values.insert(0, statuses[0]);
    return values;
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('order_details', context)),
      backgroundColor: ColorResources.getHomeBg(context),
      body: Consumer<OrderProvider>(builder: (context, order, child) {
        List<String> orderAvailableStatuses = _getOrderStatuses(order);
        double _itemsPrice = 0;
        double _discount = 0;
        double _coupon = orderModel.discountAmount;
        double _tax = 0;
        double _shipping = orderModel.shippingCost;
        if (order.orderDetails != null) {
          order.orderDetails.forEach((orderDetails) {
            _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.qty);
            _discount = _discount + (orderDetails.discount * orderDetails.qty);
            _tax = _tax + (orderDetails.tax * orderDetails.qty);
          });
        }
        double _subTotal = _itemsPrice + _tax - _discount;
        double _totalPrice = _subTotal + _shipping - _coupon;

        return order.orderDetails != null
            ? order.orderDetails.length > 0
                ? ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    children: [
                      // for details
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 800
                                        : 200],
                                spreadRadius: 0.5,
                                blurRadius: 0.3)
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${getTranslated('order_no', context)} : #${orderModel.id}',
                                      style: titilliumSemiBold.copyWith(
                                          color: ColorResources.getTextColor(
                                              context),
                                          fontSize: 14),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                        color: ColorResources.getFloatingBtn(
                                            context),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                          orderModel.orderStatus.toUpperCase(),
                                          style: titilliumSemiBold),
                                    ),
                                  ]),
                              SizedBox(height: 10),
                              Text(
                                  DateConverter.localDateToIsoStringAMPM(
                                      DateTime.parse(orderModel.createdAt)),
                                  style: titilliumRegular.copyWith(
                                      color:
                                          ColorResources.getTextColor(context),
                                      fontSize: Dimensions.FONT_SIZE_SMALL)),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '${getTranslated('payment_method', context)}:',
                                    style: titilliumSemiBold.copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontSize: 14),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    (orderModel.paymentMethod != null &&
                                            orderModel.paymentMethod.length > 0)
                                        ? '${orderModel.paymentMethod[0].toUpperCase()}${orderModel.paymentMethod.substring(1).replaceAll('_', ' ')}'
                                        : 'Digital Payment',
                                    style: titilliumSemiBold.copyWith(
                                        color: ColorResources.getBlue(context),
                                        fontSize: 14),
                                  ),
                                  //Expanded(child: SizedBox()),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '${getTranslated('shipping_method', context)}:',
                                    style: titilliumSemiBold.copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontSize: 14),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    order.orderDetails[0].shipping.title,
                                    style: titilliumSemiBold.copyWith(
                                        color: ColorResources.getBlue(context),
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    getTranslated('details', context),
                                    style: titilliumSemiBold.copyWith(
                                        fontSize: 12),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Consumer<OrderProvider>(
                                      builder: (context, order, child) {
                                    return TextButton(
                                        onPressed: order.orderList
                                                    .firstWhere((element) =>
                                                        element.id == orderId)
                                                    .paymentStatus !=
                                                'paid'
                                            ? () {
                                                showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (_) =>
                                                        StyledConfirmationDialog(
                                                          description:
                                                              getTranslated(
                                                                  'are_you_sure_you_want_to_make_this_order_paid',
                                                                  context),
                                                          onYesPressed: () {
                                                            Provider.of<OrderProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .updateOrderPaidStatus(
                                                                    orderModel
                                                                        .id);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ));
                                              }
                                            : null,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: 15,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: order.orderList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      orderId)
                                                              .paymentStatus ==
                                                          'paid'
                                                      ? ColorResources.GREEN
                                                      : ColorResources.RED),
                                            ),
                                            Text(
                                                order.orderList
                                                    .firstWhere((element) =>
                                                        element.id == orderId)
                                                    .paymentStatus
                                                    .toUpperCase(),
                                                style: titilliumBold.copyWith(
                                                    color: order.orderList
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        orderId)
                                                                .paymentStatus ==
                                                            'paid'
                                                        ? ColorResources.GREEN
                                                        : ColorResources.RED,
                                                    fontSize: 14)),
                                          ],
                                        ));
                                  }),
                                ],
                              )
                            ]),
                      ),

                      // for product view
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 800
                                        : 200],
                                spreadRadius: 0.5,
                                blurRadius: 0.3)
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                SizedBox(
                                  width: 130,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    getTranslated('item', context),
                                    style: titilliumSemiBold.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: ColorResources.getTextColor(
                                            context)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 35),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      getTranslated('price', context),
                                      style: titilliumSemiBold.copyWith(
                                          color: ColorResources.getTextColor(
                                              context)),
                                    )),
                              ]),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: order.orderDetails.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: FadeInImage.assetNetwork(
                                                imageErrorBuilder: (c, o, s) =>
                                                    Image.asset(Images
                                                        .placeholder_image),
                                                placeholder:
                                                    Images.placeholder_image,
                                                image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${order.orderDetails[index].productDetails.thumbnail}',
                                                height: 70,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          Text(
                                              ' x ${order.orderDetails[index].qty}',
                                              style: titilliumRegular.copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context))),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_EXTRA_LARGE),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              children: [
                                                Text(
                                                  order.orderDetails[index]
                                                      .productDetails.name,
                                                  style: titilliumSemiBold
                                                      .copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: ColorResources
                                                              .getPrimary(
                                                                  context)),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_DEFAULT),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                PriceConverter.convertPrice(
                                                    context,
                                                    order
                                                        .orderDetails[index]
                                                        .productDetails
                                                        .unitPrice
                                                        .toDouble()),
                                                style:
                                                    titilliumSemiBold.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                              ))
                                        ],
                                      ),

                                      SizedBox(height: 10),

                                      (order.orderDetails[index].variant !=
                                                  null &&
                                              order.orderDetails[index].variant
                                                  .isNotEmpty)
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              child: Row(children: [
                                                Text(
                                                    '${getTranslated('variations', context)} : ',
                                                    style: titilliumSemiBold
                                                        .copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_SMALL)),
                                                Flexible(
                                                    child: Text(
                                                        order
                                                            .orderDetails[index]
                                                            .variant,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ))),
                                              ]),
                                            )
                                          : SizedBox(),
                                      // Total
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'item_price', context),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                            Text(
                                                PriceConverter.convertPrice(
                                                    context,
                                                    order.orderDetails[index]
                                                            .price *
                                                        order
                                                            .orderDetails[index]
                                                            .qty),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                          ]),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(getTranslated('tax', context),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                            Text(
                                                '(+) ${PriceConverter.convertPrice(context, _tax)}',
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                          ]),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'discount', context),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                            Text(
                                                '(-) ${PriceConverter.convertPrice(context, _discount)}',
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                          ]),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'sub_total', context),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                            Text(
                                                PriceConverter.convertPrice(
                                                    context,
                                                    order.orderDetails[index]
                                                            .price +
                                                        (order
                                                                .orderDetails[
                                                                    index]
                                                                .tax *
                                                            order
                                                                .orderDetails[
                                                                    index]
                                                                .qty) -
                                                        order
                                                            .orderDetails[index]
                                                            .discount),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                          ]),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'coupon_discount', context),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                            Text(
                                                '(-) ${PriceConverter.convertPrice(context, _coupon)}',
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                          ]),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'shipping_fee', context),
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                            Text(
                                                '(+) ${PriceConverter.convertPrice(context, _shipping)}',
                                                style:
                                                    titilliumRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                          ]),
                                      Divider()
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated('total_amount', context),
                                        style: titilliumSemiBold.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_LARGE,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Text(
                                      PriceConverter.convertPrice(
                                          context, _totalPrice),
                                      style: titilliumSemiBold.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_LARGE,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ]),
                            ]),
                      ),

                      // for address
                      if (order.orderDetails[0].shipping.title != 'Pickup')
                        Container(
                          margin:
                              EdgeInsets.only(left: 5, right: 5, bottom: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: ColorResources.getBottomSheetColor(context),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[
                                      Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? 800
                                          : 200],
                                  spreadRadius: 0.5,
                                  blurRadius: 0.3)
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('shipping_address', context),
                                    style: titilliumSemiBold.copyWith(
                                        fontSize: 14)),
                                Text(
                                  '${getTranslated('name', context)} : ${orderModel.customer.fName ?? ''} ${orderModel.customer.lName ?? ''}',
                                  style: titilliumRegular,
                                ),
                                Text(
                                    '${getTranslated('address', context)} : ${orderModel.shippingAddressData != null ? jsonDecode(orderModel.shippingAddressData)['city'] + ', ' + jsonDecode(orderModel.shippingAddressData)['address'] + ', ' + jsonDecode(orderModel.shippingAddressData)['building'] : orderModel.shippingAddress ?? ''}',
                                    style: titilliumRegular),
                                Text(
                                    '${getTranslated('phone', context)} : ${orderModel.customer.phone ?? ''}',
                                    style: titilliumRegular),
                              ]),
                        ),

                      // for Customer Details
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 800
                                        : 200],
                                spreadRadius: 0.5,
                                blurRadius: 0.3)
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  getTranslated(
                                      'customer_contact_details', context),
                                  style: titilliumSemiBold.copyWith(
                                      color: ColorResources.getTextColor(
                                          context))),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                        errorWidget: (ctx, url, err) =>
                                            Image.asset(
                                                Images.placeholder_image),
                                        placeholder: (ctx, url) => Image.asset(
                                            Images.placeholder_image),
                                        imageUrl:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${orderModel.customer.image}',
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover),
                                  ),
                                  SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${orderModel.customer.fName ?? ''} ${orderModel.customer.lName ?? ''}',
                                          style: titilliumBold.copyWith(
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                              fontSize: 14)),
                                      Text(
                                          '${getTranslated('email', context)} : ${orderModel.customer.email ?? ''}',
                                          style: titilliumSemiBold.copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                              fontSize: 12)),
                                      Text(
                                          '${getTranslated('contact', context)} : ${orderModel.customer.phone}',
                                          style: titilliumSemiBold.copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                              fontSize: 12)),
                                    ],
                                  ))
                                ],
                              )
                            ]),
                      ),

                      (order.addOrderStatusErrorText != null &&
                              order.addOrderStatusErrorText.isNotEmpty)
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                order.addOrderStatusErrorText,
                                style: titilliumRegular.copyWith(
                                    color: order.addOrderStatusErrorText
                                            .contains('updated')
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      order.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  key: Key(''),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Consumer<OrderProvider>(
                                  builder: (context, order, child) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: Dimensions.PADDING_SIZE_DEFAULT,
                                          right:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).highlightColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        alignment: Alignment.center,
                                        child: DropdownButtonFormField<String>(
                                          value: order.orderStatusType,
                                          isExpanded: true,
                                          icon: Icon(Icons.keyboard_arrow_down,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: titilliumRegular,
                                          //underline: SizedBox(),

                                          onChanged: order.updateStatus,
                                          items: orderAvailableStatuses
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style:
                                                      titilliumRegular.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .color)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: InkWell(
                                          onTap: () async {
                                            if (Provider.of<OrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .orderStatusType ==
                                                Provider.of<OrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .orderStatusList[0]) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(getTranslated(
                                                    'select_order_type',
                                                    context)),
                                                backgroundColor: Colors.red,
                                              ));
                                            } else {
                                              Provider.of<OrderProvider>(
                                                      context,
                                                      listen: false)
                                                  .setOrderStatusErrorText('');

                                              List<int> _productIds = [];
                                              order.orderDetails
                                                  .forEach((orderDetails) {
                                                _productIds
                                                    .add(orderDetails.id);
                                              });
                                              await Provider.of<OrderProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateOrderStatus(
                                                orderModel.id,
                                                Provider.of<OrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .orderStatusType,
                                              );
                                            }
                                          },
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: ColorResources
                                                      .getSellerTxt(context),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(getTranslated(
                                                  'submit', context)))),
                                    ),
                                  ],
                                );
                              }),
                            ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
                    ],
                  )
                : NoDataScreen()
            : Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)));
      }),
    );
  }
}
