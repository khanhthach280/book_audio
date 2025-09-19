# Book Audio - Flutter App

A comprehensive Flutter application demonstrating Clean Architecture, state management with Riverpod, and modern Flutter development practices.

## 🚀 Features

### Core Features
- **Authentication Flow**: Complete login/logout with state management
- **Theme Management**: Dark/Light mode with system preference support
- **Localization**: Multi-language support (English/Vietnamese)
- **Splash Screen**: Animated splash with authentication state checking
- **Lazy Loading**: Infinite scroll with pull-to-refresh functionality
- **Error Handling**: Comprehensive network and local error management

### Technical Features
- **Clean Architecture**: Clear separation of concerns (Data, Domain, Presentation)
- **State Management**: Riverpod for reactive state management
- **Navigation**: GoRouter for declarative routing
- **Dependency Injection**: Riverpod providers for dependency management
- **Local Storage**: SharedPreferences and FlutterSecureStorage
- **Network Layer**: Dio with interceptors and error handling
- **Responsive UI**: Material Design 3 with custom theming

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── app/                        # App configuration
│   ├── constants/                  # App constants
│   ├── di/                         # Dependency injection
│   ├── errors/                     # Error handling
│   ├── network/                    # Network layer
│   ├── routing/                    # Navigation
│   ├── theme/                      # Theme management
│   └── utils/                      # Utility functions
├── features/                       # Feature modules
│   ├── auth/                       # Authentication feature
│   │   ├── data/                   # Data layer
│   │   ├── domain/                 # Domain layer
│   │   └── presentation/           # Presentation layer
│   ├── home/                       # Home feature
│   └── splash/                     # Splash feature
├── shared/                         # Shared components
│   └── widgets/                    # Reusable widgets
└── l10n/                          # Localization files
```

## 🛠️ Dependencies

### State Management
- `flutter_riverpod`: State management
- `riverpod_annotation`: Code generation for Riverpod

### Navigation
- `go_router`: Declarative routing

### Local Storage
- `shared_preferences`: Simple key-value storage
- `flutter_secure_storage`: Secure storage for sensitive data

### Network
- `dio`: HTTP client
- `connectivity_plus`: Network connectivity checking

### UI
- `flutter_svg`: SVG support
- `cupertino_icons`: iOS-style icons

### Utils
- `equatable`: Value equality
- `json_annotation`: JSON serialization
- `intl`: Internationalization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd book_audio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (if needed)
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### Clean Architecture Layers

#### Domain Layer
- **Entities**: Core business objects
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic implementation

#### Data Layer
- **Models**: Data transfer objects
- **Data Sources**: Remote and local data sources
- **Repository Implementations**: Concrete implementations

#### Presentation Layer
- **Screens**: UI screens
- **Widgets**: Reusable UI components
- **Providers**: State management with Riverpod

### State Management

The app uses Riverpod for state management with the following patterns:

- **StateNotifierProvider**: For complex state management
- **Provider**: For simple data providers
- **FutureProvider**: For async operations
- **StreamProvider**: For stream-based data

### Error Handling

Comprehensive error handling system:

- **Network Errors**: Timeout, no internet, server errors
- **Local Storage Errors**: SharedPreferences, SecureStorage failures
- **Authentication Errors**: Invalid credentials, auth failures
- **UI Error Display**: SnackBars, dialogs, error widgets

## 🎨 UI/UX Features

### Theme System
- **Material Design 3**: Modern design system
- **Dark/Light Mode**: Automatic and manual theme switching
- **Custom Colors**: Brand-specific color palette
- **Responsive Design**: Adaptive layouts for different screen sizes

### Localization
- **Multi-language**: English and Vietnamese support
- **Dynamic Language Switching**: Runtime language changes
- **RTL Support**: Right-to-left text support (if needed)

### Navigation
- **Declarative Routing**: GoRouter for type-safe navigation
- **Deep Linking**: Support for deep links
- **Route Guards**: Authentication-based route protection

## 📱 Features Implementation

### Authentication
- Login with email/password validation
- Secure token storage
- Authentication state persistence
- Automatic logout on token expiry

### Home Screen
- Book listing with lazy loading
- Pull-to-refresh functionality
- Search and filtering capabilities
- Favorite books management

### Splash Screen
- Animated logo and text
- Authentication state checking
- Smooth navigation transitions

## 🔧 Configuration

### Environment Setup
- Update `lib/core/constants/app_constants.dart` for API endpoints
- Configure theme colors in `lib/core/theme/app_colors.dart`
- Add new translations in `l10n/` directory

### Build Configuration
- Android: Update `android/app/build.gradle`
- iOS: Update `ios/Runner/Info.plist`
- Web: Update `web/index.html`

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod team for excellent state management
- Material Design team for the design system
- Open source community for various packages

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Note**: This is a demonstration project showcasing Flutter development best practices and Clean Architecture implementation.
