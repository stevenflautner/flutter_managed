import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator.dart';

text(String key) => get<Localization>().language.text(key);

class Language {

  final Locale locale;
  final Map<String, String> _strings;

  Language(this.locale, this._strings);

  String text(String key) => _strings[key];

}

class Localization extends LocalizationsDelegate<Language> {

  final List<String> supportedCodes;
  Language language;

  Localization({ @required this.supportedCodes });

  @override
  bool isSupported(Locale locale) => supportedCodes.contains(locale.languageCode);

  @override
  Future<Language> load(Locale locale) async {
    final stored = get<SharedPreferences>().getString("languageCode");
    if (stored != null) locale = Locale(stored);

    final language = Language(
      locale,
      jsonDecode(
        await rootBundle.loadString('lang/${locale.languageCode}.json')
      )
    );
    get<Localization>().language = language;

    return language;
  }

  @override
  bool shouldReload(Localization old) => false;

  Iterable<Locale> get supportedLocales => supportedCodes.map((code) => Locale(code));

}