import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';
import '../../utill/app_constants.dart';


class ProductRepo {
  final DioClient dioClient;
  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getSellerProductList(String sellerId, int offset, String languageCode ) async {
    try {
      final response = await dioClient.get(
        AppConstants.SELLER_PRODUCT_URI+sellerId+'/products?limit=10&&offset=$offset',
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}