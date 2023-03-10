import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/price_converter.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/bank_info_provider.dart';
import '../../../provider/order_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../notification/notification_screen.dart';
import 'widget/order_type_button.dart';
import 'widget/order_type_button_head.dart';
import 'widget/transaction_chart.dart';

class HomeScreen extends StatelessWidget {
  final Function callback;
  HomeScreen({@required this.callback});

  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<BankInfoProvider>(context, listen: false)
        .getUserEarnings(context);
    await Provider.of<BankInfoProvider>(context, listen: false)
        .getUserCommissions(context);
    await Provider.of<ProfileProvider>(context, listen: false)
        .getSellerInfo(context);
    await Provider.of<BankInfoProvider>(context, listen: false)
        .getBankInfo(context);
    await Provider.of<OrderProvider>(context, listen: false)
        .getOrderList(context);
    await Provider.of<SplashProvider>(context, listen: false).getColorList();
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context, false);

    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 0,
        title: Row(
          children: [
            Image.asset(
              Images.logo_blue,
              height: 40,
              width: 40,
              color:
                  Provider.of<ThemeProvider>(context, listen: false).darkTheme
                      ? ColorResources.WHITE
                      : Theme.of(context).primaryColor,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(width: 10),
            //Text(AppConstants.APP_NAME, style: titilliumBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NotificationScreen()));
                },
                icon: Icon(Icons.notifications,
                    color: Provider.of<ThemeProvider>(context, listen: false)
                            .darkTheme
                        ? ColorResources.WHITE
                        : Theme.of(context).primaryColor))
          ],
        ),
        backgroundColor: ColorResources.getBottomSheetColor(context),
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          return order.orderList != null
              ? SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _loadData(context, true);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // for restaurant view

                          order.pendingList != null
                              ? Consumer<OrderProvider>(
                                  builder: (context, orderProvider, child) =>
                                      Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    child: SizedBox(
                                      height: MediaQuery.of(context)
                                              .size
                                              .width -
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridView.count(
                                          crossAxisCount: 2,
                                          shrinkWrap: true,
                                          children: [
                                            OrderTypeButtonHead(
                                              color: Color(0xFF3E215D),
                                              text: getTranslated(
                                                  'pending', context),
                                              index: 1,
                                              subText: getTranslated(
                                                  'orders', context),
                                              orderList:
                                                  orderProvider.pendingList,
                                              callback: callback,
                                            ),
                                            OrderTypeButtonHead(
                                              color: Color(0xFF053742),
                                              text: getTranslated(
                                                  'processing', context),
                                              index: 2,
                                              orderList:
                                                  orderProvider.processing,
                                              callback: callback,
                                              subText: getTranslated(
                                                  'orders', context),
                                            ),
                                            OrderTypeButtonHead(
                                              color: Color(0xFF001E6C),
                                              text: getTranslated(
                                                  'confirmed', context),
                                              index: 7,
                                              subText: getTranslated(
                                                  'orders', context),
                                              orderList:
                                                  orderProvider.confirmedList,
                                              callback: callback,
                                            ),
                                            OrderTypeButtonHead(
                                              color: Color(0xFF343A40),
                                              text: getTranslated(
                                                  'out_for_delivery', context),
                                              index: 8,
                                              subText: '',
                                              orderList: orderProvider
                                                  .outForDeliveryList,
                                              callback: callback,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 150,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Theme.of(context)
                                                  .primaryColor)))),

                          order.pendingList != null
                              ? Consumer<OrderProvider>(
                                  builder: (context, orderProvider, child) =>
                                      Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    child: SizedBox(
                                      height: 100,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          OrderTypeButton(
                                            text: getTranslated(
                                                'delivered', context),
                                            index: 3,
                                            orderList:
                                                orderProvider.deliveredList,
                                            callback: callback,
                                          ),
                                          OrderTypeButton(
                                            text: getTranslated(
                                                'cancelled', context),
                                            index: 6,
                                            orderList:
                                                orderProvider.canceledList,
                                            callback: callback,
                                          ),
                                          OrderTypeButton(
                                            text: getTranslated(
                                                'return', context),
                                            index: 4,
                                            orderList: orderProvider.returnList,
                                            callback: callback,
                                          ),
                                          OrderTypeButton(
                                            text: getTranslated(
                                                'failed', context),
                                            index: 5,
                                            orderList: orderProvider.failedList,
                                            callback: callback,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 150,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Theme.of(context)
                                                  .primaryColor)))),

                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Consumer<BankInfoProvider>(
                                builder: (context, bankInfo, child) {
                              List<double> _earnings = [];
                              List<double> _commissions = [];
                              for (double earn in bankInfo.userCommissions) {
                                _earnings.add(PriceConverter.convertAmount(
                                    earn, context));
                              }
                              for (double commission in bankInfo.userEarnings) {
                                _commissions.add(PriceConverter.convertAmount(
                                    commission, context));
                              }
                              List<double> _counts = [];
                              List<double> _comCounts = [];
                              _counts.addAll(_earnings);
                              _comCounts.addAll(_commissions);
                              _counts.sort();
                              _comCounts.sort();
                              double _lim = 0.0;
                              double _max = _counts[_counts.length - 1];
                              double _maxx = _comCounts[_comCounts.length - 1];
                              if (_max > _maxx) {
                                _lim = _max;
                              } else {
                                _lim = _maxx;
                              }
                              return TransactionChart(
                                  earnings: _earnings,
                                  commissions: _commissions,
                                  max: _lim);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
