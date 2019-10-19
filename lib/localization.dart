import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator.dart';

text(String key) => get<Localizator>().localization.text(key);

class Localization {

  final Locale locale;
  final Map<String, String> _strings;

  Localization(this.locale, this._strings);

  String text(String key) => _strings[key];

}

class Localizator extends LocalizationsDelegate<Localization> {

  final List<String> supportedCodes;
  Localization localization;

  Localizator({ @required this.supportedCodes });

  @override
  bool isSupported(Locale locale) => supportedCodes.contains(locale.languageCode);

  static Locale forcedLocale() {
    final stored = get<SharedPreferences>().getString("languageCode");
    if (stored != null) return Locale(stored);
    return null;
  }

  @override
  Future<Localization> load(Locale locale) async {
    final localization = Localization(
      locale,
      jsonDecode(
        await rootBundle.loadString('lang/${locale.languageCode}.json')
      )
    );
    get<Localizator>().localization = localization;

    return localization;
  }

  @override
  bool shouldReload(Localizator old) => false;

  Iterable<Locale> get supportedLocales => supportedCodes.map((code) => Locale(code));

}