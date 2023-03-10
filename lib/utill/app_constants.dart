

import '../data/model/response/language_model.dart';
import 'images.dart';

class AppConstants {

  static const String APP_NAME = 'HRF';
  static const String BASE_URL = 'https://hrfhome.app';
  static const String LOGIN_URI = '/api/v2/seller/auth/login';
  static const String CONFIG_URI = '/api/v1/config';
  static const String SELLER_URI = '/api/v2/seller/seller-info';
  static const String DELETE_ACCOUNT_URI = '/api/v2/seller/delete_account';
  static const String USER_EARNINGS_URI = '/api/v2/seller/monthly-earning';
  static const String SELLER_AND_BANK_UPDATE = '/api/v2/seller/seller-update';
  static const String SHOP_URI = '/api/v2/seller/shop-info';
  static const String SHOP_UPDATE = '/api/v2/seller/shop-update';
  static const String MESSAGE_URI = '/api/v2/seller/messages/list';
  static const String TOKEN_URI = '/api/v2/seller/cm-firebase-token';
  static const String SEND_MESSAGE_URI = '/api/v2/seller/messages/send';
  static const String NOTIFICATION_URI = '/api/v2/seller/notifications';
  static const String ORDER_LIST_URI = '/api/v2/seller/orders/list';
  static const String ORDER_DETAILS = '/api/v2/seller/orders/';
  static const String UPDATE_ORDER_STATUS = '/api/v2/seller/orders/order-detail-status/';
  static const String UPDATE_ORDER_PAID_STATUS = '/api/v2/seller/orders/order-payment-status/';
  static const String BALANCE_WITHDRAW = '/api/v2/seller/balance-withdraw';
  static const String CANCEL_BALANCE_REQUEST = '/api/v2/seller/close-withdraw-request';
  static const String TRANSACTIONS_URI = '/api/v2/seller/transactions';
  static const String SELLER_PRODUCT_URI = '/api/v1/seller/';
  static const String PRODUCT_REVIEW_URI = '/api/v2/seller/shop-product-reviews';
  static const String ATTRIBUTE_URI = '/api/v1/attributes';
  static const String BRAND_URI = '/api/v1/brands/';
  static const String CATEGORY_URI = '/api/v1/categories/';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  static const String SUB_SUB_CATEGORY_URI = '/api/v1/categories/childes/childes/';
  static const String ADD_PRODUCT_URI = '/api/v2/seller/products/add';
  static const String UPLOAD_PRODUCT_IMAGE_URI = '/api/v2/seller/products/upload-images';
  static const String UPDATE_PRODUCT_URI = '/api/v2/seller/products/update';
  static const String DELETE_PRODUCT_URI = '/api/v2/seller/products/delete';
  static const String MONTHLY_COMMISSION_GIVEN_URI = '/api/v2/seller/monthly-commission-given';
  static const String EDIT_PRODUCT_URI = '/api/v2/seller/products/edit';
  static const String ADD_SHIPPING_URI = '/api/v2/seller/shipping-method/add';
  static const String UPDATE_SHIPPING_URI = '/api/v2/seller/shipping-method/update';
  static const String EDIT_SHIPPING_URI = '/api/v2/seller/shipping-method/edit';
  static const String DELETE_SHIPPING_URI = '/api/v2/seller/shipping-method/delete';
  static const String GET_SHIPPING_URI = '/api/v2/seller/shipping-method/list';



  static const String PENDING = 'pending';
  static const String CONFIRMED = 'confirmed';
  static const String PROCESSING = 'processing';
  static const String PROCESSED = 'processed';
  static const String DELIVERED = 'delivered';
  static const String FAILED = 'failed';
  static const String RETURNED = 'returned';
  static const String CANCELLED = 'canceled';
  static const String OUT_FOR_DELIVERY = 'out_for_delivery';
  // static const String OUT_DELIVERY = 'out for delivery';


  static const String THEME = 'theme';
  static const String CURRENCY = 'currency';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_NUMBER = 'user_number';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'HRF';
  static const String USER_EMAIL = 'user_email';
  static const String LANG_KEY = 'lang';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.united_kindom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'AE', languageCode: 'ar'),
  ];
}
