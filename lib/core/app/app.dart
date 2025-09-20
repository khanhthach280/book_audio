import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../utils/locale_provider.dart';
import '../routing/app_router.dart';
import '../../l10n/app_localizations.dart';
import '../utils/error_message_service.dart';

/// Main app widget
class App extends ConsumerWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp.router(
      title: 'Book Audio',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Localization configuration
      locale: locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Router configuration
      routerConfig: router,
      
      // Initialize ErrorMessageService when app builds
      builder: (context, child) {
        // Initialize ErrorMessageService with current localizations
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ErrorMessageService.initialize(AppLocalizations.of(context));
          }
        });
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
