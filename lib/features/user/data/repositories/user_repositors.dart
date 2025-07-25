// lib/features/user/data/repositories/user_repository_impl.dart

import 'package:dio/dio.dart';

import '../../../../../core/constants/api_endpoinst.dart';
import '../../../../../core/error/api_exceptions.dart';
import '../../../../../core/network/api_clients.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/user_repository.dart';
import '../modal/user_response_model.dart';


class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<DataState<List<UserEntity>>> getUsers({int count = 5}) async {
    try {
      final response = await _apiClient.dio.get('${ApiEndpoints.users}$count');

      if (response.statusCode == 200) {
        final UserResponseModel userResponse = UserResponseModel.fromJson(response.data);
        final List<UserEntity> users = userResponse.results.map((model) => model.toEntity()).toList();
        return DataSuccess(users);
      } else {
        // This block might be hit if the server returns a non-200 but Dio doesn't throw
        return DataFailed(
          ApiException(
            message: response.statusMessage ?? 'Failed to load users from server.',
            statusCode: response.statusCode,
            // CORRECTED: Call the public method
            type: ApiException.mapStatusCodeToErrorType(response.statusCode),
            responseData: response.data,
          ),
        );
      }
    } on DioException catch (e) {
      // Dio will throw DioException for 4xx/5xx responses and network errors
      return DataFailed(ApiException.fromDioException(e));
    } catch (e) {
      // Catch any other unexpected errors during parsing or general runtime
      return DataFailed(
        ApiException(
          message: 'An unexpected error occurred: ${e.toString()}',
          type: ErrorType.unknown,
        ),
      );
    }
  }
}
