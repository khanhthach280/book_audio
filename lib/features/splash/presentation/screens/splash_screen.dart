import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  bool _isCheckingConnectivity = true;
  bool _hasInternet = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _textController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
  }

  void _startAnimations() async {
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _textController.forward();

    await _checkConnectivity();

    if (mounted) {
      if (_hasInternet) {
        await Future.delayed(const Duration(milliseconds: 1000));
        _navigateToNextScreen();
      } else {
        setState(() {
          _isCheckingConnectivity = false;
        });
      }
    }
  }

  Future<void> _checkConnectivity() async {
    final networkInfo = ref.read(networkInfoProvider);
    final isConnected = await networkInfo.isConnected;

    if (mounted) {
      setState(() {
        _hasInternet = isConnected;
        _isCheckingConnectivity = false;
      });
    }
  }

  void _navigateToNextScreen() {
    final authState = ref.read(authStateProvider);

    if (authState.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.library_books,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // App Title Animation
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _textAnimation.value)),
                    child: Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Status Indicator
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Column(
                    children: [
                      if (_isCheckingConnectivity) ...[
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.checkingConnection,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.8),
                              ),
                        ),
                      ] else if (!_hasInternet) ...[
                        const Icon(
                          Icons.wifi_off,
                          color: AppColors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noInternetConnection,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.8),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.checkConnectionAndRetry,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.6),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isCheckingConnectivity = true;
                              _hasInternet = false;
                            });
                            _startAnimations();
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(l10n.retryConnection),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.checkingAuth,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.8),
                              ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
