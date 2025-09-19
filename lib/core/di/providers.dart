import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../firebase/firebase_auth_service.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

/// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// FlutterSecureStorage provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
});

/// Dio provider
final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

/// Connectivity provider
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// NetworkInfo provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.read(connectivityProvider));
});

/// Firebase Auth Service provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  print('========= firebaseAuthServiceProvider');
  return FirebaseAuthService();
});

/// Auth local data source provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    ref.read(sharedPreferencesProvider),
    ref.read(secureStorageProvider),
  );
});

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(firebaseAuthServiceProvider),
    ref.read(authLocalDataSourceProvider),
    ref.read(networkInfoProvider),
  );
});
