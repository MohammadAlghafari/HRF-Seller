import '../datasource/remote/dio/dio_client.dart';
import 'package:flutter/material.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';
import '../model/response/shipping_model.dart';
import '../../utill/app_constants.dart';
class ShippingRepo{
  final DioClient dioClient;

  ShippingRepo({@required this.dioClient});


  Future<ApiResponse> getShipping() async {
    try {
      final response = await dioClient.get(AppConstants.SHOP_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getShippingMethod(String token) async {
    dioClient.dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      final response = await dioClient.get('${AppConstants.GET_SHIPPING_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> addShipping(ShippingModel shipping) async {
    try {
      final response = await dioClient.post(AppConstants.ADD_SHIPPING_URI,
          data: shipping);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> updateShipping(String title,String duration,double cost, int id) async {
    try {
      final response = await dioClient.post('${AppConstants.UPDATE_SHIPPING_URI}/$id',
          data: {'_method': 'put','title' : title, 'duration' : duration, 'cost' : cost});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> deleteShipping(int id) async {
    try {
      final response = await dioClient.delete('${AppConstants.DELETE_SHIPPING_URI}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}