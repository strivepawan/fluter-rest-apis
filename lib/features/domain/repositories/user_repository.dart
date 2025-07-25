

import '../../../core/resources/data_state.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<DataState<List<UserEntity>>> getUsers({int count = 5});
}