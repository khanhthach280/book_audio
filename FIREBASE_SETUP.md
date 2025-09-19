# Firebase Setup Guide

## 🔥 **Hướng dẫn thiết lập Firebase Authentication**

### 1. **Tạo Firebase Project**

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Nhấn "Create a project"
3. Nhập tên project: `book-audio-app`
4. Chọn "Enable Google Analytics" (tùy chọn)
5. Nhấn "Create project"

### 2. **Thêm Firebase vào Flutter App**

#### **Android Setup:**

1. **Thêm Firebase Android App:**
   - Trong Firebase Console, chọn "Add app" → Android
   - Package name: `com.example.book_audio` (hoặc package name của bạn)
   - App nickname: `Book Audio Android`
   - Nhấn "Register app"

2. **Tải file `google-services.json`:**
   - Tải file `google-services.json` từ Firebase Console
   - Đặt file vào thư mục `android/app/`

3. **Cập nhật `android/app/build.gradle`:**
   ```gradle
   // Thêm vào cuối file
   apply plugin: 'com.google.gms.google-services'
   ```

4. **Cập nhật `android/build.gradle`:**
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```

#### **iOS Setup:**

1. **Thêm Firebase iOS App:**
   - Trong Firebase Console, chọn "Add app" → iOS
   - Bundle ID: `com.example.bookAudio` (hoặc bundle ID của bạn)
   - App nickname: `Book Audio iOS`
   - Nhấn "Register app"

2. **Tải file `GoogleService-Info.plist`:**
   - Tải file `GoogleService-Info.plist` từ Firebase Console
   - Đặt file vào thư mục `ios/Runner/`

3. **Cập nhật `ios/Runner/Info.plist`:**
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSED_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

### 3. **Cấu hình Firebase Authentication**

1. **Bật Authentication:**
   - Trong Firebase Console, chọn "Authentication"
   - Chọn tab "Sign-in method"
   - Bật "Email/Password" provider
   - Nhấn "Save"

2. **Cấu hình Firestore Database:**
   - Chọn "Firestore Database"
   - Chọn "Create database"
   - Chọn "Start in test mode"
   - Chọn location gần nhất
   - Nhấn "Done"

### 4. **Cập nhật Firebase Configuration**

Cập nhật file `lib/core/firebase/firebase_options.dart` với thông tin thật từ Firebase Console:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'book-audio-app',
  storageBucket: 'book-audio-app.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: 'YOUR_IOS_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'book-audio-app',
  storageBucket: 'book-audio-app.appspot.com',
  iosBundleId: 'com.example.bookAudio',
);
```

### 5. **Cấu hình Firestore Security Rules**

Trong Firebase Console, chọn "Firestore Database" → "Rules":

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 6. **Test Firebase Integration**

1. **Chạy app:**
   ```bash
   flutter run
   ```

2. **Test đăng ký:**
   - Mở app → Splash → Login → Sign Up
   - Nhập thông tin và đăng ký
   - Kiểm tra trong Firebase Console → Authentication

3. **Test đăng nhập:**
   - Đăng nhập với tài khoản vừa tạo
   - Kiểm tra navigation đến Home screen

### 7. **Troubleshooting**

#### **Lỗi thường gặp:**

1. **"No Firebase App '[DEFAULT]' has been created":**
   - Đảm bảo đã gọi `Firebase.initializeApp()` trong `main()`
   - Kiểm tra file `google-services.json` và `GoogleService-Info.plist`

2. **"The email address is already in use":**
   - Email đã được sử dụng, thử email khác hoặc đăng nhập

3. **"The password is too weak":**
   - Mật khẩu phải có ít nhất 6 ký tự

4. **"Network error":**
   - Kiểm tra kết nối internet
   - Kiểm tra Firebase project configuration

#### **Debug Commands:**

```bash
# Clean và rebuild
flutter clean
flutter pub get
flutter run

# Check Firebase configuration
flutter doctor
```

### 8. **Production Setup**

1. **Cập nhật Firestore Rules cho production:**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

2. **Cấu hình Authentication settings:**
   - Bật email verification nếu cần
   - Cấu hình password policy
   - Thêm domain cho web (nếu có)

3. **Monitoring:**
   - Sử dụng Firebase Analytics
   - Monitor Authentication events
   - Set up alerts cho errors

---

## 🎉 **Kết quả**

Sau khi setup xong, bạn sẽ có:

- ✅ **Firebase Authentication** hoạt động
- ✅ **Đăng ký/Đăng nhập** với email/password
- ✅ **Lưu trữ user data** trong Firestore
- ✅ **Error handling** đầy đủ
- ✅ **State management** với Riverpod
- ✅ **Navigation flow** hoàn chỉnh

**App sẽ hoạt động thật với Firebase backend!** 🚀
