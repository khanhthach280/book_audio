import 'package:flutter/material.dart';

/// App localizations class
class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  // English translations
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Book Audio',
      'welcome': 'Welcome',
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'forgotPassword': 'Forgot Password?',
      'dontHaveAccount': 'Don\'t have an account?',
      'alreadyHaveAccount': 'Already have an account?',
      'signUp': 'Sign Up',
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
      'theme': 'Theme',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'systemMode': 'System Mode',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'ok': 'OK',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'refresh': 'Refresh',
      'pullToRefresh': 'Pull to refresh',
      'noData': 'No data available',
      'noInternet': 'No internet connection',
      'serverError': 'Server error. Please try again later.',
      'networkError': 'Network error. Please check your connection.',
      'timeoutError': 'Request timeout. Please try again.',
      'invalidCredentials': 'Invalid credentials. Please check your login details.',
      'loginSuccess': 'Login successful',
      'loginFailed': 'Login failed',
      'logoutSuccess': 'Logout successful',
      'emailRequired': 'Email is required',
      'passwordRequired': 'Password is required',
      'invalidEmail': 'Please enter a valid email',
      'passwordTooShort': 'Password must be at least 6 characters',
      'passwordsDoNotMatch': 'Passwords do not match',
      'splashScreen': 'Splash Screen',
      'checkingAuth': 'Checking authentication...',
      'books': 'Books',
      'audioBooks': 'Audio Books',
      'favorites': 'Favorites',
      'recentlyPlayed': 'Recently Played',
      'categories': 'Categories',
      'authors': 'Authors',
      'play': 'Play',
      'pause': 'Pause',
      'stop': 'Stop',
      'next': 'Next',
      'previous': 'Previous',
      'volume': 'Volume',
      'speed': 'Speed',
      'bookmark': 'Bookmark',
      'share': 'Share',
      'download': 'Download',
      'remove': 'Remove',
      'playlist': 'Playlist',
      'addToPlaylist': 'Add to Playlist',
      'removeFromPlaylist': 'Remove from Playlist',
      'createPlaylist': 'Create Playlist',
      'playlistName': 'Playlist Name',
      'playlistDescription': 'Playlist Description',
      'myPlaylists': 'My Playlists',
      'publicPlaylists': 'Public Playlists',
      'privatePlaylists': 'Private Playlists',
      'account': 'Account',
      'signOutOfAccount': 'Sign out of your account',
      'areYouSureLogout': 'Are you sure you want to sign out?',
    },
    'vi': {
      'appTitle': 'Sách Nói',
      'welcome': 'Chào mừng',
      'login': 'Đăng nhập',
      'logout': 'Đăng xuất',
      'email': 'Email',
      'password': 'Mật khẩu',
      'confirmPassword': 'Xác nhận mật khẩu',
      'forgotPassword': 'Quên mật khẩu?',
      'dontHaveAccount': 'Chưa có tài khoản?',
      'alreadyHaveAccount': 'Đã có tài khoản?',
      'signUp': 'Đăng ký',
      'home': 'Trang chủ',
      'profile': 'Hồ sơ',
      'settings': 'Cài đặt',
      'theme': 'Giao diện',
      'language': 'Ngôn ngữ',
      'darkMode': 'Chế độ tối',
      'lightMode': 'Chế độ sáng',
      'systemMode': 'Chế độ hệ thống',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'loading': 'Đang tải...',
      'error': 'Lỗi',
      'success': 'Thành công',
      'retry': 'Thử lại',
      'cancel': 'Hủy',
      'ok': 'OK',
      'save': 'Lưu',
      'delete': 'Xóa',
      'edit': 'Chỉnh sửa',
      'add': 'Thêm',
      'search': 'Tìm kiếm',
      'refresh': 'Làm mới',
      'pullToRefresh': 'Kéo để làm mới',
      'noData': 'Không có dữ liệu',
      'noInternet': 'Không có kết nối internet',
      'serverError': 'Lỗi máy chủ. Vui lòng thử lại sau.',
      'networkError': 'Lỗi mạng. Vui lòng kiểm tra kết nối.',
      'timeoutError': 'Hết thời gian chờ. Vui lòng thử lại.',
      'invalidCredentials': 'Thông tin đăng nhập không hợp lệ. Vui lòng kiểm tra lại.',
      'loginSuccess': 'Đăng nhập thành công',
      'loginFailed': 'Đăng nhập thất bại',
      'logoutSuccess': 'Đăng xuất thành công',
      'emailRequired': 'Email là bắt buộc',
      'passwordRequired': 'Mật khẩu là bắt buộc',
      'invalidEmail': 'Vui lòng nhập email hợp lệ',
      'passwordTooShort': 'Mật khẩu phải có ít nhất 6 ký tự',
      'passwordsDoNotMatch': 'Mật khẩu không khớp',
      'splashScreen': 'Màn hình khởi động',
      'checkingAuth': 'Đang kiểm tra xác thực...',
      'books': 'Sách',
      'audioBooks': 'Sách nói',
      'favorites': 'Yêu thích',
      'recentlyPlayed': 'Đã phát gần đây',
      'categories': 'Danh mục',
      'authors': 'Tác giả',
      'play': 'Phát',
      'pause': 'Tạm dừng',
      'stop': 'Dừng',
      'next': 'Tiếp theo',
      'previous': 'Trước đó',
      'volume': 'Âm lượng',
      'speed': 'Tốc độ',
      'bookmark': 'Đánh dấu',
      'share': 'Chia sẻ',
      'download': 'Tải xuống',
      'remove': 'Xóa',
      'playlist': 'Danh sách phát',
      'addToPlaylist': 'Thêm vào danh sách phát',
      'removeFromPlaylist': 'Xóa khỏi danh sách phát',
      'createPlaylist': 'Tạo danh sách phát',
      'playlistName': 'Tên danh sách phát',
      'playlistDescription': 'Mô tả danh sách phát',
      'myPlaylists': 'Danh sách phát của tôi',
      'publicPlaylists': 'Danh sách phát công khai',
      'privatePlaylists': 'Danh sách phát riêng tư',
      'account': 'Tài khoản',
      'signOutOfAccount': 'Đăng xuất khỏi tài khoản của bạn',
      'areYouSureLogout': 'Bạn có chắc chắn muốn đăng xuất không?',
    },
  };
  
  String _getText(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']![key]!;
  }
  
  // Getters for all translations
  String get appTitle => _getText('appTitle');
  String get welcome => _getText('welcome');
  String get login => _getText('login');
  String get logout => _getText('logout');
  String get email => _getText('email');
  String get password => _getText('password');
  String get confirmPassword => _getText('confirmPassword');
  String get forgotPassword => _getText('forgotPassword');
  String get dontHaveAccount => _getText('dontHaveAccount');
  String get alreadyHaveAccount => _getText('alreadyHaveAccount');
  String get signUp => _getText('signUp');
  String get home => _getText('home');
  String get profile => _getText('profile');
  String get settings => _getText('settings');
  String get theme => _getText('theme');
  String get language => _getText('language');
  String get darkMode => _getText('darkMode');
  String get lightMode => _getText('lightMode');
  String get systemMode => _getText('systemMode');
  String get english => _getText('english');
  String get vietnamese => _getText('vietnamese');
  String get loading => _getText('loading');
  String get error => _getText('error');
  String get success => _getText('success');
  String get retry => _getText('retry');
  String get cancel => _getText('cancel');
  String get ok => _getText('ok');
  String get save => _getText('save');
  String get delete => _getText('delete');
  String get edit => _getText('edit');
  String get add => _getText('add');
  String get search => _getText('search');
  String get refresh => _getText('refresh');
  String get pullToRefresh => _getText('pullToRefresh');
  String get noData => _getText('noData');
  String get noInternet => _getText('noInternet');
  String get serverError => _getText('serverError');
  String get networkError => _getText('networkError');
  String get timeoutError => _getText('timeoutError');
  String get invalidCredentials => _getText('invalidCredentials');
  String get loginSuccess => _getText('loginSuccess');
  String get loginFailed => _getText('loginFailed');
  String get logoutSuccess => _getText('logoutSuccess');
  String get emailRequired => _getText('emailRequired');
  String get passwordRequired => _getText('passwordRequired');
  String get invalidEmail => _getText('invalidEmail');
  String get passwordTooShort => _getText('passwordTooShort');
  String get passwordsDoNotMatch => _getText('passwordsDoNotMatch');
  String get splashScreen => _getText('splashScreen');
  String get checkingAuth => _getText('checkingAuth');
  String get books => _getText('books');
  String get audioBooks => _getText('audioBooks');
  String get favorites => _getText('favorites');
  String get recentlyPlayed => _getText('recentlyPlayed');
  String get categories => _getText('categories');
  String get authors => _getText('authors');
  String get play => _getText('play');
  String get pause => _getText('pause');
  String get stop => _getText('stop');
  String get next => _getText('next');
  String get previous => _getText('previous');
  String get volume => _getText('volume');
  String get speed => _getText('speed');
  String get bookmark => _getText('bookmark');
  String get share => _getText('share');
  String get download => _getText('download');
  String get remove => _getText('remove');
  String get playlist => _getText('playlist');
  String get addToPlaylist => _getText('addToPlaylist');
  String get removeFromPlaylist => _getText('removeFromPlaylist');
  String get createPlaylist => _getText('createPlaylist');
  String get playlistName => _getText('playlistName');
  String get playlistDescription => _getText('playlistDescription');
  String get myPlaylists => _getText('myPlaylists');
  String get publicPlaylists => _getText('publicPlaylists');
  String get privatePlaylists => _getText('privatePlaylists');
  String get account => _getText('account');
  String get signOutOfAccount => _getText('signOutOfAccount');
  String get areYouSureLogout => _getText('areYouSureLogout');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
