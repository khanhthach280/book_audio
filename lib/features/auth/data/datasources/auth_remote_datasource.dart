import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Abstract remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);
  
  final Dio _dio;
  
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw const ServerException(
          message: 'Login failed',
          code: 'LOGIN_FAILED',
        );
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw NetworkException(
        message: e.message ?? 'Network error occurred',
        code: e.response?.statusCode?.toString() ?? 'UNKNOWN',
      );
    } catch (e) {
      throw UnknownException(
        message: 'An unexpected error occurred',
        code: 'UNKNOWN',
      );
    }
  }
}
