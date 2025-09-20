# Error Handling Guide

## Tổng quan

Hệ thống xử lý lỗi đã được cập nhật để tập trung hóa và hỗ trợ đa ngôn ngữ (localization). Tất cả các error messages sẽ được xử lý thông qua `ErrorHandler` và `ErrorMessageService`.

## Cấu trúc

### 1. ErrorMessageService
- **File**: `lib/core/utils/error_message_service.dart`
- **Chức năng**: Quản lý localized error messages
- **Sử dụng**: Được khởi tạo tự động trong `App` widget

### 2. ErrorHandler
- **File**: `lib/core/utils/error_handler.dart`
- **Chức năng**: Cung cấp các method để hiển thị error UI
- **Methods**:
  - `showErrorSnackBar()`: Hiển thị error snackbar
  - `showSuccessSnackBar()`: Hiển thị success snackbar
  - `showErrorDialog()`: Hiển thị error dialog
  - `getErrorMessage()`: Lấy localized error message

### 3. AuthProviders
- **File**: `lib/features/auth/presentation/providers/auth_providers.dart`
- **Cập nhật**: Sử dụng `ErrorMessageService` để xử lý error messages

### 4. DioClient
- **File**: `lib/core/network/dio_client.dart`
- **Cập nhật**: Sử dụng `ErrorMessageService` cho API error messages

## Cách sử dụng

### 1. Trong UI Components

```dart
import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Show error snackbar
        ErrorHandler.showErrorSnackBar(
          context,
          'Something went wrong!',
        );
      },
      child: Text('Show Error'),
    );
  }
}
```

### 2. Với Failure Objects

```dart
import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../core/errors/failures.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final failure = InvalidCredentialsFailure(
          message: 'Invalid credentials',
          code: '401',
        );
        
        // Get localized error message
        final errorMessage = ErrorHandler.getErrorMessage(context, failure);
        
        // Show error
        ErrorHandler.showErrorSnackBar(context, errorMessage);
      },
      child: Text('Show Localized Error'),
    );
  }
}
```

### 3. Trong Providers/Notifiers

```dart
import '../../core/utils/error_message_service.dart';

class MyNotifier extends StateNotifier<MyState> {
  void handleError(Failure failure) {
    // Get localized error message
    final errorMessage = ErrorMessageService.getErrorMessage(
      failure.runtimeType.toString(),
    );
    
    // Update state with error
    state = state.copyWith(error: errorMessage);
  }
}
```

## Localization

### Error Messages được hỗ trợ

| Failure Type | English | Vietnamese |
|--------------|---------|------------|
| NoInternetFailure | "No internet connection" | "Không có kết nối internet" |
| NetworkFailure | "Network error. Please try again." | "Lỗi mạng. Vui lòng kiểm tra kết nối." |
| ServerFailure | "Server error. Please try again later." | "Lỗi máy chủ. Vui lòng thử lại sau." |
| TimeoutFailure | "Request timeout. Please try again." | "Hết thời gian chờ. Vui lòng thử lại." |
| InvalidCredentialsFailure | "Invalid credentials. Please check your login details." | "Thông tin đăng nhập không hợp lệ. Vui lòng kiểm tra lại." |
| AuthFailure | "Login failed" | "Đăng nhập thất bại" |

### Thêm Error Message mới

1. Thêm vào `lib/l10n/app_localizations.dart`:
```dart
// English
'newError': 'New error message',

// Vietnamese  
'newError': 'Thông báo lỗi mới',
```

2. Thêm getter trong `AppLocalizations`:
```dart
String get newError => _getText('newError');
```

3. Cập nhật `ErrorMessageService`:
```dart
case 'NewFailure':
  return l10n.newError;
```

## Lưu ý quan trọng

1. **Khởi tạo**: `ErrorMessageService` được khởi tạo tự động trong `App` widget
2. **Context**: Khi sử dụng `ErrorHandler.getErrorMessage()`, cần có `BuildContext`
3. **Fallback**: Nếu không có localization, sẽ fallback về English
4. **Consistency**: Tất cả error messages đều đi qua hệ thống này để đảm bảo consistency

## Ví dụ hoàn chỉnh

Xem file `lib/core/utils/error_handler_example.dart` để có ví dụ chi tiết về cách sử dụng.
