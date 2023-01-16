import 'package:flutter/material.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';
import '../../utill/app_constants.dart';

class ProductReviewRepo {
  final DioClient dioClient;
  ProductReviewRepo({@required this.dioClient});

  Future<ApiResponse> productReviewList() async {
    try {
      final response = await dioClient.get(AppConstants.PRODUCT_REVIEW_URI,
        // options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}