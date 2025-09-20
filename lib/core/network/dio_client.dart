import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../utils/error_message_service.dart';

/// Dio client configuration for API calls
class DioClient {
  static Dio? _dio;
  
  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }
  
  static Dio _createDio() {
    final dio = Dio();
    
    // Base options
    dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    
    // Interceptors
    dio.interceptors.addAll([
      _LogInterceptor(),
      _ErrorInterceptor(),
    ]);
    
    return dio;
  }
}

/// Logging interceptor for debugging
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Data: ${options.data}');
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('Data: ${response.data}');
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Message: ${err.message}');
    super.onError(err, handler);
  }
}

/// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException exception;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = TimeoutException(
          message: ErrorMessageService.getErrorMessage('TimeoutFailure'),
          code: 'TIMEOUT',
        );
        break;
      case DioExceptionType.connectionError:
        exception = NoInternetException(
          message: ErrorMessageService.getErrorMessage('NoInternetFailure'),
          code: 'NO_INTERNET',
        );
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            exception = ServerException(
              message: ErrorMessageService.getErrorMessage('ServerFailure'),
              code: statusCode.toString(),
            );
          } else if (statusCode == 401) {
            exception = InvalidCredentialsException(
              message: ErrorMessageService.getErrorMessage('InvalidCredentialsFailure'),
              code: '401',
            );
          } else {
            exception = NetworkException(
              message: ErrorMessageService.getErrorMessage('NetworkFailure'),
              code: statusCode.toString(),
            );
          }
        } else {
          exception = NetworkException(
            message: ErrorMessageService.getErrorMessage('NetworkFailure'),
            code: 'UNKNOWN',
          );
        }
        break;
      default:
        exception = UnknownException(
          message: ErrorMessageService.getErrorMessage('UnknownFailure'),
          code: 'UNKNOWN',
        );
    }
    
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: exception,
      type: err.type,
    ));
  }
}
