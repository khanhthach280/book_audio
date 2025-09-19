import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Abstract local data source for authentication
abstract class AuthLocalDataSource {
  Future<UserModel?> getCurrentUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(
    this._prefs,
    this._secureStorage,
  );
  
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userJson = _prefs.getString(AppConstants.userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw LocalStorageException(
        message: 'Failed to get current user',
        code: 'GET_USER_FAILED',
      );
    }
  }
  
  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(AppConstants.userKey, userJson);
    } catch (e) {
      throw LocalStorageException(
        message: 'Failed to save user',
        code: 'SAVE_USER_FAILED',
      );
    }
  }
  
  @override
  Future<void> clearUser() async {
    try {
      await _prefs.remove(AppConstants.userKey);
    } catch (e) {
      throw LocalStorageException(
        message: 'Failed to clear user',
        code: 'CLEAR_USER_FAILED',
      );
    }
  }
  
  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: AppConstants.tokenKey, value: token);
    } catch (e) {
      throw LocalStorageException(
        message: 'Failed to save token',
        code: 'SAVE_TOKEN_FAILED',
      );
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: AppConstants.tokenKey);
    } catch (e) {
      throw LocalStorageException(
        message: 'Failed to get token',
        code: 'GET_TOKEN_FAILED',
      );
    }
  }
  
  @override
  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: AppConstants.tokenKey);
    } catch (e) {
      throw LocalStorageException(
        message: 'Failed to clear token',
        code: 'CLEAR_TOKEN_FAILED',
      );
    }
  }
}
