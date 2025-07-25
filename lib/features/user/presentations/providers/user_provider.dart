import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_clients.dart';
import '../../../../core/resources/data_state.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repositors.dart';


// 1. Create a provider for ApiClient (if not using a dedicated DI solution like get_it)
final apiClientProvider = Provider((ref) => ApiClient());

// 2. Create a provider for UserRepositoryImpl, depending on ApiClient
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(apiClientProvider));
});

// 3. Define the state for your UserNotifier
class UserState {
  final List<UserEntity> users;
  final bool isLoading;
  final String? errorMessage;

  UserState({
    this.users = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({
    List<UserEntity>? users,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// 4. Create the StateNotifier that holds and manages the user state
class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _userRepository;

  UserNotifier(this._userRepository) : super(UserState()); // Initial state

  Future<void> fetchUsers({int count = 5}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final dataState = await _userRepository.getUsers(count: count);

    if (dataState is DataSuccess) {
      state = state.copyWith(users: dataState.data, isLoading: false);
    } else if (dataState is DataFailed) {
      state = state.copyWith(isLoading: false, errorMessage: dataState.error?.message);
    }
  }
}

// 5. Create the StateNotifierProvider
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});