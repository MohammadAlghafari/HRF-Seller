import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'di_container.dart' as di;
import 'localization/app_localization.dart';
import 'notification/my_notification.dart';
import 'provider/auth_provider.dart';
import 'provider/bank_info_provider.dart';
import 'provider/business_provider.dart';
import 'provider/chat_provider.dart';
import 'provider/language_provider.dart';
import 'provider/localization_provider.dart';
import 'provider/notification_provider.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';
import 'provider/product_review_provider.dart';
import 'provider/profile_provider.dart';
import 'provider/restaurant_provider.dart';
import 'provider/shipping_provider.dart';
import 'provider/shop_info_provider.dart';
import 'provider/splash_provider.dart';
import 'provider/theme_provider.dart';
import 'provider/transaction_provider.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';
import 'utill/app_constants.dart';
import 'view/screens/order/order_details_screen.dart';
import 'view/screens/splash/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  if(Platform.isIOS)
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  int _orderID;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    _orderID = (notificationAppLaunchDetails.payload != null && notificationAppLaunchDetails.payload.isNotEmpty)
        ? int.parse(notificationAppLaunchDetails.payload) : null;
  }
  await MyNotification.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ShopProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BankInfoProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BusinessProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TransactionProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<RestaurantProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductReviewProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ShippingProvider>()),
    ],
    child: MyApp(orderId: _orderID),
  ));
}

class MyApp extends StatelessWidget {
  final int orderId;
  MyApp({@required this.orderId});
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return MaterialApp(
      title: 'HRF Vendors',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _locals,
      home: orderId == null ? SplashScreen() : OrderDetailsScreen(orderModel: null, orderId: orderId),
    );
  }
}
