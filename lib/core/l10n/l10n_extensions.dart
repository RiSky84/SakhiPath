import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw Exception('AppLocalizations not found in context');
    }
    return localizations;
  }

  String tr(String key) {
    return l10n.translate(key);
  }
}
