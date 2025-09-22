import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/providers/color_scheme_provider.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/color_picker_widget.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Settings screen widget
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSectionHeader(context, l10n.theme),
          _buildThemeCard(context, ref, themeMode, l10n),
          
          const SizedBox(height: 24),
          
          // Language Section
          _buildSectionHeader(context, l10n.language),
          _buildLanguageCard(context, ref, locale, l10n),
          
          const SizedBox(height: 24),
          
          // Account Section
          _buildSectionHeader(context, l10n.account),
          _buildAccountCard(context, ref, l10n),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode themeMode,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.brightness_6, color: Theme.of(context).colorScheme.primary),
            title: Text(l10n.theme),
            subtitle: Text(_getThemeModeText(themeMode, l10n)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showThemeDialog(context, ref, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
            title: Text(l10n.language),
            subtitle: Text(_getLanguageText(locale, l10n)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(context, ref, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            title: Text(l10n.logout),
            subtitle: Text(l10n.signOutOfAccount),
            onTap: () => _showLogoutDialog(context, ref, l10n),
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(AppThemeMode themeMode, AppLocalizations l10n) {
    switch (themeMode) {
      case AppThemeMode.light:
        return l10n.lightMode;
      case AppThemeMode.dark:
        return l10n.darkMode;
      case AppThemeMode.custom:
        return l10n.customMode;
    }
  }

  String _getLanguageText(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'en':
        return l10n.english;
      case 'vi':
        return l10n.vietnamese;
      default:
        return l10n.english;
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final themeMode = ref.watch(themeModeProvider);
          final colorScheme = ref.watch(colorSchemeProvider);
          
          return AlertDialog(
            title: Text(l10n.theme),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Theme Mode Selection
                    Text(
                      l10n.themeMode,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<AppThemeMode>(
                      title: Text(l10n.lightMode),
                      value: AppThemeMode.light,
                      groupValue: themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          print('========== AppThemeMode.light');
                          ref.read(themeModeProvider.notifier).setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<AppThemeMode>(
                      title: Text(l10n.darkMode),
                      value: AppThemeMode.dark,
                      groupValue: themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          print('========== AppThemeMode.dark');
                          ref.read(themeModeProvider.notifier).setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<AppThemeMode>(
                      title: Text(l10n.customMode),
                      value: AppThemeMode.custom,
                      groupValue: themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          print('========== AppThemeMode.custom');
                          ref.read(themeModeProvider.notifier).setThemeMode(value);
                        }
                      },
                    ),
                
                // Only show color customization when custom mode is selected
                if (themeMode == AppThemeMode.custom) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Color Scheme Selection
                  Text(
                    l10n.colorScheme,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                
                // Predefined Color Schemes
                Text(
                  l10n.predefinedColorThemes,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Theme buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PredefinedColorSchemes.schemes.map((scheme) {
                    final isSelected = scheme.primary.value == colorScheme.primary.value &&
                        scheme.secondary.value == colorScheme.secondary.value &&
                        scheme.accent.value == colorScheme.accent.value;
                    
                    return GestureDetector(
                      onTap: () {
                        ref.read(colorSchemeProvider.notifier).applyPredefinedScheme(scheme);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              scheme.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Custom Color Pickers
                ColorPickerWidget(
                  title: l10n.primaryColor,
                  currentColor: colorScheme.primary,
                  predefinedColors: PredefinedColorSchemes.schemes
                      .map((scheme) => scheme.primary)
                      .toList(),
                  onColorChanged: (color) {
                    ref.read(colorSchemeProvider.notifier).setPrimaryColor(color);
                  },
                ),
                
                const SizedBox(height: 16),
                
                ColorPickerWidget(
                  title: l10n.secondaryColor,
                  currentColor: colorScheme.secondary,
                  predefinedColors: PredefinedColorSchemes.schemes
                      .map((scheme) => scheme.secondary)
                      .toList(),
                  onColorChanged: (color) {
                    ref.read(colorSchemeProvider.notifier).setSecondaryColor(color);
                  },
                ),
                
                const SizedBox(height: 16),
                
                ColorPickerWidget(
                  title: l10n.accentColor,
                  currentColor: colorScheme.accent,
                  predefinedColors: PredefinedColorSchemes.schemes
                      .map((scheme) => scheme.accent)
                      .toList(),
                  onColorChanged: (color) {
                    ref.read(colorSchemeProvider.notifier).setAccentColor(color);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Reset button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(colorSchemeProvider.notifier).resetToDefault();
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(l10n.resetToDefault),
                  ),
                ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.done),
          ),
        ],
      );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text(l10n.english),
              value: const Locale('en', 'US'),
              groupValue: ref.read(localeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.vietnamese),
              value: const Locale('vi', 'VN'),
              groupValue: ref.read(localeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.areYouSureLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authStateProvider.notifier).logout();
              
              if (context.mounted) {
                final authState = ref.read(authStateProvider);
                if (!authState.isAuthenticated) {
                  context.go('/splash');
                }
              }
            },
              child: Text(
                l10n.logout,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ),
        ],
      ),
    );
  }
}
