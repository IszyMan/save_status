import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final ValueChanged<Locale> onLanguageSelected;
  final VoidCallback? onCompleted;

  const LanguageSelectionScreen({
    super.key,
    required this.onLanguageSelected,
    this.onCompleted,
  });

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'en';

  final List<_LanguageOption> _languages = const [
    _LanguageOption(
      code: 'en',
      name: 'English',
      flag: '🇬🇧',
    ),
    _LanguageOption(
      code: 'es',
      name: 'Español',
      flag: '🇪🇸',
    ),
    _LanguageOption(
      code: 'fr',
      name: 'Français',
      flag: '🇫🇷',
    ),
    _LanguageOption(
      code: 'de',
      name: 'Deutsch',
      flag: '🇩🇪',
    ),
    _LanguageOption(
      code: 'pt',
      name: 'Português',
      flag: '🇵🇹',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final preferences =
    await SharedPreferences.getInstance();

    final savedLanguage =
    preferences.getString('selected_language');

    if (!mounted) return;

    if (savedLanguage != null &&
        _languages.any(
              (language) => language.code == savedLanguage,
        )) {
      setState(() {
        _selectedLanguage = savedLanguage;
      });
    }
  }

  Locale _localeFromCode(String code) {
    return Locale(code);
  }

  Future<void> _continue() async {
    final preferences =
    await SharedPreferences.getInstance();

    await preferences.setString(
      'selected_language',
      _selectedLanguage,
    );

    if (!mounted) return;

    final locale =
    _localeFromCode(_selectedLanguage);

    widget.onLanguageSelected(locale);

    widget.onCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
    AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            40,
            24,
            24,
          ),
          child: Column(
            children: [
              // --------------------------------------------------------------
              // APP ICON
              // --------------------------------------------------------------

              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.10,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.download_rounded,
                  size: 42,
                  color: AppColors.accent,
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------------------
              // TITLE
              // --------------------------------------------------------------

              Text(
                localizations.chooseLanguage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                localizations.selectPreferredLanguage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // --------------------------------------------------------------
              // LANGUAGE LIST
              // --------------------------------------------------------------

              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final language =
                    _languages[index];

                    final selected =
                        _selectedLanguage ==
                            language.code;

                    return InkWell(
                      borderRadius:
                      BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          _selectedLanguage =
                              language.code;
                        });
                      },
                      child: AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 180,
                        ),
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 17,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              .withValues(
                            alpha: 0.10,
                          )
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.black
                                .withValues(
                              alpha: 0.08,
                            ),
                            width: selected
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              language.flag,
                              style:
                              const TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                language.name,
                                style:
                                TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                  selected
                                      ? FontWeight
                                      .w800
                                      : FontWeight
                                      .w600,
                                  color: AppColors
                                      .primaryDark,
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration:
                              const Duration(
                                milliseconds: 180,
                              ),
                              width: 24,
                              height: 24,
                              decoration:
                              BoxDecoration(
                                shape:
                                BoxShape.circle,
                                color: selected
                                    ? AppColors
                                    .primary
                                    : Colors
                                    .transparent,
                                border: Border.all(
                                  color: selected
                                      ? AppColors
                                      .primary
                                      : AppColors
                                      .textSecondary
                                      .withValues(
                                    alpha: 0.45,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: selected
                                  ? const Icon(
                                Icons.check,
                                size: 16,
                                color:
                                Colors.white,
                              )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------------------
              // CONTINUE
              // --------------------------------------------------------------

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continue,
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primary,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    localizations
                        .continueButton,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  final String code;
  final String name;
  final String flag;

  const _LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
  });
}