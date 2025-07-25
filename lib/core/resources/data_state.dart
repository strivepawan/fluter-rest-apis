

import '../error/api_exceptions.dart';

abstract class DataState<T> {
  final T? data;
  final ApiException? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(ApiException error) : super(error: error);
}