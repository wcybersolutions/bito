// lib/data/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/core_providers.dart';
import '../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/auth/send_magic_link_usecase.dart';
import '../../domain/usecases/auth/verify_magic_link_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/check_auth_status_usecase.dart';
import '../../domain/usecases/auth/google_sign_in_usecase.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../repositories/auth_repository.dart';

// ============================================================
// Data Source
// ============================================================
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient);
});

// ============================================================
// Repository
// ============================================================
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(remoteDataSource, secureStorage);
});

// ============================================================
// Use Cases
// ============================================================
final sendMagicLinkUseCaseProvider = Provider<SendMagicLinkUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SendMagicLinkUseCase(repository);
});

final verifyMagicLinkUseCaseProvider = Provider<VerifyMagicLinkUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyMagicLinkUseCase(repository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final checkAuthStatusUseCaseProvider = Provider<CheckAuthStatusUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CheckAuthStatusUseCase(repository);
});

final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GoogleSignInUseCase(repository);
});

// ============================================================
// State Providers
// ============================================================
final authStateProvider = FutureProvider<AuthUser?>((ref) async {
  final useCase = ref.watch(getCurrentUserUseCaseProvider);
  final result = await useCase.execute();
  return result.data;
});

final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final useCase = ref.watch(checkAuthStatusUseCaseProvider);
  final result = await useCase.execute();
  return result.data ?? false;
});

// ============================================================
// Auth State Notifier
// ============================================================
class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final IAuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> sendMagicLink(String email) async {
    state = const AsyncValue.loading();
    try {
      final params = SendMagicLinkParams(email: email);
      await _repository.sendMagicLink(params);
      // Keep loading state - waiting for verification
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> verifyMagicLink(String token) async {
    state = const AsyncValue.loading();
    try {
      final params = VerifyMagicLinkParams(token: token);
      final user = await _repository.verifyMagicLink(params);
      state = AsyncValue.data(user);
      _ref.invalidate(isAuthenticatedProvider);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logout();
      state = const AsyncValue.data(null);
      _ref.invalidate(isAuthenticatedProvider);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshUser() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      // Keep existing state
    }
  }

  bool get isAuthenticated => state.hasValue && state.value != null;
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository, ref);
});

