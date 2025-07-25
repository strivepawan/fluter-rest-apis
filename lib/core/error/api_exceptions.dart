// lib/core/error/api_exceptions.dart

import 'dart:io';
import 'package:dio/dio.dart';

enum ErrorType {
  network,
  server,
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  conflict,
  unprocessableEntity,
  timeout,
  cancelled,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ErrorType type;
  final dynamic responseData; // Raw data from server error response

  ApiException({
    required this.message,
    this.statusCode,
    required this.type,
    this.responseData,
  });

  factory ApiException.fromDioException(DioException dioException) {
    String message = 'Something went wrong.';
    int? statusCode = dioException.response?.statusCode;
    ErrorType type = ErrorType.unknown;
    dynamic responseData = dioException.response?.data;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please check your internet or try again.';
        type = ErrorType.timeout;
        break;
      case DioExceptionType.badResponse:
        statusCode = dioException.response?.statusCode;
        responseData = dioException.response?.data;
        message = dioException.response?.statusMessage ?? 'Server error occurred.';
        // CORRECTED: Call the public method
        type = mapStatusCodeToErrorType(statusCode);

        // Attempt to parse common server-specific error messages
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('error') && responseData['error'] is String) {
            message = responseData['error']; // Common for randomuser.me errors
          } else if (responseData.containsKey('message') && responseData['message'] is String) {
            message = responseData['message'];
          } else if (responseData.containsKey('errors') && responseData['errors'] is Map) {
            final errorsMap = responseData['errors'] as Map;
            message = errorsMap.values.expand((e) => e as Iterable).join('\n');
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled.';
        type = ErrorType.cancelled;
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        type = ErrorType.network;
        break;
      case DioExceptionType.badCertificate:
        message = 'Bad SSL certificate.';
        type = ErrorType.server;
        break;
      case DioExceptionType.unknown:
      if (dioException.error is SocketException) {
          message = 'No internet connection. Please check your network.';
          type = ErrorType.network;
        } else {
          message = dioException.message ?? 'An unexpected error occurred.';
          type = ErrorType.unknown;
        }
        break;
    }
    return ApiException(
      message: message,
      statusCode: statusCode,
      type: type,
      responseData: responseData,
    );
  }

  // CORRECTED: Renamed from _mapStatusCodeToErrorType to make it public
  static ErrorType mapStatusCodeToErrorType(int? statusCode) {
    switch (statusCode) {
      case 400: return ErrorType.badRequest;
      case 401: return ErrorType.unauthorized;
      case 403: return ErrorType.forbidden;
      case 404: return ErrorType.notFound;
      case 409: return ErrorType.conflict;
      case 422: return ErrorType.unprocessableEntity;
      case 500:
      case 502:
      case 503:
      case 504: return ErrorType.server;
      default: return ErrorType.unknown;
    }
  }

  @override
  String toString() {
    return 'ApiException: Type: $type, Message: $message, StatusCode: $statusCode, ResponseData: $responseData';
  }
}
